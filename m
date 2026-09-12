Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47CB2F7F17;
	Sat, 12 Sep 2026 19:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240588; cv=none; b=XcJM4oPcqb86zKRa4d1xwrbix/tgwL0hMAyMv3LBCrPmLtlvoORWY5OTx5OOl75/SoNnTxK+SaD5eDYH7gzuS3mEE6hJT1XPhguzK/PtbLhCgeicWV57hZ5gNqzHHvK46PMYc37T36TSmXb7keDrdzK2Ty5jc32Gdki1edAm3m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240588; c=relaxed/simple;
	bh=75d5uEKBCewxiOXerO8DVGHauCmOfj5XJJ2EncPQifc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZwIiJuRUc7oOxnsrpDWhsOue668S9vHowq6fruq+Hoi1eoII9p5xjM980PaZVmDyuZV75lKSVCX/5gwZyVyu6733ymj9OBfS9nMJ38RJt1MIVY4/uwJJklfQ809nX/rFgkoYZWA8/6Y3dbKNg2y+tNB5/QXD7pAH7Ep1WEkZXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtRBLD65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtRBLD65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF0D1F000FF;
	Sat, 12 Sep 2026 19:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240587;
	bh=Hwm49gY92N2DWeNYnrd2ocDEFJL/KL0p1EDdKp6hwh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtRBLD659HUPmxVxQ12OG/eupMBkQgPKVuMysz63/tOxT2HtMvmQsx+SplCz5uVmB
	 BAHhWhp2GVO/3++bZJIRAAp2TZISbHIyt0DFeuccZeoJoqsVdNYGN5A+eEMVjqMy7z
	 WtVnxIxQZNi6+chPJ8no2h1+TBjjgvTP2XZnrQIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 897/935] net/sched: hhf: clamp quantum before hhf_change() to avoid overflow
Date: Sat, 12 Sep 2026 09:05:27 +0200
Message-ID: <20260912065547.387892603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 2164b512b97bb053e8ce4d6e95576f11bed6a005 ]

hhf_init() sets q->quantum = psched_mtu(qdisc_dev(sch)) with no overflow
check. A device with a huge MTU (e.g. dummy with max_mtu == 0 accepting
MTU 2147483634) makes weight * quantum overflow the signed deficit in
hhf_dequeue(), spinning forever.

Clamp q->quantum before hhf_change() so both the opt and !opt paths see
a sane quantum. Without this, bare "tc qdisc add ... hhf" succeeds with
a clamped quantum but "tc qdisc add ... hhf limit 1000" (any option
present) fails with -EINVAL because hhf_change() re-validates the
unclamped default (sch_hhf.c:559). 256 matches fq_codel's floor and is
a sane minimum for a DRR quantum.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-6-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hhf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 1fb9294a27f25..ba67eed62d318 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -620,6 +620,10 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
 	q->hhf_evict_timeout = HZ;      /* 1  sec */
 	q->hhf_non_hh_weight = 2;
 
+	if ((int)q->quantum <= 0 ||
+	    (u64)q->quantum * q->hhf_non_hh_weight > INT_MAX)
+		q->quantum = 256;
+
 	if (opt) {
 		int err = hhf_change(sch, opt, extack);
 
-- 
2.53.0



