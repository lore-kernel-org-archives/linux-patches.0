Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ABD15D1;
	Sat,  7 Jun 2025 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291068; cv=none; b=YoWdCgk7KBSspk0SvYO1uwqwTMVOBenc24u4l/h+pfe3AabUwCzadnyGaCAvP+5xK44uu96klfsN9KrhyGqkHB47XXlJL/j905k4c58GwPU6xsOPOkA9AHKtR0mKNt5uTKyl9gJ0cLP8uqg7lHKr+zxG2hO5flDfwVgSJh+3rso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291068; c=relaxed/simple;
	bh=X0lzFSbQNS3c0hWhoHmo9XwkxheGQg8HS1Mu/Qgsao8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2S8s4d6qESC1e37HwJA+wdPRiH+AluvrFpmFzsYBua8eeL+FaWKIDsFn85ZTSXKDDE0ycrtC3vt/bZe5miSds8IojRhSy+B6OarEJRa8Sf5WqxBfJxOYLrcbUEEs24Pq/vilp97kONcHmr63DWdHHmoFhAx4GwgEyH0KdKkBKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRZFCepK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRZFCepK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52020C4CEE4;
	Sat,  7 Jun 2025 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291068;
	bh=X0lzFSbQNS3c0hWhoHmo9XwkxheGQg8HS1Mu/Qgsao8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRZFCepKI+JQNRbpfr7C7csbPhuHFc/G7O3L8eaC8nleeP2gN+xuHt0702fL5b4pO
	 VMUVnOTeOSRGKRtMAq323vmJHOZ7MqBy2k08Idm3F+Gw6TAEZICf4Iklq2EqsCeoWP
	 kwRY/z3w0pDXGbmAgZAoWDxwkjtGAWpMYuIy/PEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pritam Manohar Sutar <pritam.sutar@samsung.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.15 08/34] clk: samsung: correct clock summary for hsi1 block
Date: Sat,  7 Jun 2025 12:07:49 +0200
Message-ID: <20250607100720.052756424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritam Manohar Sutar <pritam.sutar@samsung.com>

commit 81214185e7e1fc6dfc8661a574c457accaf9a5a4 upstream.

clk_summary shows wrong value for "mout_hsi1_usbdrd_user".
It shows 400Mhz instead of 40Mhz as below.

dout_shared2_div4           1 1 0 400000000 0 0 50000 Y ...
  mout_hsi1_usbdrd_user     0 0 0 400000000 0 0 50000 Y ...
    dout_clkcmu_hsi1_usbdrd 0 0 0 40000000  0 0 50000 Y ...

Correct the clk_tree by adding correct clock parent for
"mout_hsi1_usbdrd_user".

Post this change, clk_summary shows correct value.

dout_shared2_div4           1 1 0 400000000 0 0 50000 Y ...
  mout_clkcmu_hsi1_usbdrd   0 0 0 400000000 0 0 50000 Y ...
    dout_clkcmu_hsi1_usbdrd 0 0 0 40000000  0 0 50000 Y ...
      mout_hsi1_usbdrd_user 0 0 0 40000000  0 0 50000 Y ...

Fixes: 485e13fe2fb6 ("clk: samsung: add top clock support for ExynosAuto v920 SoC")
Cc: <stable@kernel.org>
Signed-off-by: Pritam Manohar Sutar <pritam.sutar@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20250506080154.3995512-1-pritam.sutar@samsung.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-exynosautov920.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynosautov920.c
+++ b/drivers/clk/samsung/clk-exynosautov920.c
@@ -1393,7 +1393,7 @@ static const unsigned long hsi1_clk_regs
 /* List of parent clocks for Muxes in CMU_HSI1 */
 PNAME(mout_hsi1_mmc_card_user_p) = {"oscclk", "dout_clkcmu_hsi1_mmc_card"};
 PNAME(mout_hsi1_noc_user_p) = { "oscclk", "dout_clkcmu_hsi1_noc" };
-PNAME(mout_hsi1_usbdrd_user_p) = { "oscclk", "mout_clkcmu_hsi1_usbdrd" };
+PNAME(mout_hsi1_usbdrd_user_p) = { "oscclk", "dout_clkcmu_hsi1_usbdrd" };
 PNAME(mout_hsi1_usbdrd_p) = { "dout_tcxo_div2", "mout_hsi1_usbdrd_user" };
 
 static const struct samsung_mux_clock hsi1_mux_clks[] __initconst = {


