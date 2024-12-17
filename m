Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0AF14A4E7;
	Tue, 17 Dec 2024 17:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456301; cv=none; b=bmsMCm3pTOcaeLI0rE8Fwhv5mqTjPjktr4fUQXXifkLyFHZJOBlBkBaesXLBTJ2ufm5QDONGDJGT5xj8z055fg4/f7Xo1tYw6Kt+iFDMXW1e6Sb9XTg0Tt2yDhgc1nhMj61q+Ra6supHZc2AakZhU6rVTRqIELsEUN6zdIFHtxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456301; c=relaxed/simple;
	bh=Tc9PMTVuodk8+amBLMzfFiHlNFUwLfyTL5P6AEawBhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8o0j680Lnl9j5DE4WWxEEQzz6DkGWCD0K/TbvWL7ljyWUHnFNIYOpq4LrDqZL+QeUvaSvi/xCGX0kRHM3XEBpl+H1pLyH2JkxJHJ0NtxWj2kGOsusR/gSPetP7HBzGCzrR/dPy3xTvo2Rc38Vq/gj+szNyOsoeHHdl+JR4K7e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bm07dhSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bm07dhSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52298C4CEE7;
	Tue, 17 Dec 2024 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456300;
	bh=Tc9PMTVuodk8+amBLMzfFiHlNFUwLfyTL5P6AEawBhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bm07dhSil2jVkTUTUlbc6wRFQCYg+YutRzPBWwWyJ28ivTPupXVtLaKImaBIA1uui
	 V3UUmwMuf3TWokp6XXlRE9bDO9RFyGZV2xAljYtjIssSg71MR7lqfwBbsCEi0PJskW
	 4cZNyOCbOpcRBNUhhrxIy2hO+tei9jHblvsM/98I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 006/172] clk: en7523: Fix wrong BUS clock for EN7581
Date: Tue, 17 Dec 2024 18:06:02 +0100
Message-ID: <20241217170546.495957820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Marangi <ansuelsmth@gmail.com>

commit 2eb75f86d52565367211c51334d15fe672633085 upstream.

The Documentation for EN7581 had a typo and still referenced the EN7523
BUS base source frequency. This was in conflict with a different page in
the Documentration that state that the BUS runs at 300MHz (600MHz source
with divisor set to 2) and the actual watchdog that tick at half the BUS
clock (150MHz). This was verified with the watchdog by timing the
seconds that the system takes to reboot (due too watchdog) and by
operating on different values of the BUS divisor.

The correct values for source of BUS clock are 600MHz and 540MHz.

This was also confirmed by Airoha.

Cc: stable@vger.kernel.org
Fixes: 66bc47326ce2 ("clk: en7523: Add EN7581 support")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20241116105710.19748-1-ansuelsmth@gmail.com
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-en7523.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -92,6 +92,7 @@ static const u32 slic_base[] = { 1000000
 static const u32 npu_base[] = { 333000000, 400000000, 500000000 };
 /* EN7581 */
 static const u32 emi7581_base[] = { 540000000, 480000000, 400000000, 300000000 };
+static const u32 bus7581_base[] = { 600000000, 540000000 };
 static const u32 npu7581_base[] = { 800000000, 750000000, 720000000, 600000000 };
 static const u32 crypto_base[] = { 540000000, 480000000 };
 
@@ -227,8 +228,8 @@ static const struct en_clk_desc en7581_b
 		.base_reg = REG_BUS_CLK_DIV_SEL,
 		.base_bits = 1,
 		.base_shift = 8,
-		.base_values = bus_base,
-		.n_base_values = ARRAY_SIZE(bus_base),
+		.base_values = bus7581_base,
+		.n_base_values = ARRAY_SIZE(bus7581_base),
 
 		.div_bits = 3,
 		.div_shift = 0,


