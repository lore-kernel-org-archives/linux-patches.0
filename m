Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F7E17B418;
	Sun,  7 Jun 2026 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827261; cv=none; b=bfvgC/9AgBT1z8Nyq4z/ygwAv0lAc4+SK/8ArBwiSHIhPzctHYciDeUfh7Cj5LlIy4ckYXIIzkVU805fQtEM1EYKZC5FGwuI01rhCJXTefSN/9iGK4xN7YPl8CXUez1Be9EadC0qSfoTFpTPnj6kdbkwlLYnhadZ8cpMZLUak8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827261; c=relaxed/simple;
	bh=HZ8bPFuhl19wXW/YcuV02KK+iOiGaTc+c5JvEQmmO5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRTf1g0aI/Dh1VF8J+BZhj8QUo8+084Moz2AN3DLyEs3uiUge5vSsboC3rjW7eLibbxESnry/BX0LQ4qESHX2SyYWw+OgL6pKh33GSjEMs45xE0iMP/XEwn2S9TSV3X/mHWizCoWmQR2xF9lZ++7lDNGceSJxtbD7sf3X0zEH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBLVbXUt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBLVbXUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70491F00893;
	Sun,  7 Jun 2026 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827260;
	bh=EnOzmdPbQ1N28Nt4UMTT/pQKvIL2fLroKpjC/UYzv+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBLVbXUtBS9eGlxjQyl+3vNOVsisPKn3nZRkEAi+KX6sA+vPkJ9UPEZEgr/J3mtuh
	 bZ05HuM47OZfo/2Akkfc2G63lkRnuJxYv9HsRs/jIuFyZFZCxqQLZkALkZbD0ztx86
	 8JwTJDaz8TMrKc0e7iKjVdMc/ybzLIZy17ENUyLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 048/332] ethtool: module: avoid leaking a netdev ref on module flash errors
Date: Sun,  7 Jun 2026 11:56:57 +0200
Message-ID: <20260607095729.887396691@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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
index 8047c14f7ee370..594a49fdd7fd06 100644
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



