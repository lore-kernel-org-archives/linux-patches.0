Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B272AD00;
	Sun,  7 Jun 2026 10:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827390; cv=none; b=pmWJvm+d9yuKMR8PCaUI56e+GvzBjQ6ryRSpeSaMRf7rAy6Sl3W8HcGffCLhb6Uqs5Aak0mlRdDPrD5mtPUsij4/d7136yMs4KXrjuscl2VtHevc9SVntGP/9iDTeXSFV6JAkj2hD8qj9IpWoa180doNwmT6rVM6B8Jvd+DHR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827390; c=relaxed/simple;
	bh=QLUqtQ29Z2D80a8rKb2YLU1lT7ZxWqj5OMvLDIhbttI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oW9uxQ4qkoQBaH02z1f1v2L22H4VwRAuFXwjYIiFA8Z7TXGNvy65XMmGt4SX5e+kyg+p7V1tMt7f3Rui2YtKMf85QnSbGaUFfprdjmIgXzTNIyYXareACfistr1ATRXnFyCZC9Hxlao6nHWvRFX+ZQuoPRBdDzmO+M1uAujECXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFkktho3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFkktho3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA15F1F00893;
	Sun,  7 Jun 2026 10:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827389;
	bh=0j1VLAUu8DIdgd6L1NVqcuOhiSA9PFeakEiIXh1cPcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFkktho309IK6DPYHpuvA8eiiJEhC1L4fVEZ7BeP/V23s+ReOGBQ1+/DSjAAABCbZ
	 GEQ5QiSsWqPkkhjK7drSRWz00nMC+iWlSA/vPU9F5cZqHXoyKDJIw1FGG65u+ni59t
	 b/nufu18itLiUzlg1RpRUfy0+Yw4uWdLJEsEfGJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/307] ethtool: module: check fw_flash_in_progress under rtnl_lock
Date: Sun,  7 Jun 2026 11:57:28 +0200
Message-ID: <20260607095729.593945568@linuxfoundation.org>
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

[ Upstream commit 504eaefa44c8dec50f7499edcb36d24f3aefab2a ]

ethnl_set_module_validate() inspects module_fw_flash_in_progress
but validate is meant for _input_ validation, not state validation.
rtnl_lock is not held, yet. Move the check into ethnl_set_module().

Fixes: 32b4c8b53ee7 ("ethtool: Add ability to flash transceiver modules' firmware")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/module.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 76d13ef4ba0427..ab1e8a83acd0b1 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -119,12 +119,6 @@ ethnl_set_module_validate(struct ethnl_req_info *req_info,
 	if (!tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY])
 		return 0;
 
-	if (req_info->dev->ethtool->module_fw_flash_in_progress) {
-		NL_SET_ERR_MSG(info->extack,
-			       "Module firmware flashing is in progress");
-		return -EBUSY;
-	}
-
 	if (!ops->get_module_power_mode || !ops->set_module_power_mode) {
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY],
@@ -147,6 +141,12 @@ ethnl_set_module(struct ethnl_req_info *req_info, struct genl_info *info)
 
 	ops = dev->ethtool_ops;
 
+	if (dev->ethtool->module_fw_flash_in_progress) {
+		NL_SET_ERR_MSG(info->extack,
+			       "Module firmware flashing is in progress");
+		return -EBUSY;
+	}
+
 	power_new.policy = nla_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
 	ret = ops->get_module_power_mode(dev, &power, info->extack);
 	if (ret < 0)
-- 
2.53.0



