Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE5A2874FE;
	Wed, 28 Jan 2026 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615951; cv=none; b=ZAv3Du/gKQV/6ih5kqUGMU+z2bK960k9L530Cwg8qPAy2pGJ6+W4CN2yL2dAiAYtXvoCo/hbayCHlkvC1mbA1B2YNyJRQIpvuAofV7BffCyI/6rTMD5pDae4os2cLyARApuM8qGSm3gExYKqbV3vfwKF+6rBON91MJ52apwIfoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615951; c=relaxed/simple;
	bh=8LGKA22CaBmaZWrK/F7Zaw8DV4Yuo7+2DE+xqkN4Nk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VV1fxULdw2OWRGodanO+3TgxfpJKudTYk6gBzFrMLwxTWaCXMJQTitF0RKiNqHJYmUlJW+oRHJPRpc7Xx3bIgH59/s1DE0DAr6dwki5DU5t36Cgef3m18GoKjTbxzu/vZflojEUP6Qe/IZGzKVOCv5c8Qg9VdYypmR+7tcLvnbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErRC4R5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErRC4R5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772EDC4CEF1;
	Wed, 28 Jan 2026 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615950;
	bh=8LGKA22CaBmaZWrK/F7Zaw8DV4Yuo7+2DE+xqkN4Nk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErRC4R5DDkO7hbwEzrn73JiYf2GwB4Qg62vICI7mEzBx3ZDwwtCIWEuWi+EqdkhzB
	 499nmBrh86odaZnU1jvszo/KakR2qu4SubhKYGOAzr3/tckxvClcnJBW23dAVHO3is
	 /DWvkuJyfZm36HdLBlw+HjnxpmCtNVAjksrTMNo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/227] be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list
Date: Wed, 28 Jan 2026 16:23:00 +0100
Message-ID: <20260128145349.318503798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

[ Upstream commit 8215794403d264739cc676668087512950b2ff31 ]

When the parameter pmac_id_valid argument of be_cmd_get_mac_from_list() is
set to false, the driver may request the PMAC_ID from the firmware of the
network card, and this function will store that PMAC_ID at the provided
address pmac_id. This is the contract of this function.

However, there is a location within the driver where both
pmac_id_valid == false and pmac_id == NULL are being passed. This could
result in dereferencing a NULL pointer.

To resolve this issue, it is necessary to pass the address of a stub
variable to the function.

Fixes: 95046b927a54 ("be2net: refactor MAC-addr setup code")
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Link: https://patch.msgid.link/20260120113734.20193-1-a.vatoropin@crpt.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index bb5d2fa157365..8ed45bceb5379 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -3801,6 +3801,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 {
 	int status;
 	bool pmac_valid = false;
+	u32 pmac_id;
 
 	eth_zero_addr(mac);
 
@@ -3813,7 +3814,7 @@ int be_cmd_get_perm_mac(struct be_adapter *adapter, u8 *mac)
 						       adapter->if_handle, 0);
 	} else {
 		status = be_cmd_get_mac_from_list(adapter, mac, &pmac_valid,
-						  NULL, adapter->if_handle, 0);
+						  &pmac_id, adapter->if_handle, 0);
 	}
 
 	return status;
-- 
2.51.0



