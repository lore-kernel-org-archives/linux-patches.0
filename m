Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470503A782D;
	Sat, 12 Sep 2026 20:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243460; cv=none; b=GYjzSPGRIW0LhvfEPgiiA+Qws+20jrf0JoVq29uDkx4CPKuyXbX9BLhxaw3dlM4C64NpeF847Xg0yUl9ldpW4FBE3epZsJmf9nTsqzY25VpXXIHW2EnWPTmkY5CYKUv4rpPGMUA18HjhWiXSxDNmL8mlNgSswWijMkGw/umU9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243460; c=relaxed/simple;
	bh=mXhHl2eif7tTxrM/seKEfnOcg/IgFIBWPx56ZdHyQw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRHiwT3he3vUmZCn/qpJlEevcCU4SDNbOFvji8I+fSW4b8UMpTfpPF98r7jPXkTGck2zqliKklQhJpM0jKkjkCQWXdCwWuAs6B+/bu0DK7SyA91xlAyzqhyjbPW9r26KctUv/VkndOb2C88BJ5PARl+C2ipmk9aiRDiIAJugbY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+TbLa83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+TbLa83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF311F000FF;
	Sat, 12 Sep 2026 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243459;
	bh=2OpXOqrC8HrHrlDnadEV7svRXZWuu4XSbkOBE4GlxlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+TbLa83CB7AeH6zZfMxsPuuTU//B0HF5N3QuEkSar+8fIy3BS9yN1yxXQePLqsEZ
	 7v6qgq44VqeaqVBY7fBN44Y/uVCRs8JAwEMedpCfddl1PJkEjCWGb0xhQrPIDwuFv1
	 8qZ+iDr/ildq2+tACaeHjNjkh9Oodl+Q/R/ZSS4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 762/798] net/sched: sch_codel: clamp default mtu to avoid disabling CoDel
Date: Sat, 12 Sep 2026 09:06:30 +0200
Message-ID: <20260912065534.532193839@linuxfoundation.org>
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

[ Upstream commit 6439461f1618ae176c048673ad28bdb6c68efbfc ]

codel_init() sets q->params.mtu = psched_mtu(qdisc_dev(sch)) without
clamping. A device with a huge MTU (e.g. dummy with max_mtu == 0
accepting MTU 2147483634) makes psched_mtu() return 0x80000000. In
codel_should_drop() the test "*backlog <= params->mtu" then compares
the backlog against ~2 GiB; with the default sch->limit of
DEFAULT_CODEL_LIMIT (1000) packets the backlog can never reach it, so
the test is always true and CoDel is silently and completely disabled
i.e no drops, no ECN marking, codel degrades to a tail-drop FIFO.
codel_change() never updates params.mtu, so the init path is the only
place to clamp it. Constrain to [256, 1 << 20], matching the fq_codel
bound; 256 is a sane floor that only makes CoDel slightly more willing
to act on very small queues, which is the safe direction.

Conditions to recreate the bug: a device whose MTU (plus
hard_header_len) wraps psched_mtu() into the sign bit (e.g. a dummy
device with max_mtu == 0 accepting MTU 2147483634). Requires
CAP_NET_ADMIN in a user namespace.

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260822195509.112717-4-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 1cd09d3fe5efe..9e4e9b1a7ed88 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -231,7 +231,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = psched_mtu(qdisc_dev(sch));
+	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



