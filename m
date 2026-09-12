Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE62F6931;
	Sat, 12 Sep 2026 19:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240695; cv=none; b=ctX85sq93WR6fOrVLfT9UxsHnv2NOlvCrDJ8j5XZCDoe/lhaLTMVH/+wvZS5Mq1OPRMXCB5wjyq0mLnOocx7LBQbK/J6YQaMF/u7jA5xVzjQtZASlzZjOrJCU/vpEE2xLgGQeiWmHk5lB9C6mkxh1qBGNJn3nAPZQfAGUNZjXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240695; c=relaxed/simple;
	bh=I2LG+F4dJdEVCdeyod5GIYQOyMo/GbeLh7a5RJ7uAII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbrUa/0c/jBnKcW7JOf7a2cSFvTxMmEj8oiQpp5M+apA92fQ6h/+h2yHwirwl03C7vd/FadSukRGl7E1V0Z9mRsXM9mZQnhnbwv49gSB25+3dOR2LGLhAroE9TicrqVV2o7B0gEEa8J+rU9e/R0MLmBfn4W9ob8JxPZohvlhxCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOqoi6xX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOqoi6xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FB01F000FF;
	Sat, 12 Sep 2026 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240693;
	bh=Acowysr3CnZejPdCSDjOf8j0UhAQ3lTe03h2SpJrKi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOqoi6xX27Gpen8uP2CEDbgkhwKZGasBE9u0VK1nmlTV4eHfyjkZVaoBiMmw5U2Us
	 q+8iZrHykN/X2ouxc8xT4AQBbdJEEMv56QGgX9dffSAypaPWp1tC+7Vvp/IT1eRg/f
	 6Q7KsBNf2zrUBIg5wei0olgyGDvc8b/D9tcREpW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 921/935] net/sched: bound qdisc_pkt_len to prevent qdisc soft lockup
Date: Sat, 12 Sep 2026 09:05:51 +0200
Message-ID: <20260912065547.943618245@linuxfoundation.org>
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

[ Upstream commit 8f735d64382dcf162f4276d6699d03ad2f859c0b ]

qdisc_get_stab() accepts a user-supplied size table, and
__qdisc_calculate_pkt_len() amplifies qdisc_pkt_len() through the
overhead, the size-table data (u16), and size_log (up to
STAB_SIZE_LOG_MAX). A crafted stab can therefore set qdisc_pkt_len()
to ~1 GiB for an ordinary skb. Per-flow deficit schedulers such as
DRR and ETS replenish one quantum per loop iteration; with a tiny
quantum (1) they spin billions of times under the qdisc lock,
producing a soft lockup / RCU stall as illustrated by vega@nebusec.ai.

Cap the final qdisc_pkt_len() to QDISC_PKT_LEN_MAX so the size-table
amplification cannot drive deficit schedulers into an unbounded loop.
A legitimate size table (e.g. qfq's overhead 999999999, which is
handled by dropping) is still accepted.

Introduce cap QDISC_PKT_LEN_MAX (1 << 20) = 1 MiB which is well above
any legitimate single-skb wire length: the largest current skb->len
is GSO_MAX_SIZE (524280), and an ATM-style size table (53/48 cell tax)
amplifies that to ~578 KB, both comfortably below 1 MiB. At the same
time, 1 MiB bounds the deficit refill loop to ~1M iterations per
packet with quantum=1, which completes in a few milliseconds well
under the demonstrated softlockup threshold (~10^9 iterations).

Conditions to recreate the bug:
- CONFIG_NET_SCHED=y, CONFIG_NET_SCH_DRR=y (or CONFIG_NET_SCH_ETS=y).
- Attach a DRR (or ETS) root qdisc with a crafted TCA_STAB that
  amplifies qdisc_pkt_len to ~1 GiB (e.g. size_log=15, data=[32768]).
- Add a class with a tiny quantum of 1 and send one small packet; the
  deficit loop spins billions of times under the qdisc lock and trips
  the softlockup detector (panic with kernel.softlockup_panic=1).
- Reachable as root or from an unprivileged user in a fresh user+net
  namespace (unshare -Urn) with namespace-local CAP_NET_ADMIN.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260825081403.133992-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 1 +
 net/sched/sch_api.c     | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 8443c2853333b..4f7f75e8f293d 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -12,6 +12,7 @@
 
 #define DEFAULT_TX_QUEUE_LEN	1000
 #define STAB_SIZE_LOG_MAX	30
+#define QDISC_PKT_LEN_MAX	(1 << 20)	/* 1 MiB */
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index cbb6c2e0dbff1..42b7b5f3159cc 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -604,8 +604,11 @@ void __qdisc_calculate_pkt_len(struct sk_buff *skb,
 
 	pkt_len <<= stab->szopts.size_log;
 out:
-	if (unlikely(pkt_len < 1))
-		pkt_len = 1;
+	/* A size table can inflate qdisc_pkt_len() beyond any real packet
+	 * (via overhead, the data table, or size_log); cap it so deficit
+	 * schedulers such as DRR/ETS terminate their refill loops.
+	 */
+	pkt_len = clamp_t(int, pkt_len, 1, QDISC_PKT_LEN_MAX);
 	qdisc_skb_cb(skb)->pkt_len = pkt_len;
 }
 
-- 
2.53.0



