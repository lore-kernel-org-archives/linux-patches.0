Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6AC2D6E64;
	Wed, 23 Sep 2026 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172700; cv=none; b=abcreTi2WmYixwbmMZ883prfWkvsCoKJQvHatrJ5C1SZ/EHnn6kZKGCREybHulRwqxhe3yOMOsGdndBfjvOL96yBITNFlO3g9YdXxMP4PdWuV+6wT8cxGNZNta83joYCLH6mwbz7Xy7TMyRXQ84yI9M7hCAxfVASH3qGhG2NNvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172700; c=relaxed/simple;
	bh=KMGAvqtZF8ebOCoWIWRItJhGonc4gQr18RXEeTxVaWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB+4Z161F10D7Y/pelp7PkPeiz0E+hETltlLniEiGDaDJtuf4UiCGzGp2SHmRGEBXpbsxB3FAWcNpjRjvcg8pM89odc2ZFzINce44ZMaDoNjjsD7MW3FtTJW7UUeFphma2BIn7v1QwTz2FSsp6Bb68+D+dIwtxkGpjrCFWKD768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEMkt6hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEMkt6hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8F31F000FF;
	Wed, 23 Sep 2026 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172698;
	bh=VmyGvVNStv5xRS6Tdjt9+Vxd6fAUMOfA1VlM891W6PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEMkt6hi6KpRN7NTJ4eCl/TM8is2ErpK/6XAtJR+16lo4dnLrn2WoU8+aezQz2Ymy
	 VDpL3IqC1heRQF+bGSXwH9yPVpKUMgzsfHAqUNxTnS1j75TmUusKo9X0VBGiYOV3ZK
	 3apjo3QuA0kKyphKbw0+Td2Wq6HC6X6VwUumOAEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 033/438] arm64: dts: renesas: r9a09g077: Switch GBETH TX queue scheduling to WRR
Date: Wed, 23 Sep 2026 16:00:54 +0200
Message-ID: <20260923140645.641298946@linuxfoundation.org>
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

[ Upstream commit f9d9a1913c09366bf7b967d39575e06cb80128dc ]

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

Fixes: 394c1e24a4cf ("arm64: dts: renesas: r9a09g077: Add GMAC nodes")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260722085353.136986-5-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
index 40494159831d8..bac39390ead74 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
@@ -642,36 +642,45 @@ queue7 {
 
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
@@ -788,36 +797,45 @@ queue7 {
 
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
@@ -934,36 +952,45 @@ queue7 {
 
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



