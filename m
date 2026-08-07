Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C144D31327A;
	Fri,  7 Aug 2026 15:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116747; cv=none; b=q+Xupq0CI5ajXjVzPq4yc5zTxJXTB+8jCDRYUEvOOF7u/YciL5QJKjrUceOa+BKmI1a53hDsHo70r+ALhk8HLwXM4Lp3AqYCSU47nAPDt8XxvCSmEkWVMGeKOwFaORk1q+v9JSsvQHLJzD11dLGbOvzahGz9Hf7lVHX6EjSocTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116747; c=relaxed/simple;
	bh=/tDQgvpYK0oR4H6vZaplLuT/ASYitCqtoFE40tmNs1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDmkfzeC4UTRDAu7iKVxrBalmGihpuFPnpcNVEB5YEaY1Syxz46qnIYH3Ujn5DQQeYRL/+PO9jJzReLhkyegQTfsscoWVJqRs3Uw+7HQ/xOkQyz03pM19visMbqSnXfe54X2UcjDmmYa+vHs1a8zTWH1m3z5yp/cmeQsp5sJGnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPJR41OC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPJR41OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299BF1F000E9;
	Fri,  7 Aug 2026 15:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116745;
	bh=sEF5e5mW2Zsq2eakUhTnuO9ANrFnz1mwpGu3ZHUHtx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPJR41OCiTuSJ+ozYedgAXclWZaZmDzFqNkr4jZlYEylG4RMnOemIXrI3Kxfj8E53
	 IGHOaKBlEBEmL0Vj7XmDE10PthipVFPSRw/IJl3WtcIPA1nKse0ts1F7/fQmxDlLPa
	 zIAZxujVatAvY8aB4bzbfW0IPYEpgMhXSo6gyu3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20K=C3=B6ppeler?= <j.koeppeler@tu-berlin.de>,
	Mike Pham <mikepham4321@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 077/438] net/sched: sch_cake: skip clearing unused tins during rate adjustment
Date: Fri,  7 Aug 2026 16:34:33 +0200
Message-ID: <20260807143429.625983236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Köppeler <j.koeppeler@tu-berlin.de>

[ Upstream commit a3729e0df005a936ceb3c2b0d167f01a2b03f970 ]

When cake_configure_rates() is called from the dequeue path with
rate_adjust=true, it only needs to update the rate parameters. The
loop that clears the unused tins is both unnecessary and harmful in
this path:

 - cake_clear_tin() overwrites q->cur_tin and q->cur_flow, which are
   actively used by cake_dequeue(), corrupting the dequeue state.
 - iterating over the unused tins and their internal queues to purge
   packets adds needless overhead to the hot path.

Skip the entire loop when rate_adjust is set, as neither
cake_clear_tin() nor the mtu_time update are needed when only the
rate changes.

The clearing loop runs on every rate adjustment from the dequeue path,
clearing (max_tins - cur_tins) tins each time, so the cost grows the
fewer tins the configured mode actually uses. Testing cake_mq over veth
(8 rx/tx queues, 2 Gbit limit) with flent's [1] rrul and tcp_nup tests and
32 TCP upstreams shows a large drop in loaded latency and a throughput
gain, restoring behaviour to pre-15c2715a5264 levels:

  +------------+------+------+-------+-------+---------+
  | kernel     | mode | test |  base |  load |    tput |
  |            |      |      |  (ms) |  (ms) |  (Mbit) |
  +------------+------+------+-------+-------+---------+
  | net-next   | be   | rrul | 0.810 | 11.78 | 1469.67 |
  | net-next   | be   | nup  | 0.637 | 85.71 | 1243.15 |
  | net-next   | ds3  | rrul | 0.397 | 15.28 | 1770.06 |
  | net-next   | ds3  | nup  | 0.351 | 15.98 | 1799.39 |
  +------------+------+------+-------+-------+---------+
  | patched    | be   | rrul | 0.092 |  0.56 | 1873.40 |
  | patched    | be   | nup  | 0.109 |  1.82 | 1869.12 |
  | patched    | ds3  | rrul | 0.097 |  0.98 | 1866.10 |
  | patched    | ds3  | nup  | 0.101 |  0.51 | 1861.79 |
  +------------+------+------+-------+-------+---------+

The same trend holds on real hardware (IPQ8074A, 4 rx/tx queues,
OpenWrt): in besteffort mode the tcp_nup loaded latency drops from
~470 ms to ~4 ms.

[1] https://flent.org

Fixes: 15c2715a5264 ("net/sched: sch_cake: fixup cake_mq rate adjustment for diffserv config")
Signed-off-by: Jonas Köppeler <j.koeppeler@tu-berlin.de>
Tested-by: Mike Pham <mikepham4321@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260720-sch_cake-skip-clearing-tins-v2-1-e6a8b0275c73@tu-berlin.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index b967b7153ad34..8965fe252471c 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2609,9 +2609,11 @@ static void cake_configure_rates(struct Qdisc *sch, u64 rate, bool rate_adjust)
 		break;
 	}
 
-	for (c = qd->tin_cnt; c < CAKE_MAX_TINS; c++) {
-		cake_clear_tin(sch, c);
-		qd->tins[c].cparams.mtu_time = qd->tins[ft].cparams.mtu_time;
+	if (!rate_adjust) {
+		for (c = qd->tin_cnt; c < CAKE_MAX_TINS; c++) {
+			cake_clear_tin(sch, c);
+			qd->tins[c].cparams.mtu_time = qd->tins[ft].cparams.mtu_time;
+		}
 	}
 
 	qd->rate_ns   = qd->tins[ft].tin_rate_ns;
-- 
2.53.0



