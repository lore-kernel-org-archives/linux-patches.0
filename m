Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A892D23A6;
	Sat, 12 Sep 2026 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219353; cv=none; b=AG0OTbilsmVHIY2B6TWQSfilbcojsryAZTeuyYZ3StXKCqJVosIQMOufwoeMuqNLfDcwDRzRKjjtLJugJ2KFlOcwGRmCGQrucK8i9h229cp496wT9s4cmhCgZBPwseqJ6egw9FILCoV5KoV4nkAAYK+uAG7ecUMn/OQHyWyjlH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219353; c=relaxed/simple;
	bh=QYRzOMCjg6yv2f78PNI/P8RJ+4pYxSkKeY4IiU063OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPTsj9OksOaakIr10r6jrnD/S5e99tMr8binxmmaOZp3/LBkO41oQDyRmZ1VCRRk+pyARoD8bc9JdZmOg/DOC+ovWYmxxOGgi4Wm9Bs6Ge9h+mW0R1Rfxb2zvI7D7OA4HpR/3JF79zZ+tUKNJa//FLlNm98quIfvv3MNWpagY2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnQiYjxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnQiYjxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A981F000FF;
	Sat, 12 Sep 2026 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219352;
	bh=lPxi8oSprHzQd/TWxn84rp436GKx9Jc3gRNw6sCeumE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnQiYjxS5YuPSB0sNTNg0w4VHbPrW5CDUrVvAE2K4Pyk2Ci0P+X8tP6I3Di67s6Rr
	 Lhd1YjhzvsXY6c9+hh+iwOBS/328k2VONuAeKZCcHcYTzWnEVHSsnBDJkBYCOuG7Fb
	 n2nxJxOshlYG/iRkz3UHd3uynlQ+4odYpDYSwJJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1332/1376] net/sched: bound qdisc_pkt_len to prevent qdisc soft lockup
Date: Sat, 12 Sep 2026 09:02:38 +0200
Message-ID: <20260912065637.220225279@linuxfoundation.org>
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
index 8a75c73fc5558..f3649ae8cab63 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -12,6 +12,7 @@
 
 #define DEFAULT_TX_QUEUE_LEN	1000
 #define STAB_SIZE_LOG_MAX	30
+#define QDISC_PKT_LEN_MAX	(1 << 20)	/* 1 MiB */
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e7d87e81bb92e..1d76f78534048 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -608,8 +608,11 @@ void __qdisc_calculate_pkt_len(struct sk_buff *skb,
 
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



