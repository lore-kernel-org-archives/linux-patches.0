Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5561D46A611;
	Tue, 21 Jul 2026 15:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648906; cv=none; b=C1eXhN3VEhjMrWGiDPuwqBPJmSepyrA0IaVZQz5ecZv2VI5sUOxyDno8UOpDzhR5PTpOEYROBRqal43YLa8HqJ5lqY/4MciLI06b0lpu0d0sPKf7nVqgmvxCjLjpsr93pdrwHEsCSr0C3uP3Peah70JbIFOfLWNeOuypUmOV1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648906; c=relaxed/simple;
	bh=5JIeuv11Xj5nVT97nIvUVsqdp70grb0Y9gC7OzKBsLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feCuj+7AiB9WA9XiAsqVFKMjv5i0nBkY9jvDux73VOLNFHx5wKZwW2yMKqT8kEhToc4JG9RkV0F/Bg9z0H/zZMRfAT2Saa3VUyQRTiALVt62k1jbHHw+/qIP09rwkyIp4+d9uOtxp62jQv+4829eQthVej2e0xwg9QgVZuHCEF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+x8tGag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+x8tGag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D231F000E9;
	Tue, 21 Jul 2026 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648904;
	bh=baIvD206u7VgW0qv/SrTTBGMw2wzZgJbKt7St0UlQ+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+x8tGag/jzbGQspTMltAQIFB5zukuHIOT84pM0KEQXSXEVb5ObrLxXkmDmgpVBlU
	 DmLh3Mm+X0qlNGgG8Vy9nfhZumPJuuIulh2+nwc62Qj5EjyKQ4SwNFuI5KyfqdRtQj
	 FCHYUbyDFV3o+R8OgTAgSqeQV/1gbZwGq7jM/UIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0377/2077] EDAC/igen6: Fix call trace due to missing release()
Date: Tue, 21 Jul 2026 17:00:50 +0200
Message-ID: <20260721152601.582619647@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit ab1f9d466c7d83ab0d2a529e07984e53b5960dcd ]

When unloading the igen6_edac driver, there is a call trace:

  Device '(null)' does not have a release() function, it is broken and must be fixed.
  See Documentation/core-api/kobject.rst.
  WARNING: drivers/base/core.c:2567 at device_release+0x84/0x90, CPU#5: rmmod/127209
  ...
  RIP: 0010:device_release+0x84/0x90
  Call Trace:
   <TASK>
   kobject_put+0x8c/0x220
   put_device+0x17/0x30
   igen6_unregister_mcis+0xa2/0xe0 [igen6_edac]
   igen6_remove+0x82/0xb0 [igen6_edac]
   ...

Fix the call trace by providing empty release() functions for the
memory controller devices.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260403054029.3950383-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index fcb8ab44cba55b..0bf9cf349d0b4e 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1296,6 +1296,11 @@ static bool igen6_imc_absent(void __iomem *window)
 	return readl(window + MAD_INTER_CHANNEL_OFFSET) == ~0;
 }
 
+static void imc_release(struct device *dev)
+{
+	/* Nothing to do, the 'imc' owns the 'dev' and will also release it. */
+}
+
 static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev)
 {
 	struct edac_mc_layer layers[2];
@@ -1334,6 +1339,7 @@ static int igen6_register_mci(int mc, void __iomem *window, struct pci_dev *pdev
 	mci->pvt_info = &igen6_pvt->imc[mc];
 
 	imc = mci->pvt_info;
+	imc->dev.release = imc_release;
 	device_initialize(&imc->dev);
 	/*
 	 * EDAC core uses mci->pdev(pointer of structure device) as
-- 
2.53.0



