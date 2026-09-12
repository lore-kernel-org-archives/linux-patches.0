Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437914BEE3C;
	Sat, 12 Sep 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232193; cv=none; b=VfzqNvZl/9eB2mx2ykbCqjCKnPJ3bXTsOvKudrcxiS+KnrR3hgF7JrT3MPhXOZoQSu/lrzuXLfAC/do0VWCk2P02sL0TPxXAkAiagqopb/gu3eFA6TjybLivSFvsgOunRofHimp8kwxeks+OoLa5EpCIQswl/oyrkzPKkK8dCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232193; c=relaxed/simple;
	bh=xVb2sTopJAAUF9ZEOpt6Rjft4rPrlqESEs1QkP5DQ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIAHpj/QQxRcPkWpjjJ4DHxU/Y/rThX9dBIusHkPr0Ll2QfYg7YTsU52j/oT9fJ7b80NFdCSZR5SKVLWh2Jp0C74dIF0thDHs/xaiza3SVvvkHu133htn9FZdX7IK5MvTjUn+u8iADYdZMFguE4CQOhVdj5q7j2+gnsbSefwTc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kuc86F3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kuc86F3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBFF1F000FF;
	Sat, 12 Sep 2026 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232191;
	bh=HRUZ40oLYVRXiSfS7OcpR6toZomfiHV0OFWCtWKYv2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kuc86F3CrVa5zFx6Gm1Us+3ENxOJMvjj8Sr5W/Oyz31sVjajXpnmV5Ja3g1MaFse3
	 bQypr2s/qKiaC/Ge3WXuviYRAps27Uf7Py9yYlRAZnaxsB5LAVMtNhVbpqX8ZFXxDw
	 HnaluhmCLvZVXxIoGIfOtTRvrAKJZej3jNk2BVmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1109/1191] net/sched: sfq: clamp quantum to avoid signed overflow soft lockup
Date: Sat, 12 Sep 2026 09:03:57 +0200
Message-ID: <20260912065613.060049690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e871cb53946a3..a53ea6ac2296f 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -796,7 +796,8 @@ static int sfq_init(struct Qdisc *sch, struct nlattr *opt,
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



