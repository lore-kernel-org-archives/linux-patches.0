Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751582C15A9;
	Sat, 12 Sep 2026 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219402; cv=none; b=b4Fwom4Pgeon3pwuc5Wj6WhaI1GRFCXzqCThL2WBnSlF98tHAfUZNS+ng4suBtRea4Wb8PsimQR8ZSTFV4dS0oqldGQzZ3shsL7IA3XHFDY27r2uWS9TyqczbdMD014gB5gD9/IkX5Md6NM/dvTPclWJdlMWkorvEI4iLlnENF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219402; c=relaxed/simple;
	bh=9Qzh5NZd4xqzrr9kQUMB+JbxMpSucjODF0fFDQMkKr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdtGDN+rJkdWTSlAWMeI0VeYW4p1BSIY91E0ELrIb6t+yslQalCOUrPvV6V2JzsbJhz7bUf2KD6lIqIRZBtxNZ7lwUKFT9AjYCHR8p0AaVeM11SM0jMLQkZ0Vzi2b2uaBxjL0h1viIGsE8GypstotpYcgvtq60S1IiFbxWNpx6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTBhK/F8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTBhK/F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ED11F000FF;
	Sat, 12 Sep 2026 13:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219401;
	bh=sRzJySBf0aA4tXujjJhGPpcRq4dJA5dmQj3ohEl7LE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTBhK/F84VuArseLsurkKM2CzSABLuxAeors2rh+A4Zfpl4z2K/CQT9WbDLs6roo/
	 qxEpIQKuWfVc/4eogfeEEPZePIuf6fVpnb2ynwLmKT0V7IfLs+iMOXU+3mVha/t3xJ
	 OxxBPOa42w1lgRPaHAN2DQY05xpSpYf9sJ6xlCTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1300/1376] net/sched: sch_codel: clamp default mtu to avoid disabling CoDel
Date: Sat, 12 Sep 2026 09:02:06 +0200
Message-ID: <20260912065636.507249998@linuxfoundation.org>
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
index 29f5a98a3bab0..d6819c4e41982 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -203,7 +203,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = psched_mtu(qdisc_dev(sch));
+	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



