Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5A5244687;
	Wed, 23 Sep 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172703; cv=none; b=NBX82XJ7ramO3d/y59SqJ43FDjozU8bbNYoprfCij5GFnP2vPHe+xX3mwLUNcK7Mz2/cCKEewe69LL46zwDu9j5nZWL7771oURG7Jt93E+9KXQAGUJxvwJ5L2lVpP0L6X6CAyFiZtt8T5OAGlaot1Hme81MHlo+9KF/9+YvmLHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172703; c=relaxed/simple;
	bh=KRdZMk6NbemO/5LBQZi3lCueDt98UqE3bgFJ7DUrsPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/dB44ZhilV0L+sfrBO2daGwJ5qxOYAhRzkDuwAgwSSRz9gON5I47wAUArLoovUVHcvk1wI32xRcWpgj2u6r0FryDqWf80HAbpam3vNUm/PXW6Vgnn0wWpqXeSc/25G+eD8vak+RYY3DKe8fnENh2kjTd9P6p0VPHk2Edep0U+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pp4oVPQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pp4oVPQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23D1F000FF;
	Wed, 23 Sep 2026 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172701;
	bh=3il9uM4icDaCxg7wTbMBW5X8eb8EP5WgMP8HomgdH3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pp4oVPQBTDfU971JDPimnZVukW6QDNyPunW1M2E4knNrjl0YetvbxgfbG4o2bpB+Z
	 +EtOFwWG6ztt9VIsT6gzaH3ZKuHL23M4dbpNElR4ANRwsmUv1D4YqLFCaEGn6Ld25p
	 D+bMEbDMs2kS1ZzDatY8fZzwdvHPVfbbxTBGIwgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 034/438] arm64: dts: renesas: r9a09g087: Switch GBETH TX queue scheduling to WRR
Date: Wed, 23 Sep 2026 16:00:55 +0200
Message-ID: <20260923140645.666751728@linuxfoundation.org>
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

[ Upstream commit 2ac7bad110be6ebe478d6bd57821f7f5259a1f54 ]

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

Fixes: c4698a34993b ("arm64: dts: renesas: r9a09g087: Add GMAC nodes")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260722085353.136986-6-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g087.dtsi | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g087.dtsi b/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
index e8d4f76949ccb..03b976d93e105 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
@@ -643,36 +643,45 @@ queue7 {
 
 			mtl_tx_setup0: tx-queues-config {
 				snps,tx-queues-to-use = <8>;
+				snps,tx-sched-wrr;
 
 				queue0 {
+					snps,weight = <0x10>;
 					snps,dcb-algorithm;
 				};
 
 				queue1 {
+					snps,weight = <0x11>;
 					snps,dcb-algorithm;
 				};
 
 				queue2 {
+					snps,weight = <0x12>;
 					snps,dcb-algorithm;
 				};
 
 				queue3 {
+					snps,weight = <0x13>;
 					snps,dcb-algorithm;
 				};
 
 				queue4 {
+					snps,weight = <0x14>;
 					snps,dcb-algorithm;
 				};
 
 				queue5 {
+					snps,weight = <0x15>;
 					snps,dcb-algorithm;
 				};
 
 				queue6 {
+					snps,weight = <0x16>;
 					snps,dcb-algorithm;
 				};
 
 				queue7 {
+					snps,weight = <0x17>;
 					snps,dcb-algorithm;
 				};
 			};
@@ -790,36 +799,45 @@ queue7 {
 
 			mtl_tx_setup1: tx-queues-config {
 				snps,tx-queues-to-use = <8>;
+				snps,tx-sched-wrr;
 
 				queue0 {
+					snps,weight = <0x10>;
 					snps,dcb-algorithm;
 				};
 
 				queue1 {
+					snps,weight = <0x11>;
 					snps,dcb-algorithm;
 				};
 
 				queue2 {
+					snps,weight = <0x12>;
 					snps,dcb-algorithm;
 				};
 
 				queue3 {
+					snps,weight = <0x13>;
 					snps,dcb-algorithm;
 				};
 
 				queue4 {
+					snps,weight = <0x14>;
 					snps,dcb-algorithm;
 				};
 
 				queue5 {
+					snps,weight = <0x15>;
 					snps,dcb-algorithm;
 				};
 
 				queue6 {
+					snps,weight = <0x16>;
 					snps,dcb-algorithm;
 				};
 
 				queue7 {
+					snps,weight = <0x17>;
 					snps,dcb-algorithm;
 				};
 			};
@@ -937,36 +955,45 @@ queue7 {
 
 			mtl_tx_setup2: tx-queues-config {
 				snps,tx-queues-to-use = <8>;
+				snps,tx-sched-wrr;
 
 				queue0 {
+					snps,weight = <0x10>;
 					snps,dcb-algorithm;
 				};
 
 				queue1 {
+					snps,weight = <0x11>;
 					snps,dcb-algorithm;
 				};
 
 				queue2 {
+					snps,weight = <0x12>;
 					snps,dcb-algorithm;
 				};
 
 				queue3 {
+					snps,weight = <0x13>;
 					snps,dcb-algorithm;
 				};
 
 				queue4 {
+					snps,weight = <0x14>;
 					snps,dcb-algorithm;
 				};
 
 				queue5 {
+					snps,weight = <0x15>;
 					snps,dcb-algorithm;
 				};
 
 				queue6 {
+					snps,weight = <0x16>;
 					snps,dcb-algorithm;
 				};
 
 				queue7 {
+					snps,weight = <0x17>;
 					snps,dcb-algorithm;
 				};
 			};
-- 
2.53.0



