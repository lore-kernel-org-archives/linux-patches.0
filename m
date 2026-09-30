Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DFB5221F4;
	Wed, 30 Sep 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790962; cv=none; b=ldofG/SgUwEp0m9p6QclXv+3IoOWjIuY04Gwdq0fIdnSKpdQlaKR47SaM1imb4Kav8JCeL0MAC751szQCOsVaNCRvNIQbMh5H56abaIA30pHUcJY+QBs4zsZBfyZGtxR3NUtR+0oO2Nz/FqrAujSx2BH5LniCCmlRupzM+TFZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790962; c=relaxed/simple;
	bh=IKSobiAyP5KaciFsrNsVTlmdjDM+OoMmlmso8ewtaEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsbLWRUNcgjgY78brlehnmvc+NEEYP2i2dGEQir+tl28IzkzYsiuLdVnn24yXWzVLQYrHWauZMpNQl+kgdVhSNQ41T9LfdZr5Pkq3bFpu8cp7ZHq+2VBz+yUT6w1+4t/ryJAUkuvia1zBeHIQCJB9cV9r5BlJCDSO1Xcxv/YLyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN9zrUv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN9zrUv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322821F000FF;
	Wed, 30 Sep 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790960;
	bh=trm8vmX4f0MyOtFHPVXtx6vpwyDUmstaBQt5Vnye970=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RN9zrUv3BDOZ09NtZG7LG8jF0slL8vheoRp0IGdqjXYEESxG9M8g/CQg6X/5q/Q+f
	 KTXdmcaaVCI45A1rh21FaC2l8Mhj0qwa24r+0mVO1i1igVWt0ydVkPOw5lAm70dOd4
	 ayv5na70F9/NqK2EW7IlLtIl5FBhLLzdgbFSwrv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/752] net: cpsw_new: unregister devlink on port registration failure
Date: Wed, 30 Sep 2026 17:19:53 +0200
Message-ID: <20260930152400.842889604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b64f763b607426ac97e44b114f0b8844ac3b86dd ]

cpsw_probe() registers devlink before registering the CPSW ports.

If cpsw_register_ports() fails, the error path only unregisters the
notifiers and then releases the lower level resources. It does not undo
the successful cpsw_register_devlink() call, leaving the devlink instance
and its parameters registered after probe has failed.

Add a devlink cleanup label for the path where devlink registration has
already succeeded, and use it when port registration fails.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260604043115.1409134-1-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw_new.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index bef2c71b90597..66e81c7abce66 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2030,7 +2030,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	ret = cpsw_register_ports(cpsw);
 	if (ret)
-		goto clean_unregister_notifiers;
+		goto clean_unregister_devlink;
 
 	dev_notice(dev, "initialized (regs %pa, pool size %d) hw_ver:%08X %d.%d (%d)\n",
 		   &ss_res->start, descs_pool_size,
@@ -2042,6 +2042,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	return 0;
 
+clean_unregister_devlink:
+	cpsw_unregister_devlink(cpsw);
 clean_unregister_notifiers:
 	cpsw_unregister_notifiers(cpsw);
 clean_cpts:
-- 
2.53.0



