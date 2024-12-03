Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B251DAC9F;
	Tue,  3 Dec 2024 15:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241196; cv=none; b=JNdAc1PoqeRkmQJgZZTC8ZaIIU29VmbhZnme8s5TNtGCCZ8y3GA9WYsskjMV8dPPcsGOBfHpa/AJiyz93UVXXQv3RSFYQohnJVs9x+18HXE7G6B8lgjMxvd0d/MTY1SPIdBQ/5JeS/Sy5Bq95aGJQ3xsEOQuPBq3vEIPXdM7HCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241196; c=relaxed/simple;
	bh=0xvYV7KDaX9ZJpG216ZcZ50MwlBJTyaKnyCIR3r8g+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ie267ue590gWjU6wN/IxS+16yhaUXDrUuLys3aa306X+sNkF8VhFZjrnSUhSLSp+AkG86piTG7X8jL0CJWz761DDs20n2WcznU4YARvWgNmEiuak4C2mPD7qzkgfaeAWKHDztpDkSCRxoTNwaCysrI1a8YBViqjmpc6it3OmQLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFnVNPmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFnVNPmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BF0C4CECF;
	Tue,  3 Dec 2024 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241195;
	bh=0xvYV7KDaX9ZJpG216ZcZ50MwlBJTyaKnyCIR3r8g+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFnVNPmMcdcpfC6S5PlU0yfbYhNTd3kj5k1ldu1AOgzs6Kh7P5plhtgM4qXcNAB+c
	 KUt2RNawC1xGBvVidPciwbzqbbkYa4vdPDXEWFNjcNrvdoXFK5mLxTZPpojTVwDAS5
	 q7j0YOE9DBf5cRw6bgX2GAWm76r8x+5YRg+k5kZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/826] net: txgbe: fix null pointer to pcs
Date: Tue,  3 Dec 2024 15:41:20 +0100
Message-ID: <20241203144757.531264576@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2bfe41339c1cd..f26946198a2fb 100644
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



