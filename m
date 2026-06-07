Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BC24071DA;
	Sun,  7 Jun 2026 10:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827379; cv=none; b=brAfIKGrx3zGvPG1eQhHIkqUVfVdQJM9LoqP0zRSh9MPrnRsIjKywxFdgwZTHDUCB4nYcKimRlwLwZ73IS37ZutWcp0BNckkerL2LsM2J/PhhC/UVK9lLrvwGc4/gHw+0EnOgkOL9Sy08MXALfXiEmDzxvplbkZ2yvDauL7hygk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827379; c=relaxed/simple;
	bh=vER7IxFvcDIaQc52pHcghVfe2nHO3FMljuvl6MaC4IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+6tJiXUZy2U8f0mpbCgftDh0I+InnNpLQRZ/dSD+J6th0rPDNpRlg+IyIkW9T8KcL2zXhpBP7T4xPwxYQpSE9Xlyyj6kfgKIfZTkBd7QXbobKLoUsOBq+GVF1WPDpUGQIHVY9EelKlaOVpwtSQpfi6+01tb1oekLeIkwHGAIcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP2p06Zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP2p06Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6351F00893;
	Sun,  7 Jun 2026 10:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827378;
	bh=vzbGFkamduSPaXp5XIBhSmapCtSZeawq5o4wT0NZY4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP2p06ZhEdrjFsbDmfnKQR3x/4LURSEkVNOL23G+q5pLIqxK6eKXUTwvYLh3lYQpo
	 gHIfoaEa1ZFUVRhSPYnZXksq+KNsToN8dR+PZqHj/GJIP2/fidD+vTKjJeJShUPGsz
	 Pso9RcJrA16a9TAcgTQ6zOEWvcKlvQNU+4YGtsmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/307] ethtool: module: avoid leaking a netdev ref on module flash errors
Date: Sun,  7 Jun 2026 11:57:27 +0200
Message-ID: <20260607095729.553902630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index 6988e07bdcd6d4..76d13ef4ba0427 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -318,8 +318,6 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	if (err < 0)
 		goto err_release_firmware;
 
-	dev->ethtool->module_fw_flash_in_progress = true;
-	netdev_hold(dev, &module_fw->dev_tracker, GFP_KERNEL);
 	fw_update->dev = dev;
 	fw_update->ntf_params.portid = info->snd_portid;
 	fw_update->ntf_params.seq = info->snd_seq;
@@ -334,6 +332,9 @@ module_flash_fw_schedule(struct net_device *dev, const char *file_name,
 	if (err < 0)
 		goto err_release_firmware;
 
+	dev->ethtool->module_fw_flash_in_progress = true;
+	netdev_hold(dev, &module_fw->dev_tracker, GFP_KERNEL);
+
 	schedule_work(&module_fw->work);
 
 	return 0;
-- 
2.53.0



