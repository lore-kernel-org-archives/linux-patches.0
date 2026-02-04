Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC182BE621;
	Wed,  4 Feb 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218669; cv=none; b=LCSgUTNyVXp5Lx9CUajoHT6k9ZwL7BfnXll4TWkZcut4bbqPHSxulPzU+LhoDUltcbiWTk+IbjER0hNw3YJTJNWW2U0YYvxVQyu4H+6KA+S9Au4oLhrzGWu6yDb84l3gJqylV9/foiurVd6UuAkF5Di8DA01g/nfvC+zZ0BJQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218669; c=relaxed/simple;
	bh=jyeXotOJqqkA0JHIj7+e8ZoW7VlxTq1X4szW2iWXknE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuH5GlOqDCpMASyksl3TFtyRgSy6ekWxmuo6R0QTQSVI0f6QOQnzWJY7q4M1JtVjk1ZoWX1NbEILbBWXTH1ozgeS4W4Za3U37aNcgIBGZFPhxhVcY5XyFqrE0lQ/OZZU9tNJgq7dKQ/hhkqV3IJqKwgP/zxEGu/HLYcNM6vaZ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuvPDb/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuvPDb/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE40DC4CEF7;
	Wed,  4 Feb 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218669;
	bh=jyeXotOJqqkA0JHIj7+e8ZoW7VlxTq1X4szW2iWXknE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuvPDb/pY8+GxHdgUDnJHwv3V6BWcFalykcm/NR8q7Kq3oBq/8J+upkKYzgw5uTb+
	 wLwsoh548MvoS5rH0kgQUeoDOlCPOIZtMid7Bwy2YAoelIgJUUuBC+G8dr5VSfT+bT
	 0PNFwkea7qCLmPSKOpk/nSu1YjwLgJHTtab/66IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Sergeev <denserg.edu@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 26/87] gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler
Date: Wed,  4 Feb 2026 15:40:24 +0100
Message-ID: <20260204143847.851942658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Sergeev <denserg.edu@gmail.com>

[ Upstream commit c0ae43d303e45764918fa8c1dc13d6a5db59c479 ]

The BIT() macro uses unsigned long, which is 32 bits on 32-bit
architectures. When iterating over GPIO pins with index >= 32,
the expression (*value & BIT(i)) causes undefined behavior due
to shifting by a value >= type width.

Since 'value' is a pointer to u64, use BIT_ULL() to ensure correct
64-bit mask on all architectures.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 2c4d00cb8fc5 ("gpiolib: acpi: Use BIT() macro to increase readability")
Signed-off-by: Denis Sergeev <denserg.edu@gmail.com>
Reviewed-by: Mika Westerberg <westeri@kernel.org>
Link: https://lore.kernel.org/r/20260126035914.16586-1-denserg.edu@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi-core.c b/drivers/gpio/gpiolib-acpi-core.c
index 97862185318ed..f7d2cb7ff4ee8 100644
--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -1149,7 +1149,7 @@ acpi_gpio_adr_space_handler(u32 function, acpi_physical_address address,
 		mutex_unlock(&achip->conn_lock);
 
 		if (function == ACPI_WRITE)
-			gpiod_set_raw_value_cansleep(desc, !!(*value & BIT(i)));
+			gpiod_set_raw_value_cansleep(desc, !!(*value & BIT_ULL(i)));
 		else
 			*value |= (u64)gpiod_get_raw_value_cansleep(desc) << i;
 	}
-- 
2.51.0



