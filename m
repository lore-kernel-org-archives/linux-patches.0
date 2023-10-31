Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B406208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbA5Wpk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171F9C433C8;
	Tue, 31 Oct 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774621;
	bh=InwO90+OxJpXBlbsxW/Zb+jwkd90hJt7MKSPSdrS5Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbA5Wpk2zZpIYdSjbaA55sZ41hoxkzIIo8+wV0TmLhbG19t7mbF3aulJ1+qqSueJT
	 gaGcck69OmQxoRCPJZGXHjGFkWZ/WwPSKk2kYEblm+ZRYb3YN9tsK3PB8qW7saOcwO
	 m/r6Y66VmjCsp+q9ttdLJ5UsbVJVvVwrTsbciDlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.5 109/112] clk: stm32: Fix a signedness issue in clk_stm32_composite_determine_rate()
Date: Tue, 31 Oct 2023 18:01:50 +0100
Message-ID: <20231031165904.704211620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 790437bbe0ef7e5cb5d091dd711c0d61d03945a5 upstream.

The divider_ro_round_rate() function could potentially return -EINVAL on
error but the error handling doesn't work because "rate" is unsigned.
It should be a type long.

Fixes: 06ed0fc0fbac ("clk: stm32: composite: Switch to determine_rate")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/d9a78453-9b40-48c1-830e-00751ba3ecb8@kili.mountain
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/stm32/clk-stm32-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/stm32/clk-stm32-core.c b/drivers/clk/stm32/clk-stm32-core.c
index d5aa09e9fce4..067b918a8894 100644
--- a/drivers/clk/stm32/clk-stm32-core.c
+++ b/drivers/clk/stm32/clk-stm32-core.c
@@ -431,7 +431,7 @@ static int clk_stm32_composite_determine_rate(struct clk_hw *hw,
 {
 	struct clk_stm32_composite *composite = to_clk_stm32_composite(hw);
 	const struct stm32_div_cfg *divider;
-	unsigned long rate;
+	long rate;
 
 	if (composite->div_id == NO_STM32_DIV)
 		return 0;
-- 
2.42.0



