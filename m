Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8B3F929C;
	Sat, 12 Sep 2026 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205171; cv=none; b=dO7isQ6VhuGAkhTPubVwNbqNLyTvwr/injczMkcDHE2fDZvSp12Pj4bw/eVRQDohYQaVx2CghGX7AnMIzv7axXKIzNADdEeRmHd3eIhoZ1SENB3ui+0bY+e8fi8gF2eMq2x0FMCpz3ROXYw5wEm4jUUSIZhe4y/vYTILFCMxqaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205171; c=relaxed/simple;
	bh=dhhN6jVkztaBYZEC8iz4CwKN8S/4kggryPA7Wl9+5dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB6QE9u6l/31/0V1EA3/3HG28kB4ObityBEMAPzh+WC5U/AqIdW9JUA+CiWn1E0aCXftE36H7WW8cJYtaWVJm6xyF/SYq4t2UASsVUQXw0LXEF+e9IH6OcU+ydVGEv8m829XOLqRuowVruCeKibQEzYs/9nzfm7gfaJ6F97kfK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7SmcyQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7SmcyQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CD41F000FF;
	Sat, 12 Sep 2026 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205170;
	bh=cr57F2gFh9ngA3R3yTuCMcfwfpQ/wJkM5/ds2DYWlbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7SmcyQmN1t/N/75w28GRgFGpLXeDnSycWJe1UdtCpXZUpJpEx2LjXYzR6UUG7owN
	 0JRR7HDq7t9+XedtfN6OL9Jry/TtxXLd0XWk7NDNpA1TpkDhBNgd5IOrNXvnPs1NdH
	 poA3fpFj0GqyaP6qpKOirdIMrV2a81ddiqxP+jUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1763/1815] net/sched: sfq: clamp quantum to avoid signed overflow soft lockup
Date: Sat, 12 Sep 2026 08:58:33 +0200
Message-ID: <20260912065730.381536878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 816e90057ab1879562a5b7cc688e35bb9027ae97 ]

sfq_init() sets q->quantum = psched_mtu(qdisc_dev(sch)) (unsigned). A
device with a huge MTU (e.g. dummy with max_mtu == 0 accepting MTU
2147483634) makes psched_mtu() return 0x80000000, so slot->allot = INT_MIN
and INT_MIN + INT_MIN toggles between INT_MIN and 0 forever, spinning
sfq_dequeue() under the qdisc lock.

Clamp the quantum to [256, 1 << 20] so the refill loop terminates. The
lower bound also covers q->quantum == 0 (psched_mtu() returning 0),
which spins sfq_dequeue() identically. sfq_change() already rejects a
negative quantum, so only the init path was exposed.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-7-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 77675f9a4c46e..187d3ed578f26 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -799,7 +799,8 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt,
 	q->tail = NULL;
 	q->divisor = SFQ_DEFAULT_HASH_DIVISOR;
 	q->maxflows = SFQ_DEFAULT_FLOWS;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->quantum = clamp_t(u32, psched_mtu(qdisc_dev(sch)),
+			     256, 1 << 20);
 	q->perturb_period = 0;
 	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 
-- 
2.53.0



