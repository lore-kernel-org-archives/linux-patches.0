Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C401C46D54F;
	Tue, 21 Jul 2026 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648601; cv=none; b=K0cx82mdklI2XIOFtocfYG8NNGpiPOwbU/omN+wRH2sE+tvi5MwgY0n7sfQQFE2pFwhabqrS25wKZNNUYkIFiUstOWv35xneFSqU8VdDP/ZoAZHhMiximSMB6u6IJTBzop28DYbK1QaNvQzS/jB6z+5MF+MxMz2xDYGjBbNaZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648601; c=relaxed/simple;
	bh=dED6kHIaP9Dw5gZbEuF4TG4www/WDQ8bIyKV2hsmWgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gL9W9DPhNyk3ea/QLkR4n7MG9AVXLWqWRoTUgACxFWyX6FN/3NBGN/9R2CwlU7ukXmJ4wqAf8lAkONIIJLRU7oM0ovSCkITnu683BoumdSBEu9FqZXuXhAM8uZd7i52TDCZckbylCPSWgBhg0RnhnxPGZUkwLWa6GCJPTMBli0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9JYdsQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9JYdsQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369E61F000E9;
	Tue, 21 Jul 2026 15:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648600;
	bh=ICpL6Y8SzHvviCyGfM1FQlQL6/AYQecVyplYwPU38r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9JYdsQYAUez97rOnyR5IpHElyWykdGg+Au34WAr7eYVnjpbtpqj+v9tIocVmx7bC
	 c47cttq23jfoVyFH6m3gAExgKS++dHa+rl9U5Edldxfh5VoNnnEZSVZ361wj64YKht
	 W/WipMTWYEILhZkhC0N778oA2B+qydvEJMOPRVd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nishanth Sampath Kumar <nissampa@cisco.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0260/2077] regmap-i2c: fix sparse warning in regmap_smbus_word_write_reg16
Date: Tue, 21 Jul 2026 16:58:53 +0200
Message-ID: <20260721152558.810556293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Sampath Kumar <nissampa@cisco.com>

[ Upstream commit 34808ac8ddafc3e2c2a59e84eaab0a410e7a0fdc ]

i2c_smbus_write_word_data() expects a plain u16, but cpu_to_le16()
returns __le16 (a sparse-restricted endian type), causing:

  drivers/base/regmap/regmap-i2c.c:340: sparse: incorrect type in
  argument 3 (different base types)
    expected unsigned short [usertype] value
    got restricted __le16 [usertype]

SMBus already defines byte ordering internally, so cpu_to_le16() is
wrong here. Replace it with a plain (u16) cast.

Fixes: bad4bd28abf4 ("regmap-i2c: add SMBus byte/word reg16 bus for adapters lacking I2C_FUNC_I2C")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605161621.mY5zFh4D-lkp@intel.com/
Signed-off-by: Nishanth Sampath Kumar <nissampa@cisco.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 31e30dfced192f..51a04961faf7be 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -337,7 +337,7 @@ static int regmap_smbus_word_write_reg16(void *context, const void *data,
 	val = ((u8 *)data)[2];
 
 	return i2c_smbus_write_word_data(i2c, addr_hi,
-					 cpu_to_le16(((u16)val << 8) | addr_lo));
+					 ((u16)val << 8) | addr_lo);
 }
 
 static const struct regmap_bus regmap_smbus_byte_word_reg16 = {
-- 
2.53.0



