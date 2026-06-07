Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E286B1E98E3;
	Sun,  7 Jun 2026 10:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826967; cv=none; b=CW0CRoOKz3mBeQd1tKD0pbEqMs3ZxSNVYPisRpHR3EfLcOwjTOEUpvTXd6Ts3EqnOiMURo4Jdzxc464uAHyeuJTtnKmSYXqhEkc6WS3QUP0mcMt1a5RrE2oXLqtJaoQDF77PxmfXZcCwYLlxPDQ90kQw9cIKkBGPJprBPy035ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826967; c=relaxed/simple;
	bh=QnVTGa5kzefUXggIdPs4BXmKP+YgrZPyxw+XIsLPb5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4tqDivEIy/1pnAFBSaY243wjDPoCMPzIzAqDXNsI1Vm1WQRW7xu2dwlIkr4XgAHgfjea4MFtPoqDr7Mu6wR66rbxAhhOVUJ6bXhpylaZN20A/GwuDyDOWz+Q2j85imVP4xpcxfyNqpT3d4ynTs13BYc8O6QSZiuiDVFZZVR4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3tNQ7C2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3tNQ7C2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D7C1F00893;
	Sun,  7 Jun 2026 10:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826966;
	bh=ggaheT4ihXjNbwRn9yD8uSL9/IOk0z/emSOQYEo/QHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3tNQ7C2QR7n4bm37lGo//zdjIqOpne9Plm9jbQG6bkRwgWkd397/SquA7nVjinTi
	 WhfBHs0JEbSP2Et+6fZUg/74JwRkels317YkpABhUsIqkpqHJ5HCSqxrtOEztN4X01
	 cNWeI7x0MqGJhQx73s3Ad+oaLp/FwheIqoh7axg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 047/332] ethtool: module: call ethnl_ops_complete() on module flash errors
Date: Sun,  7 Jun 2026 11:56:56 +0200
Message-ID: <20260607095729.849717670@linuxfoundation.org>
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
index 0a761bf4771e11..8047c14f7ee370 100644
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



