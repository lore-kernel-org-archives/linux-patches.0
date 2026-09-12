Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177E2D23A6;
	Sat, 12 Sep 2026 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219412; cv=none; b=G/YkhPXkzGUUsvId6zaG1FrXhT3BPhNs95K07d0LKXFemoJ2+1AnQuAVBumindqd4MpA1Xj3SJFnLvvZqnDXK14t/yB89+xpRdAjch5ssr1kVFQBNeL+HHlZie7U1O04p7mlR4DVXCq54IlB/HNpM+wKBQWlplUvI/KYzUeM/js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219412; c=relaxed/simple;
	bh=8/jFFhd7NN1KtmpDiDYJW/F3BXo8fU1zw4ot1jPX7ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJvzrIV737CL/wfMbL0v27WrPhHgT48wkCB5xhVAuDfEoOI37g2uXdc5rmx8CUuwNAACktTkbKf83jINVDznDkVTNj/jhD8mokx23wayR43YX+Y9exjFcAo6bE4fQ1pZiImm0+tvjertjA5LtUqNX64ftHBiznzdI3ybqZQ96jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lk+urD9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lk+urD9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48F21F000FF;
	Sat, 12 Sep 2026 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219410;
	bh=zhOtwkoq9e0ueeMz1m2h/sACXpvJFXgougQ6fIY79t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk+urD9nJFejgYZw59VWx9BHUNZRKaWmaINTqqiDiRHurf6tJUbNF5g5F49fjbLJE
	 1+NcxF4KFdH0o9CpogiM6yeuYMhdxB2fySybvYuxLV4FskG7tWEKBEcSL9BNcPSgtH
	 CKERiyTnqCE351RA4vtfDWKp58GwK0tIGIUposIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1302/1376] net/sched: hhf: clamp quantum before hhf_change() to avoid overflow
Date: Sat, 12 Sep 2026 09:02:08 +0200
Message-ID: <20260912065636.553524565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f9d2cf7533faa..0c406d11b22d7 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -621,6 +621,10 @@ static int hhf_init(struct Qdisc *sch, struct nlattr *opt,
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



