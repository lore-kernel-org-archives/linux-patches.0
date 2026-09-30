Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF794DD3B3;
	Wed, 30 Sep 2026 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783025; cv=none; b=oow4ZmnJ11YGgbSiGVLSAAn/YWL/sZsb2PxELMzfA2jWwvBFh/AfgMmJCB1rEjwqG2V2fOGPwi3925MxJQb6RJn5py5zVOEzrmETRRCC7mXh1J8W6aUzExYGU3LdKTAWi0h9HZpXU9iYAFCWa7Z6+oP5PE4CPbQ4S7EwVT/dsH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783025; c=relaxed/simple;
	bh=/YHgZLB6Y10CkOjxpbq9uxStBc+EwXtoLoktn+cXe6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTdyBScXri0HV/S9RXom5H5f1HJRuiBIFDP18gTzhTkqlgICEiB+hTksrxToPm7u4SGfLfpkqfexdkqHBqK/D0DYduCsa4cNcCeKivQQZj2YffQkCJmuZ1nnnQHgmTnJzXGdE2If/lVxhsgI0trMQjZ0c8d4mZ1b83eNPdtmQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYpFkBPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYpFkBPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59B71F000FF;
	Wed, 30 Sep 2026 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783021;
	bh=I3qRGmoQXrp0RQTii2F9NbLlu1r+oGDOcjLovWR+hR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYpFkBPCZlJRHp/l0Wzk17eyvmV6vMDoES2mvylafKEnjTxCOAxvTMQwO7huE9Nuh
	 BvstuB4qqRJlmJRNV4MKDyFMkq/sQZjcOfGhhsj6J6+P7s8hRy2kzsweNmlsMKrCmP
	 GYaH74QLi7fmxp4TJUBVtLq/676oYw0jre606riU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/595] net/sched: fq_pie: clamp quantum in change path
Date: Wed, 30 Sep 2026 17:22:23 +0200
Message-ID: <20260930152353.092807517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 4864f58c53eb47257d55e01f47d4a9f355f7f970 ]

fq_pie_change() accepts any quantum value from userspace, including 1.
With a crafted size table qdisc_pkt_len reaches ~2 GiB, so quantum=1
makes the deficit-refill loop spin ~2^31 times under the qdisc lock
(a soft lockup / denial of service).

Add max(256U, ...) matching fq_codel_change().

Conditions to recreate the bug:
  CONFIG_NET_SCH_FQ_PIE=y. Requires CAP_NET_ADMIN (namespace-local via
  unshare -Urn suffices).

  tc qdisc add dev dummy0 root fq_pie
  tc qdisc change dev dummy0 root fq_pie quantum 1 stab data 32768 size_log 15 cell_log 0

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-0CFC.v3.20260901204856@mojatatu.com.3
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_pie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 884c4cbcf2b6f..9e9b6cb6baaec 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -342,7 +342,8 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 			   nla_get_u32(tb[TCA_FQ_PIE_BETA]));
 
 	if (tb[TCA_FQ_PIE_QUANTUM])
-		WRITE_ONCE(q->quantum, nla_get_u32(tb[TCA_FQ_PIE_QUANTUM]));
+		WRITE_ONCE(q->quantum,
+			   max(256U, nla_get_u32(tb[TCA_FQ_PIE_QUANTUM])));
 
 	if (tb[TCA_FQ_PIE_MEMORY_LIMIT])
 		WRITE_ONCE(q->memory_limit,
-- 
2.53.0



