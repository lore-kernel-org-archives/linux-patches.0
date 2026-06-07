Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFEF1E98EF;
	Sun,  7 Jun 2026 10:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827150; cv=none; b=dK3UUCrgbeF/iEWZTJJCyjXN3IrI3xFJ3b5v7lpg1G9HXRJmmNRMm8V6x7qGHGutYK9GFTNwvseY/4wHM8jQnrgafcjeKB++/x4Ubn8yEo5/pbB2v8QgAuUxfTgvXgrr3R2YcXNjuXvJdzc9s720ymXe+yAmX+zInYHdngC54Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827150; c=relaxed/simple;
	bh=HZKZMIlCqtudlU12xEcKtHj0C/YtI4Ba97efJQQwM6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhKbMD3jWSkqBRIMyhUBvnFGgqGTMF9Ay7gAe3dvoguya5+WOoTqWMQmVIXxzrchzmYFFXpGOmcRv8xQw8TOcXrTBb0LqLl31xcm2ZXSTJrsOwDysbqI66pjzUzdAlpnyV3m8vZfj946l2mNRCtv+UsY94B/3hAWM4p77zirEXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWWPavtW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWWPavtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7F11F00893;
	Sun,  7 Jun 2026 10:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827149;
	bh=kMU1qE5bQrFnEefM2ohMcjOdaiRDv0RG7TmhXfQGagY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWWPavtWxpBfeTELiDahTub0CnudJWvo6PAOk7u+pS7/bGQvTO0ToDcjsMKogyZk4
	 ApT7YIqvU1s/8Uf+jFJabU8QePWQ2xw5GbwMaZ2lKIRhkD8IMPcyZvcPT+4otPOLwg
	 1t8mgJPDX2DTSAwAW6rJFOADokOCCIFvPgpndHpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/315] ethtool: module: call ethnl_ops_complete() on module flash errors
Date: Sun,  7 Jun 2026 11:57:11 +0200
Message-ID: <20260607095729.185550577@linuxfoundation.org>
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

[ Upstream commit 84371fb58423f997939aacdcbc02d128d76a54e5 ]

When validate() fails we are skipping over ethnl_ops_complete()
even tho we already called ethnl_ops_begin().

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 4d4e0a82579a2b..05e4c1d785656f 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -427,10 +427,11 @@ int ethnl_act_module_fw_flash(struct sk_buff *skb, struct genl_info *info)
 
 	ret = ethnl_module_fw_flash_validate(dev, info->extack);
 	if (ret < 0)
-		goto out_unlock;
+		goto out_complete;
 
 	ret = module_flash_fw(dev, tb, skb, info);
 
+out_complete:
 	ethnl_ops_complete(dev);
 
 out_unlock:
-- 
2.53.0



