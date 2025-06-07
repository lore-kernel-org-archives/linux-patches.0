Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7937315D1;
	Sat,  7 Jun 2025 10:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290971; cv=none; b=DSDvgoxmHkgHlCNjy20Aw75/v2wg0AXDUDw3qUkVE2pXkrT7xN0m8Z2onD4hvRrJXkkV37ivYrwl/+mcpEreVC72PhGz6shlpEC1x6QqAZornd179vg9YpTioSwyvDufu/C5i2hdlEqadQ7hz6KThRv1cOH9uEiZ0YdBV59Le5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290971; c=relaxed/simple;
	bh=DGYNnGiyBbd2g8yqkEQr5WjTEvb6lUwjNlxTSp7tc00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG4p/yND2nxPOoR5mWX+wSvmWQ5cEFA1+z8kVRlvm/5Czn3hfqOFQcN3WjNG+eRvkIJarA4yif2bx6/MXtUCCymg2xo2qjdJwgWjCRmUg0x6LCH8xfPoFtjT05HLO8WMa3q33seGU38FUEywrJKSmB6TzewasxQuABXtDAEBwoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVs/adxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVs/adxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B11EC4CEE4;
	Sat,  7 Jun 2025 10:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290971;
	bh=DGYNnGiyBbd2g8yqkEQr5WjTEvb6lUwjNlxTSp7tc00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVs/adxNDdGZSZgNWosJr/DiKOKJbmx2XrSbEDvvTnmhCCrz3MxqAL8s+QY+DxPsl
	 GSjr4A4JNAiykxzG0FJ6EOUJkW5HBr4xia5qnhv033TKuK7daIq6jK+ohTzFrocOHA
	 HAmnExkSTmF6ptXL/Db7WG326ws79oRtaps/9ZRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Pritam Manohar Sutar <pritam.sutar@samsung.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.14 04/24] clk: samsung: correct clock summary for hsi1 block
Date: Sat,  7 Jun 2025 12:07:44 +0200
Message-ID: <20250607100717.878653338@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


