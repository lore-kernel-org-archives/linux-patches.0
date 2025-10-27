Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB1F238145;
	Mon, 27 Oct 2025 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593223; cv=none; b=r9qktUCUNtnPX+ubdBRaumBOyj+QC4GHwTnqdE2TiQy1pjogPXK/nM/GtkWgnSoeYwZHbUbLC+FDYDQsWy7DrmYDT9Gd+4vBosPRVMtMs2PX4d57+1/YRnvdRQDy9bRxDC7TK0znHSNhVxv2MQDSr1XuKn+mm52hW/NsyHcAG7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593223; c=relaxed/simple;
	bh=d5SyBonPkMYBiX6jFlSmoOx8+a+AFkfJXnXzNRs82d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duL/cjQu/e5iQQhcorgsWRiTF+L9KDmwSvToM9OkUdV76jCkPqLUTCfQ2OYMFSlDFNdt65e+wfKxxBl4+EzERs0a68tIUpySlVAmPi0ScBPiLrmreJO/ZwR53mhrLsq4WvqEzu4j0zTKqhlA7/+ort1NSnY0A8G9i2la2ip6Zro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wea3GscR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wea3GscR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519B6C4CEF1;
	Mon, 27 Oct 2025 19:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593223;
	bh=d5SyBonPkMYBiX6jFlSmoOx8+a+AFkfJXnXzNRs82d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wea3GscR7KHaM/aFcQS/EBBZ/pxWr+YLSlWhXrm8RnvGNlL7uzGFGlSzAQAmRRKLv
	 8VlDpjlbwUos8i07RI6S3TZXFNsFpNqmcjYzpmm864S62AgF+7ShURs7JaY4ZGkJGH
	 5ik7ydmJfetAKsJ7uv42Y++GEHKqrM5R3PFQG+Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/184] net: phy: micrel: always set shared->phydev for LAN8814
Date: Mon, 27 Oct 2025 19:35:41 +0100
Message-ID: <20251027183516.481934215@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 399d10934740ae8cdaa4e3245f7c5f6c332da844 ]

Currently, during the LAN8814 PTP probe shared->phydev is only set if PTP
clock gets actually set, otherwise the function will return before setting
it.

This is an issue as shared->phydev is unconditionally being used when IRQ
is being handled, especially in lan8814_gpio_process_cap and since it was
not set it will cause a NULL pointer exception and crash the kernel.

So, simply always set shared->phydev to avoid the NULL pointer exception.

Fixes: b3f1a08fcf0d ("net: phy: micrel: Add support for PTP_PF_EXTTS for lan8814")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20251021132034.983936-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 605b0315b4cb0..99f8374fd32a7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4109,6 +4109,8 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phy_package_get_priv(phydev);
 
+	shared->phydev = phydev;
+
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);
 
@@ -4164,8 +4166,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 
 	phydev_dbg(phydev, "successfully registered ptp clock\n");
 
-	shared->phydev = phydev;
-
 	/* The EP.4 is shared between all the PHYs in the package and also it
 	 * can be accessed by any of the PHYs
 	 */
-- 
2.51.0



