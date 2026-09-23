Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA8F4A3850;
	Wed, 23 Sep 2026 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172687; cv=none; b=nAg8Rh7wuUeHT0GriMo1yzxbFn9O6/6hfjsOfBapbt3RPLov7G46y+0dvvhspVkC4wJpFRJqEbKyajsmD+5cpRI4ounYUF3i767Q7J26RU/Y8171/A4jWTycIb6b1fcZ9MYqGshWJyMB6NhVQRZTAZVLSkpP4Vy6/B0ONq9onuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172687; c=relaxed/simple;
	bh=+2F4vgrLyl8k+xIX645CowKtD5rQ6aQjPrG/5Jvw/oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5QyUg1I9AjR2v2wSv2hihLwBe3N0qYhax6ysQNpP432w/veap+U7ZNr2nHrvhvwKs3abn6sKTmAtpz/pbxH9zi5hmUHPGamjYfip/YNQRhq3Ws9WrVg+QtDXrU1aZML3zDkemg1vAwt+CrQ+T5eYse1/QKdGF5AlGq8sj5Ob10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FF+Ho7J3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FF+Ho7J3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095D21F000FF;
	Wed, 23 Sep 2026 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172685;
	bh=w4Eax94D5MkOBjbDrpTfRZZ3+ftESqK+kz7NL/B8rQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FF+Ho7J30GkR5M0LlA2a6Qxl6UiIwjIrR02hb/JjGfOUdt13bR24o3fsy8MBVk6xc
	 uHdlgFjLZq9KXIuaRX0EBd2VMAM7lS5uusAMh93dW3GxOgXu8lMuI5+kBNhGsRF3+g
	 AAIzua6diu/thMUgFHR033LQ1KvsJri/atjrCwFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 030/438] arm64: dts: renesas: r9a09g057: Switch GBETH TX queue scheduling to WRR
Date: Wed, 23 Sep 2026 16:00:51 +0200
Message-ID: <20260923140645.562377036@linuxfoundation.org>
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

[ Upstream commit 33da68f61d25ef8411489d06514ff627c1f88152 ]

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

Fixes: 050ee38d0002 ("arm64: dts: renesas: r9a09g057: Add GBETH nodes")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260722085353.136986-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
index 1e94366bb7eee..99d197f309d00 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
@@ -1559,23 +1559,28 @@ queue3 {
 
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
@@ -1660,23 +1665,28 @@ queue3 {
 
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



