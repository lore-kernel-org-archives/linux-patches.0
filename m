Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD95F151CD6;
	Tue, 20 Feb 2024 21:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462872; cv=none; b=mnZ9cvOLWUNyqqykt51tiNlC4w6IOTdq4Eh3UcF/fbwoPDaG+UZbZQ+XlVt1BZ0NbGsOYZmqdvsIt/y0WjJMLok9CvXx7lzzyS4YvdD6F2YZHLnvrAGrexLQV3bNJ23dCloh8tgZWwcqAWRrw7rgxnCZ4tsZwpOFtORscRhmyYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462872; c=relaxed/simple;
	bh=Qj8A7J6HhtYMoio8+vmAlaCr7erbjM52vRGl0idb/0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB04nCrfi9apZ6kuj6wi8Q0fonV9ASxhiQ9wcgr77MlEdWF44lPuk1U0y3UScSuL4ImItOOOVsG7Y5+NlpZO+Mij7HnqYgM9rOAzC58zE1PsmeuIXyLzWBbLAwYniJqP+gbBYvuB+T07I1aUXQE3hOtQOKhP7FwvoBBwGnp+feI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzbds5UE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzbds5UE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB8C43390;
	Tue, 20 Feb 2024 21:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462872;
	bh=Qj8A7J6HhtYMoio8+vmAlaCr7erbjM52vRGl0idb/0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzbds5UE2GCSjOwDax+AFo8InNqW1WvV4UxqUHWzbNELEvzU4ym4PNvdEX9Eic74z
	 y9Wx1ZNx/AKEny0soRE1Z9d5nchsHxEU7CzZDaofOVhF7WtA3dOsa1PwPXlum/F+VH
	 BX/ll338paLPquoAYoPUQxmrn0A9L5GB2E5KlHP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sven Peter <sven@svenpeter.dev>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/197] i2c: pasemi: split driver into two separate modules
Date: Tue, 20 Feb 2024 21:50:22 +0100
Message-ID: <20240220204842.968585393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
 drivers/i2c/busses/i2c-pasemi-core.c | 5 +++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index e73cdb1d2b5a..784a803279d9 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -89,10 +89,8 @@ obj-$(CONFIG_I2C_NPCM)		+= i2c-npcm7xx.o
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
index 9028ffb58cc0..f297e41352e7 100644
--- a/drivers/i2c/busses/i2c-pasemi-core.c
+++ b/drivers/i2c/busses/i2c-pasemi-core.c
@@ -356,3 +356,8 @@ int pasemi_i2c_common_probe(struct pasemi_smbus *smbus)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pasemi_i2c_common_probe);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Olof Johansson <olof@lixom.net>");
+MODULE_DESCRIPTION("PA Semi PWRficient SMBus driver");
-- 
2.43.0



