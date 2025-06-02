Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B342A224893;
	Mon,  2 Jun 2025 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873026; cv=none; b=UDGJM7KlpO2GHoKOUFdm4nBgnjAgtRVFlAM+Ca3oAPlqyWrSHzV8US8g/2LWJTG2WK+E6/BRf72JQZ5SXz3qK4/UWXVVrzAGcEk6d6zEy7Lr5jqkzQF/txb6ieFI9UY7On/12axKSo3UnOS3BngizLk24O30/PrL45wi54bAx54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873026; c=relaxed/simple;
	bh=brgjmxvxiPK2cbO3NQTIZbIJRn51liPM+EUiptRasfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqIEvcZy6NvEimZ5iuM32fF0dyTp9FD75bDVSQjOoCLM+F68IHKZhOOQ2KFZBZkz5ZaEt71sUVNSzhFy88hbfcQ9vWWovPnVO5ordJ+rzu5qgt9vJ2n9TV2W064wrnDSJ5RkbWagrvHa8NUpE09SIfsNcaftMUZAHV1N1V5PQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6wcwvXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6wcwvXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1209CC4CEEB;
	Mon,  2 Jun 2025 14:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873026;
	bh=brgjmxvxiPK2cbO3NQTIZbIJRn51liPM+EUiptRasfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6wcwvXJESVROCmawma1Y63/nHoTDmy+ProuMuvMUFXENuOHGs2F29KkZlE7tW+MM
	 lpxF/OIyAj28acDzioLIlj6SLANmw/xVfSIH9Wgx0qFh297RHvR5SnvDHJDjiFtL1I
	 uQWH3TjCMY1tCmPQ4jj5OH+Kx0+OetvlihBIc55I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/444] i2c: designware: Fix an error handling path in i2c_dw_pci_probe()
Date: Mon,  2 Jun 2025 15:41:11 +0200
Message-ID: <20250602134341.207808681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1cfe51ef07ca3286581d612debfb0430eeccbb65 ]

If navi_amd_register_client() fails, the previous i2c_dw_probe() call
should be undone by a corresponding i2c_del_adapter() call, as already done
in the remove function.

Fixes: 17631e8ca2d3 ("i2c: designware: Add driver support for AMD NAVI GPU")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v5.13+
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/fcd9651835a32979df8802b2db9504c523a8ebbb.1747158983.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 36c13612b55d4..b85f1e4ed13bc 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -335,9 +335,11 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 
 	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
 		dev->slave = i2c_new_ccgx_ucsi(&dev->adapter, dev->irq, &dgpu_node);
-		if (IS_ERR(dev->slave))
+		if (IS_ERR(dev->slave)) {
+			i2c_del_adapter(&dev->adapter);
 			return dev_err_probe(device, PTR_ERR(dev->slave),
 					     "register UCSI failed\n");
+		}
 	}
 
 	pm_runtime_set_autosuspend_delay(device, 1000);
-- 
2.39.5



