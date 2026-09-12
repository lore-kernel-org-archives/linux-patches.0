Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76733A7F62;
	Sat, 12 Sep 2026 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243466; cv=none; b=XqSRa/6EJ192zMYq+5RcFC7sM6l7Sje4ncnsbZcxzMRQTfxse/dEoqNFlVn5mR+E4DZVd7pK6QhO1Arkiju5NvRNecy2h+fScuZHBzOzsTl3sza+YxVMjpyvKdUks1f0pqSAyIKZgMbHLOUStAteB/fddmegqSGPWc8V0iHj3y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243466; c=relaxed/simple;
	bh=gjtOnpyBVq7cc01Zf68XwmZbK3G28U7tdP1yxR28R6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/qMfbu0gxnHB/E3r+aeWYv0MbNhTcDDV/PKdmEAY18vipXPE6DiBahA1PYvaUr33+YSSp6hhzIG5OZ63p3syWDWymm7vKMmD58sdP10/aIaoh3acZL9ohJhcWaaSyayBDzFnnFlLGVsLbp9dc4ByT158qO3JdsdVgk642YrT2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5JGSPPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5JGSPPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEBA1F000FF;
	Sat, 12 Sep 2026 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243464;
	bh=Ew8LHN8PLKjpP4+BRzgoot2kylM4weHgi2jGstldJrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5JGSPPMcqB2qLCQ8VqHMR9O8XSqWorbKDI9yPikTH49KvXk/CbWPOyi3lViZz3Gg
	 n+hNI3BC5TMB/nUpG5Oa5WZkbOFJnaZnPBGCF3IJZRhH+uB4YDzOu35g35levd7uxs
	 f/bN64/5KgH8LCfWlp4K3PfmMawlPI79u2lQ8VxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 764/798] net/sched: hhf: clamp quantum before hhf_change() to avoid overflow
Date: Sat, 12 Sep 2026 09:06:32 +0200
Message-ID: <20260912065534.580035237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



