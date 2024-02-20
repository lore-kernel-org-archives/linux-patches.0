Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B621A612D7;
	Tue, 20 Feb 2024 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463621; cv=none; b=Izn2CRI6x5bRROel8SBoxD1qNn2DSiNWTq90QWacCBQTbzHm/+21hAJ2wU58CZd83hhJiG2rlsoUmdKqmzG83HDVjkg2+X3TOaxXwj+9XcL6UUR1JpqxgZjpCjrflO7TMBh1HsVUSxDBYhFanBcmFAd5Rb+ws1r4xquPj+ZAC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463621; c=relaxed/simple;
	bh=Qp0obcE7AnE1HAJbCDUJRBiwvUF2Q1dFev/XX2ir72M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzHWyIrte6oPzI6af9v6WolBXVac5DZW2E6YzSNDFJCygotp3SkpPxt4tHoJVt1dWP6dQ7wCAjMHcKvV7sJPmsPuzuTYmNmDtI47DX1ybZc5bgMXwnS7BwejzYDEilkM2GztkDFSnZxQGA2XHwPEf+O2+koWjjoHghqmqqT3TTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCxgJAAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCxgJAAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B090FC433C7;
	Tue, 20 Feb 2024 21:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463621;
	bh=Qp0obcE7AnE1HAJbCDUJRBiwvUF2Q1dFev/XX2ir72M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCxgJAAHCQLYH2HPgDTHK/TK/N237rNvJj4RVH1S8I2ONLiyPn9W5Hl70Qrc8nT4q
	 kTFgiXXXFexi9xJeA2XAf4nC0IR05ulHw52aepQlHaFSTrLqxIeIX1a2k3pqTvRhCP
	 hq/AqSuvhaJw8A1ckZYNxW8g80KaNfnevpUi3uoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sven Peter <sven@svenpeter.dev>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/331] i2c: pasemi: split driver into two separate modules
Date: Tue, 20 Feb 2024 21:53:37 +0100
Message-ID: <20240220205640.758414999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af56fe2c75c0..9be9fdb07f3d 100644
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



