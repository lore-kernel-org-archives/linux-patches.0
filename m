Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7435514A4E6;
	Tue, 20 Feb 2024 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464711; cv=none; b=u6xfYLhUCyoV/tivRpuzhUThwoJQNzaPRWsj8U7rM5fYQWxPWTJ4VnsrcCtDq+t/27whKN1EjpB53uSp13kQFSKEZ404ANBvx/U3aguijVXG4LA0kjMSN5SedA//MfMSxqRnM2nh7PGhqz0QOghNpsHMAbAhGqU5e7ADojkaZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464711; c=relaxed/simple;
	bh=TYSkgrsYV9TLn42i6O13wFAlmY3qQYBrj8y1VzLyfUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GouhR290KIDB2Iq4kRwAJczh1yK5goN9c2vzP2aotPmNLo3Yfe+PiW3oi73fJpqusw6sbZQjDO7bYpZqnIfR2CtJvGpRFvYQF1u9LJvbpVt4GDq1hye748lqyWGa6IzA864C09DEARQE2uc9AF5FPxtmUH4YkL69m/RdTrwCXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQz4rWPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQz4rWPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B07C433C7;
	Tue, 20 Feb 2024 21:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464711;
	bh=TYSkgrsYV9TLn42i6O13wFAlmY3qQYBrj8y1VzLyfUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQz4rWPZNyqGurLQG6NXextHdaxVXABCtjX+gYoPLmKnKKINPscQQY6yt/AyG24iE
	 MSsW4FrO9bPiUPCyBWHUMLu0FBMF4RcRgvAfB5supAvg9ABCTRQjLeyNTPb5t8HbKh
	 jARR4GsF+gKR4WeKCl42rOzD0TiQJidINA9C1Ro4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sven Peter <sven@svenpeter.dev>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 112/309] i2c: pasemi: split driver into two separate modules
Date: Tue, 20 Feb 2024 21:54:31 +0100
Message-ID: <20240220205636.694676800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f44bff19268517ee98e80e944cad0f04f1db72e3 ]

On powerpc, it is possible to compile test both the new apple (arm) and
old pasemi (powerpc) drivers for the i2c hardware at the same time,
which leads to a warning about linking the same object file twice:

scripts/Makefile.build:244: drivers/i2c/busses/Makefile: i2c-pasemi-core.o is added to multiple modules: i2c-apple i2c-pasemi

Rework the driver to have an explicit helper module, letting Kbuild
take care of whether this should be built-in or a loadable driver.

Fixes: 9bc5f4f660ff ("i2c: pasemi: Split pci driver to its own file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Makefile          | 6 ++----
 drivers/i2c/busses/i2c-pasemi-core.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 3757b9391e60..aa0ee8ecd6f2 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -90,10 +90,8 @@ obj-$(CONFIG_I2C_NPCM)		+= i2c-npcm7xx.o
 obj-$(CONFIG_I2C_OCORES)	+= i2c-ocores.o
 obj-$(CONFIG_I2C_OMAP)		+= i2c-omap.o
 obj-$(CONFIG_I2C_OWL)		+= i2c-owl.o
-i2c-pasemi-objs := i2c-pasemi-core.o i2c-pasemi-pci.o
-obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi.o
-i2c-apple-objs := i2c-pasemi-core.o i2c-pasemi-platform.o
-obj-$(CONFIG_I2C_APPLE)	+= i2c-apple.o
+obj-$(CONFIG_I2C_PASEMI)	+= i2c-pasemi-core.o i2c-pasemi-pci.o
+obj-$(CONFIG_I2C_APPLE)		+= i2c-pasemi-core.o i2c-pasemi-platform.o
 obj-$(CONFIG_I2C_PCA_PLATFORM)	+= i2c-pca-platform.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
diff --git a/drivers/i2c/busses/i2c-pasemi-core.c b/drivers/i2c/busses/i2c-pasemi-core.c
index 7d54a9f34c74..bd8becbdeeb2 100644
--- a/drivers/i2c/busses/i2c-pasemi-core.c
+++ b/drivers/i2c/busses/i2c-pasemi-core.c
@@ -369,6 +369,7 @@ int pasemi_i2c_common_probe(struct pasemi_smbus *smbus)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pasemi_i2c_common_probe);
 
 irqreturn_t pasemi_irq_handler(int irq, void *dev_id)
 {
@@ -378,3 +379,8 @@ irqreturn_t pasemi_irq_handler(int irq, void *dev_id)
 	complete(&smbus->irq_completion);
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(pasemi_irq_handler);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Olof Johansson <olof@lixom.net>");
+MODULE_DESCRIPTION("PA Semi PWRficient SMBus driver");
-- 
2.43.0



