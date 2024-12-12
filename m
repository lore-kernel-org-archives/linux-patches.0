Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDEE217F46;
	Thu, 12 Dec 2024 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022339; cv=none; b=Cl9+9+4GqW4Ow13y4xuVrVtwCCimIAFmgua1Y5jiS0pfq++jCtDaWd36g/4QK9bBuMvXQmCWi4S4J+zkEgF2athrHAXb09ZOpgbDFz5qYkLxDF6kW24TQAJ50z2UDUo+gDrxS/rTqHaMeKGikgv2YXKg3ylPEoAXSEDmh7wo4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022339; c=relaxed/simple;
	bh=kKbTNOXleBrJ4HJ686xq28GnWOaEGHVeh14VZaL04+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMG39iy1yxAjBKhvLqQ1G8XmKaPxaR7RB8BuMRjz71NjUWb9Jy2M6CPB/bGqaxa5dWng/TtbQnnYQmHmckSZDw3P3R9vClZfVc+UQLXezkO1/igHan0H2ONJIwHbWo8bddcuC7YGDnwar1uKaZFkfOKdC5dbq/A01yH8FcmJTyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arAqXFos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arAqXFos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D5C4CECE;
	Thu, 12 Dec 2024 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022338;
	bh=kKbTNOXleBrJ4HJ686xq28GnWOaEGHVeh14VZaL04+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arAqXFoshTl5z+S3VA3B9C39YgjU7rxEqnf8UdlKS1+0/pNfK4pGTjYtoVGdtodZM
	 gqHe/yKjaKXuO3Tq+svsSYcVRUkJnlv8/qWCm6Lf7CiLwq4BSZ+3Vur+yBWBAU58Gl
	 vn1Z5+yC+JDlTLnlH3f/scNPB1h3Z6HSUm53zleA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/565] mfd: da9052-spi: Change read-mask to write-mask
Date: Thu, 12 Dec 2024 15:56:48 +0100
Message-ID: <20241212144319.914932530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5faf3766a5e20..06c500bf4d57e 100644
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



