Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7412737FF60;
	Sat, 12 Sep 2026 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219407; cv=none; b=FNJIUnyHJD8eaZe7VYPrhM9uFWt0Vbgg4G5rjh4Zxj683pRCnhoHtUGNr+7rplrHi9/7aSvLk8YQVOa0GX2L+tgiE1jT+CSkdPtlYm3/mFtcz0UMf31us+5j4VA0N/ELzTeLuk88AW36DpMK7wXFJrmmMjFAyJeaUATFom/b7RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219407; c=relaxed/simple;
	bh=fKZgJq5BuSSMBKIoJu35bnbHivuC6gxVJVBbe0Gwt7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY+edxkMgr6SF6mj8DX2gzWXfUz3ersi+cEXdHveEK7ud1uIoBzTEqN6/ay5/ggWc5gjRTbB1nXFTOpy7Ewt2aVRTXNi5HUnEU6jTQeVyYXtxKBHvRH1VvLSM31GECyrvQzfoO0reNUdO/VjLSzjMQzoO2pcHoURTHZwUohPzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdhdDgOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdhdDgOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3151D1F000FF;
	Sat, 12 Sep 2026 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219406;
	bh=njiK/hZQ+iwVlbqz7AeHbR9/+QVC2OX2ZNpuMhzyzqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdhdDgOrLvRgkrku49HkDvhTAmO6h5vJ1MlbTYuJCCJqQ31yXdLuGtNKGbaw7EMtV
	 4EJ+C47wXazj95FGiPln/uMpj3/tNLSlPfH3B0eX1iOtTIAEViU11JuzBgSL+cFG6t
	 7VYMrIisoNYto88yI4VhS3cxaJXpQO0Sb8zyFzq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1301/1376] net/sched: fq_pie: clamp default quantum to avoid signed overflow
Date: Sat, 12 Sep 2026 09:02:07 +0200
Message-ID: <20260912065636.530813606@linuxfoundation.org>
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

[ Upstream commit c86cd7ed0b0e44779a3d1683f03e4353baf4bdc9 ]

fq_pie_init() sets q->quantum = psched_mtu(qdisc_dev(sch)) without
clamping. A device with a huge MTU (e.g. dummy with max_mtu == 0
accepting MTU 2147483634) makes psched_mtu() return 0x80000000, which
overflows the signed flow->deficit to INT_MIN in fq_pie_qdisc_dequeue(),
causing an infinite loop and soft lockup. Emulate fq_pie_policy which
is already bounded to [1, 1 << 20]; clamp the default to [256, 1 << 20].
256 matches fq_codel's floor and is a sane minimum for a DRR quantum.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-5-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_pie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index ceba154656624..bae503d0a39fc 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -423,7 +423,8 @@ static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
 	pie_params_init(&q->p_params);
 	sch->limit = 10 * 1024;
 	q->p_params.limit = sch->limit;
-	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->quantum = clamp_t(u32, psched_mtu(qdisc_dev(sch)),
+			     256, 1 << 20);
 	q->sch = sch;
 	q->ecn_prob = 10;
 	q->flows_cnt = 1024;
-- 
2.53.0



