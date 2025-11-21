Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC72345751;
	Fri, 21 Nov 2025 13:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731492; cv=none; b=CHNrU7eBqECFCOEciI8BONr0p7H/dtyfyVrDfTZvmD07JjidY4loUYYZbtzuNQshKRx3FYlUSA7liej63a4jxcX0CVmv4mzKvjMcT7iP/7wgkcx0HmP7nY+t+wYOEqhcXrm8TIEO3P+8ChXB9H0aslxQ1WA/+PZSkIWEMYaQSGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731492; c=relaxed/simple;
	bh=cV0GF4AALj0NxuOEJSy3qim0AjhrB3gCv4aL/IVqVo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2RhLqEMFUIYi9MYXoa45Q9J2EIULgucAS5IqjjwaS0lTwJRvIIcd3jCfNFNOF0MRy5XCIjykncrvbBv/S5YxLeCbtypY/ebhkiDDt0SsZcAS0nt3dw3+Yr+7Hs+KiKWmdesv7pegg3fKXJ7rSwW9csKmiFaEYsWaoaIMc3IHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAHXIFCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAHXIFCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1DAC116C6;
	Fri, 21 Nov 2025 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731491;
	bh=cV0GF4AALj0NxuOEJSy3qim0AjhrB3gCv4aL/IVqVo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAHXIFCXNqUcpCAInNnhIMHfor0bbHmvP0eBCUkxSVQft3gwKpJqt5CuCw3u6venO
	 vHYktEYO+JZ3UwYcuaskbpa++PTVPlxbzKdFuBn9X71sTogYfpCVg5suSkFCDOfQxG
	 JreTjZSd6L6gRbfXAva1mgi48h4IgKSx9ujrGoY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 192/247] mmc: dw_mmc-rockchip: Fix wrong internal phase calculate
Date: Fri, 21 Nov 2025 14:12:19 +0100
Message-ID: <20251121130201.614918883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 739f04f4a46237536aff07ff223c231da53ed8ce upstream.

ciu clock is 2 times of io clock, but the sample clk used is
derived from io clock provided to the card. So we should use
io clock to calculate the phase.

Fixes: 59903441f5e4 ("mmc: dw_mmc-rockchip: Add internal phase support")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -43,7 +43,7 @@ struct dw_mci_rockchip_priv_data {
  */
 static int rockchip_mmc_get_internal_phase(struct dw_mci *host, bool sample)
 {
-	unsigned long rate = clk_get_rate(host->ciu_clk);
+	unsigned long rate = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
 	u32 raw_value;
 	u16 degrees;
 	u32 delay_num = 0;
@@ -86,7 +86,7 @@ static int rockchip_mmc_get_phase(struct
 
 static int rockchip_mmc_set_internal_phase(struct dw_mci *host, bool sample, int degrees)
 {
-	unsigned long rate = clk_get_rate(host->ciu_clk);
+	unsigned long rate = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
 	u8 nineties, remainder;
 	u8 delay_num;
 	u32 raw_value;


