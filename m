Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D90D2727F3;
	Wed,  8 Apr 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674102; cv=none; b=UBDhQW9/lvAv2V6JSmO4FxEn7vD411fPuDDGM8ZNBnvBON4yi9huCvmCuzeo+h+yVe82BWNJn/9fIZtldIzmCwDEui/drF/ONe26Of/FHA9ulXDQxJWwMdSHG43gXkd0tEm9yocnOpw+YSvjQIUGPP44BIrn0b7UMDl/F5XXb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674102; c=relaxed/simple;
	bh=WFbX8B8VntRB2UEr/dn/njWdJetAwyW+2t0ig8HNGUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXQCRUmHRoMSF9nChxHa1bW/lXPat3eg75qsnYWtU4H/JTTvKrkfBikKXeeO31KaYBCOLTPDwU2S5mxy98ccqraeV2vD5kIHDWDe1uQg5H6sbSZOSMMPU6EuYi3WcudHnicd/ebT8YcWugcGXmQaZ6j1E+0nCdEi/K4+ZftF+7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fC451Dhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fC451Dhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1377BC19421;
	Wed,  8 Apr 2026 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674102;
	bh=WFbX8B8VntRB2UEr/dn/njWdJetAwyW+2t0ig8HNGUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fC451DhvPd+b3am8iY38ghI5E4xKQuEWOdTtETazL+/wBXCNF+6Q3t7uBpMN1zJmh
	 uH4kpmq9cbWMfieFGgCCMOOUONuswpNW5sCK6MdwWbAjiszRLRYCUT3ZYW3bZ8ErGk
	 +UCDhnc6RQzthv58Yg8Xq5ADEQ6jW2vq2Sj3zTZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.12 178/242] firmware: microchip: fail auto-update probe if no flash found
Date: Wed,  8 Apr 2026 20:03:38 +0200
Message-ID: <20260408175933.748519479@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit c7596f9001e2b83293e3658e4e1addde69bb335d upstream.

There's no point letting the driver probe if there is no flash, as
trying to do a firmware upload will fail. Move the code that attempts
to get the flash from firmware upload to probe, and let it emit a
message to users stating why auto-update is not supported.
The code currently could have a problem if there's a flash in
devicetree, but the system controller driver fails to get a pointer to
it from the mtd subsystem, which will cause
mpfs_sys_controller_get_flash() to return an error. Check for errors and
null, instead of just null, in the new clause.

CC: stable@vger.kernel.org
Fixes: ec5b0f1193ad4 ("firmware: microchip: add PolarFire SoC Auto Update support")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/microchip/mpfs-auto-update.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/firmware/microchip/mpfs-auto-update.c
+++ b/drivers/firmware/microchip/mpfs-auto-update.c
@@ -113,10 +113,6 @@ static enum fw_upload_err mpfs_auto_upda
 	 * be added here.
 	 */
 
-	priv->flash = mpfs_sys_controller_get_flash(priv->sys_controller);
-	if (!priv->flash)
-		return FW_UPLOAD_ERR_HW_ERROR;
-
 	erase_size = round_up(erase_size, (u64)priv->flash->erasesize);
 
 	/*
@@ -427,6 +423,12 @@ static int mpfs_auto_update_probe(struct
 		return dev_err_probe(dev, PTR_ERR(priv->sys_controller),
 				     "Could not register as a sub device of the system controller\n");
 
+	priv->flash = mpfs_sys_controller_get_flash(priv->sys_controller);
+	if (IS_ERR_OR_NULL(priv->flash)) {
+		dev_dbg(dev, "No flash connected to the system controller, auto-update not supported\n");
+		return -ENODEV;
+	}
+
 	priv->dev = dev;
 	platform_set_drvdata(pdev, priv);
 


