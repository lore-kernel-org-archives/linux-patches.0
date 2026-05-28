Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB282D1303;
	Thu, 28 May 2026 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999470; cv=none; b=N9tQwZ59n3esa/ZdAbxisl4+j0MEvLKLLki0QpUJcRl1APWdJR2DvwZ+D1+bY37jUH//hoeoFSg4SQQMWWe3GTWOw/Ff+DZ3rzYoFL8CeD8rRHqi8aZHyavS8UujNQQIrqE9Ri7X4zjhtwudAgkd5KZsfw8rvS4xovGCUL3WZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999470; c=relaxed/simple;
	bh=JojF6fKukv1xCJaZd/lv/uxudBmrtBpDY49C7svXvsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQmumJY4DCGYCnje/NECppfGEIwVnnDn6mHEWiu1i4hginsk+RCW8Z1edvKYRfL8B9sbJSsDqbhDA7ozneg1M4S6QthqJs2VgFt8szaw95hRU4Ybv8RC1SLvtMwwLzWfK9UgsisV4p868xTeRION3smIixhc7HQWKmM64vclJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC1Iptrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC1Iptrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C5F1F000E9;
	Thu, 28 May 2026 20:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999469;
	bh=Ggjb7VdAfDbzQvg3etn9K4bViPZoVarIqS7USqcK+L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC1IptrzoSjOYMWZ1EDqMk8X5e9isNbcr50S+FggqDoluPsT7pvKJCaPmjYIltJWi
	 vRer78JZAQV5D8tpZ+TPkgsrN+yFUUIRZpTzmweKP2Y99m9/gqm6Pyybp45Nc/52tc
	 i4AR82KZS/giUa2MbsOnzFdAe//VXUL75fdJJrR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishnamoorthi M <krishnamoorthi.m@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 042/377] spi: amd: Set correct bus number in ACPI probe path
Date: Thu, 28 May 2026 21:44:40 +0200
Message-ID: <20260528194639.592370972@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishnamoorthi M <krishnamoorthi.m@amd.com>

commit 422bd00b71ab42163aa3b8f8370276fe4c1581e7 upstream.

On platforms where the HID2 SPI controller (AMDI0063) is enumerated via
ACPI instead of PCI, amd_spi_probe() unconditionally sets bus_num to 0,
while the PCI probe path assigns bus_num 2 for HID2 controller.

Align the ACPI probe path to use the same bus number so that userspace
and SPI client drivers see a consistent bus assignment regardless of the
enumeration method.

Fixes: b644c2776652 ("spi: spi_amd: Add PCI-based driver for AMD HID2 SPI controller")
Cc: stable@vger.kernel.org # v6.16+
Signed-off-by: Krishnamoorthi M <krishnamoorthi.m@amd.com>
Link: https://patch.msgid.link/20260507180051.4158674-1-krishnamoorthi.m@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-amd.c b/drivers/spi/spi-amd.c
index 4d1dce4f4974..71a6e5c475b0 100644
--- a/drivers/spi/spi-amd.c
+++ b/drivers/spi/spi-amd.c
@@ -868,7 +868,7 @@ static int amd_spi_probe(struct platform_device *pdev)
 	dev_dbg(dev, "io_remap_address: %p\n", amd_spi->io_remap_addr);
 
 	amd_spi->version = (uintptr_t)device_get_match_data(dev);
-	host->bus_num = 0;
+	host->bus_num = (amd_spi->version == AMD_HID2_SPI) ? 2 : 0;
 
 	return amd_spi_probe_common(dev, host);
 }
-- 
2.54.0



