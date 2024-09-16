Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AC1157E78;
	Mon, 16 Sep 2024 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488518; cv=none; b=fvZfnQjNVgppdiQeqb83RG900DjDeqEVWWQTHX99IH+JZoRsZA7VkJwfKiZs/JFejj0uOj/w//g6LMAgkvN74SuuF5pd8Anhvlagq5xc7OlIrBOcJfVqR0VaS55podzL6Ctcrr+Yj6P0jZ3Tjzsnz+nGABjWgksqNVDNCOI1Nrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488518; c=relaxed/simple;
	bh=BXc6BTqAf7aGZOz36TVbkcjZQ+1jL9m+bsHgPHQrtfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETuC4LTtn4/QtJnL/LRvJSV2q8Lfy7aUvH/ULZVNOTUrg2UA+GeDd1L9Wdrt4HKbIwXYaK0UOrIIU80ET9dLgdP7zjPK9at/fmwTh/kW2ztPED1g4ppepbaJrMbFXIxGM0CMzz9myBHU9j6ZgeaivEoTbpbOlonIfrghcRWIewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxSfkgIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxSfkgIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B3C4CEC4;
	Mon, 16 Sep 2024 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488518;
	bh=BXc6BTqAf7aGZOz36TVbkcjZQ+1jL9m+bsHgPHQrtfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxSfkgITCjy7wXVhVyOyjHiw9gJiDUv6ut+VVwfSwbdGAH8xawBN6E8QrF6ioDte2
	 UUE4xSW4mwBCHjEH7DlL+xO5urysN0f0wxNq9FLp6T0sr7MNtplvVyfrIjS52mfzHc
	 ChL5wmq3gkhKH5oOrZatXh/oP8nxPrdjUGyoeB1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/91] nvmem: u-boot-env: use nvmem device helpers
Date: Mon, 16 Sep 2024 13:43:43 +0200
Message-ID: <20240916114224.768652541@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit a832556d23c5a11115f300011a5874d6107a0d62 ]

Use nvmem_dev_size() and nvmem_device_read() to make this driver less
mtd dependent.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231221173421.13737-4-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8679e8b4a1eb ("nvmem: u-boot-env: error if NVMEM device is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/u-boot-env.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/nvmem/u-boot-env.c b/drivers/nvmem/u-boot-env.c
index dd9d0ad22712..111905189341 100644
--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -127,27 +127,34 @@ static int u_boot_env_add_cells(struct u_boot_env *priv, uint8_t *buf,
 
 static int u_boot_env_parse(struct u_boot_env *priv)
 {
+	struct nvmem_device *nvmem = priv->nvmem;
 	struct device *dev = priv->dev;
 	size_t crc32_data_offset;
 	size_t crc32_data_len;
 	size_t crc32_offset;
 	size_t data_offset;
 	size_t data_len;
+	size_t dev_size;
 	uint32_t crc32;
 	uint32_t calc;
-	size_t bytes;
 	uint8_t *buf;
+	int bytes;
 	int err;
 
-	buf = kcalloc(1, priv->mtd->size, GFP_KERNEL);
+	dev_size = nvmem_dev_size(nvmem);
+
+	buf = kcalloc(1, dev_size, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 
-	err = mtd_read(priv->mtd, 0, priv->mtd->size, &bytes, buf);
-	if ((err && !mtd_is_bitflip(err)) || bytes != priv->mtd->size) {
-		dev_err(dev, "Failed to read from mtd: %d\n", err);
+	bytes = nvmem_device_read(nvmem, 0, dev_size, buf);
+	if (bytes < 0) {
+		err = bytes;
+		goto err_kfree;
+	} else if (bytes != dev_size) {
+		err = -EIO;
 		goto err_kfree;
 	}
 
@@ -169,8 +176,8 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 		break;
 	}
 	crc32 = le32_to_cpu(*(__le32 *)(buf + crc32_offset));
-	crc32_data_len = priv->mtd->size - crc32_data_offset;
-	data_len = priv->mtd->size - data_offset;
+	crc32_data_len = dev_size - crc32_data_offset;
+	data_len = dev_size - data_offset;
 
 	calc = crc32(~0, buf + crc32_data_offset, crc32_data_len) ^ ~0L;
 	if (calc != crc32) {
@@ -179,7 +186,7 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 		goto err_kfree;
 	}
 
-	buf[priv->mtd->size - 1] = '\0';
+	buf[dev_size - 1] = '\0';
 	err = u_boot_env_add_cells(priv, buf, data_offset, data_len);
 	if (err)
 		dev_err(dev, "Failed to add cells: %d\n", err);
-- 
2.43.0



