Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB41E98EF;
	Sun,  7 Jun 2026 10:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827160; cv=none; b=l8Qmp3jObQxlrWC2dVx+TI8+XYAc19Squ/qz0HxX5sAX5nrWelp0zLNpWZWNvisliIDysOGi+hxN2qqXh9xjD4RPU1RbcbS77y3dteH//Ll2vBVG79Q6M+f8UCA/oftlkOdoWfHLRCLwhGrzeen+edmKILjA82g00zMjaBoDKSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827160; c=relaxed/simple;
	bh=gpjSnFTjX9wOuwtesZXyo7cNNnfenIjc92QUDGlrPm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cA9AjNhbW4wiMGF+4wGNOOtLJcorw9o8gpqdo0wY9xqCI5oW49DrqcqEp6LyvKuOWtoZaeoVO6Wzw2Dv4QbBAMyQ8eA6HYV9gATiDXNWqpMYwMYzjaAKSb4JLaMJuaG8wFsRdpBwnTNMenOrl0kiItg8fj6m0SlEH6dKkBLlzrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhsXODdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhsXODdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222691F00893;
	Sun,  7 Jun 2026 10:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827159;
	bh=IyF2H8yrYiGal9ZFiJ9vAh5/dtHFXhuIgkHEe6y/8Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhsXODdodCUBE7hOIRNqj+wksi38r/B1GbTFwffhxuSeRSM5od6tes1TqvurbNedZ
	 +Ws1Uxsb/tkDrOK13BfjcYCZ7ZzcudjkbDHoRzoGAonBmojnPEpTYnUek8jn0W7Evr
	 bCQIMGk1huP2T0KFx7+IUSGlzUZuyn9PUdEFhMS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/315] ethtool: module: avoid leaking a netdev ref on module flash errors
Date: Sun,  7 Jun 2026 11:57:12 +0200
Message-ID: <20260607095729.228101096@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit fb7f511d62692661846c47f199e0afe25c2982db ]

module_flash_fw_schedule() is missing undo for setting
the "in_progress" flag and taking the netdev reference.
Delay taking these, the device can't disappear while
we are holding rtnl_lock.

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 05e4c1d785656f..fb61bb47083e62 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -319,8 +319,6 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	if (err < 0)
 		goto err_release_firmware;
 
-	dev->ethtool->module_fw_flash_in_progress = true;
-	netdev_hold(dev, &module_fw->dev_tracker, GFP_KERNEL);
 	fw_update->dev = dev;
 	fw_update->ntf_params.portid = info->snd_portid;
 	fw_update->ntf_params.seq = info->snd_seq;
@@ -335,6 +333,9 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	if (err < 0)
 		goto err_release_firmware;
 
+	dev->ethtool->module_fw_flash_in_progress = true;
+	netdev_hold(dev, &module_fw->dev_tracker, GFP_KERNEL);
+
 	schedule_work(&module_fw->work);
 
 	return 0;
-- 
2.53.0



