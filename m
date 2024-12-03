Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA381F756E;
	Tue,  3 Dec 2024 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238711; cv=none; b=DEUmKVJar3UaKHyY+h7F4MNmcwjT//e/kaF9SEGkpsfEqpL5e29iVoTlYI74CKDPQebeumgI68ogKPF9/tVn8wQcwPj0Q0r8JaAkqjNlzlVhHZUjsqtrbn0v4LYg/6XM5WijFuEEWg1qSgEoMtesJJjKLC4jHgrwDbiGO9x0f5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238711; c=relaxed/simple;
	bh=wiT4tEs9M5Bvfs3jfcPbfIwTVDwbq38f5BNOBKDc7GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVs4+fChHR0ZpW99o5wBSxK4qr4t8PXB2CfaQsnlD8CST2vrF5xfJr/BRTRk/C9VoIFet3ldzxUxAXwkCgWdOjnNu987f3E/GwGHRX+S0PAHmXzOxfogdHXMG+ERZ89n74RQM1C4MtZZnkg8Md2+82RY3mb8r5ObhlpPG8fDC5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoDiw4tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoDiw4tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36538C4CECF;
	Tue,  3 Dec 2024 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238710;
	bh=wiT4tEs9M5Bvfs3jfcPbfIwTVDwbq38f5BNOBKDc7GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoDiw4tbegngi57d+QjJDA/eOGbxhO93DkEtOPjucUuXL2ktNYiU9exyTJikSNUjt
	 avlmoDJMqEOahqQOypcF6+Kg5jtrbK/FgjSFjuPEjJo17VwNhWyIfopqdtHNxy1B8p
	 Nia2r5fgA49/O0Z4oChBhIXNoBSnHMoqRGmjWDN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 370/817] net: txgbe: fix null pointer to pcs
Date: Tue,  3 Dec 2024 15:39:02 +0100
Message-ID: <20241203144010.283781512@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 2160428bcb20f2f70a72ee84aba91a1264dc4ff3 ]

For 1000BASE-X or SGMII interface mode, the PCS also need to be selected.
Only return null pointer when there is a copper NIC with external PHY.

Fixes: 02b2a6f91b90 ("net: txgbe: support copper NIC with external PHY")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20241115073508.1130046-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 119cbd3466011..6544910535898 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -162,7 +162,7 @@ static struct phylink_pcs *txgbe_phylink_mac_select(struct phylink_config *confi
 	struct wx *wx = phylink_to_wx(config);
 	struct txgbe *txgbe = wx->priv;
 
-	if (interface == PHY_INTERFACE_MODE_10GBASER)
+	if (wx->media_type != sp_media_copper)
 		return &txgbe->xpcs->pcs;
 
 	return NULL;
-- 
2.43.0



