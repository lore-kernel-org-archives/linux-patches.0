Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9484622332E;
	Thu, 12 Dec 2024 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019430; cv=none; b=UqJJY1TLEC2wEG0OiKl4KyZ++E8qnljOVhp1CSzmmFzRmYVIhHNnx6nmtubgHNwuRvFxOae/7um63tnAXa1p8lVb9/Fa3qwmhuwkK9hBBvnYLPztx3PRBtSVFKs/spTSOBdYJPIqZ2HKOv8EjyQ5LZ6kpvZN4b8Sp030DMBocTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019430; c=relaxed/simple;
	bh=e7R7Uxp8WadpekN/CuUU5zKR4ewfhyACRHnOVs9DAc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYWVe1UdrsakmIaNKnLkxj7V7iHopfagJQK30a3o/wls/vwphpFVXPWDCH9j3fjcrR7twOQd+06lQL5KrCPgiRbLge0EC0vAsu8yBTyaBHUylCxGZUhEzsELjr4jagS6Z15Cqxl8NNKf5IgPn9VC4lnJ+XOEAoIYTR55lmgDm+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQ+KH+uM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQ+KH+uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB3CC4CECE;
	Thu, 12 Dec 2024 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019430;
	bh=e7R7Uxp8WadpekN/CuUU5zKR4ewfhyACRHnOVs9DAc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ+KH+uMDMv8iT1ptUq8DiV+GZP+UPuwqikAA2+bR+WGOozQChNsgqvrwpOpYD6tV
	 yTG4WPLcpVzWDRuSENHTazCQO7RxFxVrq0Fc6pVFbSNkOhrmHADmYe8Pw5puwUzw5r
	 +vbwV5ctobHnDjYwGtqqYV1spyHZsFsaAjlyCJaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/772] mfd: da9052-spi: Change read-mask to write-mask
Date: Thu, 12 Dec 2024 15:52:31 +0100
Message-ID: <20241212144358.445809394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index b79a57b45c1e8..458f919de4cb4 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



