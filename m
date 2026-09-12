Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CED3B42F3;
	Sat, 12 Sep 2026 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243532; cv=none; b=E/5hCza1Zl/5GCCX8ohqNpMLgxgZJFJSjG5c2KVf+rNVC53Uh967cxYeV35KA9bTgOop3LDYnG6irh1WrXPbwixmzm6zRCmi2ezlACAdXMd14a6p4jStNXtHRtwg2dZ3F9bTVg3Fpk8WGGorITGZDqf8WEABJzht6H81PjxrR7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243532; c=relaxed/simple;
	bh=4pQqmo0HVyoXUjRQ1pMZ3WtU9tJwGU7V+GjSDIg4EZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHRp1lApXcLpZOBsW4KbDgCCAW4AHLSrJ+mEYGEh6/1kiK2b1SETSZtqk7memfwfysXMlkE7XvOuMFJ6Dk2PwjlYXemVyLQmwbJJIXtNq8CE5zXX/hn357KpBuwPGWzvIP90jOTu7G61ET3HPZUDMaBEkxi4J7xpzdlotZbnyX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elr2FgMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elr2FgMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB8A1F00898;
	Sat, 12 Sep 2026 20:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243524;
	bh=ELsyueTncbyIM/rsn3YLJ348ff/eNPyAyepsuULtA7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elr2FgMXBVbmQqFr54KAKrCy3+v/H6NDcE5kqy0zfGGLtUNByNY5zNddhh4KEV5uI
	 FdXuTxj3x636F0RjxwZUtcEbtNL8tYkjlJlcIR9TkCDpMT1U3ekVYI4A6uyIkm6q9r
	 AtYnJGks06d401ApG7JnwOS2AhrsrGOLd3mQ6Q68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 783/798] net/sched: bound qdisc_pkt_len to prevent qdisc soft lockup
Date: Sat, 12 Sep 2026 09:06:51 +0200
Message-ID: <20260912065535.012817136@linuxfoundation.org>
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
index 128a583942d74..ddbe1952fe48b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -12,6 +12,7 @@
 
 #define DEFAULT_TX_QUEUE_LEN	1000
 #define STAB_SIZE_LOG_MAX	30
+#define QDISC_PKT_LEN_MAX	(1 << 20)	/* 1 MiB */
 
 struct qdisc_walker {
 	int	stop;
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 8c1e7d2d67379..f4db694f5d719 100644
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



