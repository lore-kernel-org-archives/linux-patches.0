Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90873B388E;
	Wed, 23 Sep 2026 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172694; cv=none; b=lrZWEHIvdXxzZnlVsSvM2tFJR+SrZFNvrqd4z2GlSPjJC46Dyw4Fj7dbuBD9H3xvPNnbxMaPLk8WncFNQ1lmdspivDP72GYasH8kXE7xp5xIIfohNatqsvUEkY9GLXbeRobGIWs4f7D92Pd/gRVM5PbdNjpO/1sZ8Xp5SI4Ca1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172694; c=relaxed/simple;
	bh=hhdqMjEsbGDd8PfsXjVHpwO4pbV/3m2v6IFRcFqsz7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb/UbcC3sePbRHnzHOUdGwl2eov90pt1KsWSLPwnp4VNpYamn0zOwiEFaEAQg9Fa9BCSGWiYNjHEoVFJGNEZmA1lavOlXzEVFLmpQ9hroHdERUV78FXcLo+8nK90vtkw1w6FkP1oJ8rUzyMkoSYgjipk8Lu+4Uiur0Zgjy6zOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0eMfPC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0eMfPC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491981F000FF;
	Wed, 23 Sep 2026 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172692;
	bh=yXrCc1uuMNNSgMopydAf/LQUio4r82KzExHq88niSZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0eMfPC2rhFEGX8MIzGZCgd3vgiFOWqZM2+HSyjpihahd/w/rH1ZQsu4sXt5stbDo
	 WcuqwpU1HBmGZEnWQCisxONnw3cFGlSlqyOaPeEKx6oWdRPI6o3ODoec+MO+apDYdZ
	 LKdfrnnNVJfsWvWhm6bw6SeT3gwDx+SaPePD/pEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 032/438] arm64: dts: renesas: r9a09g047: Switch GBETH TX queue scheduling to WRR
Date: Wed, 23 Sep 2026 16:00:53 +0200
Message-ID: <20260923140645.616355552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit 63016c3a91f2c458ca75869c8c782e899591f22d ]

The GBETH ethernet nodes don't specify a TX scheduling policy, so stmmac
falls back to Strict Priority. In this configuration the queue with the
highest priority gets all the traffic, starving the others under load.

Under sustained UDP TX load with multiple data streams, this starvation
triggers spurious adapter resets due to TX queue timeouts:

  iperf3 -c <ip> -i0 -t60 --bind-dev end0 -u -b0 -P4
  end0: NETDEV WATCHDOG: CPU: 1: transmit queue 1 timed out 5228 ms
  end0: Reset adapter.

Investigation shows that only the highest priority queue is advancing
while the others stall for more than 5 seconds, causing a netdev watchdog
reset.

Switch the TX scheduling policy to Weighted-Round-Robin (WRR) so that
traffic is processed across all queues, eliminating the stalls.

Fixes: 41ffbb1c42d3 ("arm64: dts: renesas: r9a09g047: Add GBETH nodes")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260722085353.136986-4-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g047.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g047.dtsi b/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
index b6193c1583706..4de93fceb605a 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g047.dtsi
@@ -1394,23 +1394,28 @@ queue3 {
 
 			mtl_tx_setup0: tx-queues-config {
 				snps,tx-queues-to-use = <4>;
+				snps,tx-sched-wrr;
 
 				queue0 {
+					snps,weight = <0x10>;
 					snps,dcb-algorithm;
 					snps,priority = <0x1>;
 				};
 
 				queue1 {
+					snps,weight = <0x12>;
 					snps,dcb-algorithm;
 					snps,priority = <0x2>;
 				};
 
 				queue2 {
+					snps,weight = <0x14>;
 					snps,dcb-algorithm;
 					snps,priority = <0x4>;
 				};
 
 				queue3 {
+					snps,weight = <0x18>;
 					snps,dcb-algorithm;
 					snps,priority = <0x8>;
 				};
@@ -1494,23 +1499,28 @@ queue3 {
 
 			mtl_tx_setup1: tx-queues-config {
 				snps,tx-queues-to-use = <4>;
+				snps,tx-sched-wrr;
 
 				queue0 {
+					snps,weight = <0x10>;
 					snps,dcb-algorithm;
 					snps,priority = <0x1>;
 				};
 
 				queue1 {
+					snps,weight = <0x12>;
 					snps,dcb-algorithm;
 					snps,priority = <0x2>;
 				};
 
 				queue2 {
+					snps,weight = <0x14>;
 					snps,dcb-algorithm;
 					snps,priority = <0x4>;
 				};
 
 				queue3 {
+					snps,weight = <0x18>;
 					snps,dcb-algorithm;
 					snps,priority = <0x8>;
 				};
-- 
2.53.0



