Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C943C05C;
	Tue, 16 Jun 2026 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623049; cv=none; b=UjDl36kdpAmpTTxe0of441OOFbT947Mjebaue/QAmZk3/MvdNg8oiqnauSLrcBXEW/p+TittyjMKf4VXry9JNVovYK3JfJNrHruwZ+JAtab1VosQZ+CW/GwYoFphq4jPFDbq/xEy/KcSHzyj/6nxmb+msog2XJWvVLOoy6OBU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623049; c=relaxed/simple;
	bh=FWkqqoWo0gElHk4GxkNALTY1Squ9eKQuSXpo0DKta8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU1k4eAOyWH8CNaoSwd0PCsGBCWpX/dxYnHvAQb2CdFrWDrlQtiM6ZFCNSc41g6CNV7lPEXB7OxUjio9WbRb3HlL//BJ+v41LeBtOM8YDjOADGlq3E1ep0msvfp7fk04Z7SbJp+c+7P5nN/GLrzso+ppkO8o0drOcjrRh375Wyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSZl83UW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSZl83UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4621F000E9;
	Tue, 16 Jun 2026 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623048;
	bh=n0dSZhOiKHv8XPsO6p3Cues02+DVwwO/9EaMDcC+FXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSZl83UW/lPJ5Zu1a9BGUQpzNmelkb+AKWYbi/kq1WGb3oUZzFEos5My9w3pgkzY1
	 8rmVIcDWpV3gIzTWt6TlAk5bqR9S+5GF4zvVSrvRo+NrnK31TxzTkWcqAbE7eM++iT
	 VOcsp4tqVSPXSUZRaRpoWH6SfhGOs7yDL0njz+wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 079/378] regulator: mt6363: select CONFIG_IRQ_DOMAIN
Date: Tue, 16 Jun 2026 20:25:10 +0530
Message-ID: <20260616145114.347899439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 29d87434cb91b7689de2917830ca82acfd2770f5 ]

When build-testing this driver without CONFIG_IRQ_DOMAIN causes
a compile-time error:

drivers/regulator/mt6363-regulator.c: In function 'mt6363_regulator_probe':
drivers/regulator/mt6363-regulator.c:884:18: error: implicit declaration of function 'irq_find_host' [-Wimplicit-function-declaration]
  884 |         domain = irq_find_host(interrupt_parent);
      |                  ^~~~~~~~~~~~~
drivers/regulator/mt6363-regulator.c:884:16: error: assignment to 'struct irq_domain *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  884 |         domain = irq_find_host(interrupt_parent);
      |                ^
drivers/regulator/mt6363-regulator.c:896:30: error: implicit declaration of function 'irq_create_fwspec_mapping'; did you mean 'irq_create_of_mapping'? [-Wimplicit-function-declaration]
  896 |                 info->virq = irq_create_fwspec_mapping(&fwspec);
      |                              ^~~~~~~~~~~~~~~~~~~~~~~~~
      |                              irq_create_of_mapping

This is rather hard to trigger because so many other drivers
enable IRQ_DOMAIN already, but I ran into this on an s390
randconfig build.

Ensure this is always enabled using a Kconfig 'select IRQ_DOMAIN'
entry, as we do for all other users of this.

Fixes: 3c36965df808 ("regulator: Add support for MediaTek MT6363 SPMI PMIC Regulators")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260526102003.2527570-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index d10b6f9243d515..426642d7a02c0c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -977,6 +977,7 @@ config REGULATOR_MT6363
 	tristate "MT6363 SPMI PMIC regulator driver"
 	depends on SPMI
 	select REGMAP_SPMI
+	select IRQ_DOMAIN
 	help
 	  Say Y here to enable support for regulators found in the MediaTek
 	  MT6363 SPMI PMIC.
-- 
2.53.0



