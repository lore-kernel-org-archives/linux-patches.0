Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E515AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C240C433C7;
	Tue, 25 Jul 2023 10:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282770;
	bh=Y1thFwVoES51AB1wPzTd0ivxRPqBzGtpvZ+MM/mJa3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9vTSXfy2h3fNFYYDpL3ovARqmYqSEzJ9c48Un0ZBrnBuFJOYwsMplbqaD19SahqV
	 uCAszmVN8Psy/TM0uzFqSJ7ZV6TZfMyuFOXDvrTMxPzcJdHowISJtByUTwW5mI5Q4/
	 GzaPZt34NIGJeq6lMQWUqrAPjE8ruFKuo/+lE2pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.1 020/183] regmap: Account for register length in SMBus I/O limits
Date: Tue, 25 Jul 2023 12:44:08 +0200
Message-ID: <20230725104508.608069747@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit 0c9d2eb5e94792fe64019008a04d4df5e57625af upstream.

The SMBus I2C buses have limits on the size of transfers they can do but
do not factor in the register length meaning we may try to do a transfer
longer than our length limit, the core will not take care of this.
Future changes will factor this out into the core but there are a number
of users that assume current behaviour so let's just do something
conservative here.

This does not take account padding bits but practically speaking these
are very rarely if ever used on I2C buses given that they generally run
slowly enough to mean there's no issue.

Cc: stable@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20230712-regmap-max-transfer-v1-2-80e2aed22e83@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regmap-i2c.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -242,8 +242,8 @@ static int regmap_i2c_smbus_i2c_read(voi
 static const struct regmap_bus regmap_i2c_smbus_i2c_block = {
 	.write = regmap_i2c_smbus_i2c_write,
 	.read = regmap_i2c_smbus_i2c_read,
-	.max_raw_read = I2C_SMBUS_BLOCK_MAX,
-	.max_raw_write = I2C_SMBUS_BLOCK_MAX,
+	.max_raw_read = I2C_SMBUS_BLOCK_MAX - 1,
+	.max_raw_write = I2C_SMBUS_BLOCK_MAX - 1,
 };
 
 static int regmap_i2c_smbus_i2c_write_reg16(void *context, const void *data,
@@ -299,8 +299,8 @@ static int regmap_i2c_smbus_i2c_read_reg
 static const struct regmap_bus regmap_i2c_smbus_i2c_block_reg16 = {
 	.write = regmap_i2c_smbus_i2c_write_reg16,
 	.read = regmap_i2c_smbus_i2c_read_reg16,
-	.max_raw_read = I2C_SMBUS_BLOCK_MAX,
-	.max_raw_write = I2C_SMBUS_BLOCK_MAX,
+	.max_raw_read = I2C_SMBUS_BLOCK_MAX - 2,
+	.max_raw_write = I2C_SMBUS_BLOCK_MAX - 2,
 };
 
 static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,


