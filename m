Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F76F11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938B2C433C8;
	Mon, 28 Aug 2023 10:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218465;
	bh=lPpCcTLoEe/ThfTtYNQrticZfVYTIk3V1n4qaWulrVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5e2YI47r/63xInmq4tqyhaQTAS3ejO6Ql7Nih80m3t2gcZMNCByOFgyJzvqnuKl+
	 siquph2tlw5nO04Xuuehw0XCnecWdZMxc2YEG38vu91RbZWwpqpkkvoVMoMWRCWZcR
	 OcbbkWbkrGX7SsQuX6b+O1rjFgeko8CKr7V7AVc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Xu Yilun <yilun.xu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/129] regmap: Account for register length in SMBus I/O limits
Date: Mon, 28 Aug 2023 12:13:12 +0200
Message-ID: <20230828101156.904232053@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 0c9d2eb5e94792fe64019008a04d4df5e57625af ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -246,8 +246,8 @@ static int regmap_i2c_smbus_i2c_read(voi
 static struct regmap_bus regmap_i2c_smbus_i2c_block = {
 	.write = regmap_i2c_smbus_i2c_write,
 	.read = regmap_i2c_smbus_i2c_read,
-	.max_raw_read = I2C_SMBUS_BLOCK_MAX,
-	.max_raw_write = I2C_SMBUS_BLOCK_MAX,
+	.max_raw_read = I2C_SMBUS_BLOCK_MAX - 1,
+	.max_raw_write = I2C_SMBUS_BLOCK_MAX - 1,
 };
 
 static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,


