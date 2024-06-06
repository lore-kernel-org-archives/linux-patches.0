Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AECB196DA5;
	Thu,  6 Jun 2024 14:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683272; cv=none; b=t0rGav1roael9rgmGh6C8wk3bRPdaGdDRuX6jjKJGqUpGcatmu68XWkwlP+odvf+MLCW8+0BvEIvPQAW6euR7A/ny1hZYRQcX6aWZ4CNe/ASkNetlhWa9MO2MrLGizEemoDnjw0Rb+EiRFacN2jY8egWtjYppD/aIgJ6gP+Vhhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683272; c=relaxed/simple;
	bh=kqk8tVBk5mjC6O6/uWPlDmELs9VGZQaBeSWy3mdADc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoC3f+HbuFItjhiAj1lWgamM1aYw4NJp5ECo24r+8jOJpC2GRiFJ8XQ0xc7Fb2d7qToozQaCgwHVjUbPj1ViNuSbVpbFx/HL6O5UVLXFq+F+bLkWNaqLb3h3FYLsxmlyQXXQ20oagZ2S/+F4k5XZe+Rw5z+spsKyxpOEydnibB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXc6ELK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXc6ELK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCBBC2BD10;
	Thu,  6 Jun 2024 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683272;
	bh=kqk8tVBk5mjC6O6/uWPlDmELs9VGZQaBeSWy3mdADc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXc6ELK6InwazmOqzJWk3MYiXA5w7vK6y8BJO7mk37/YS9+bj2l2PeYwfOa7ZAHVK
	 6xNHga2uDwwGxt7p2Bri/MmTTV4LPDer94XQeNCih6Z/doUxAFDRrCSiYq+YhnjZcf
	 S3R/LcLRnaW9jLwltnyndr9fsiB0lnybb9TK26PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/473] wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset
Date: Thu,  6 Jun 2024 16:01:19 +0200
Message-ID: <20240606131704.913504454@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 21de5f72260b4246e2415bc900c18139bc52ea80 ]

This flag is needed for the PSE client reset. Fixes watchdog reset issues.

Fixes: c677dda16523 ("wifi: mt76: mt7603: improve watchdog reset reliablity")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 2980e1234d13f..082ac1afc515a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1382,6 +1382,7 @@ void mt7603_pse_client_reset(struct mt7603_dev *dev)
 		   MT_CLIENT_RESET_TX_R_E_2_S);
 
 	/* Start PSE client TX abort */
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_FORCE_TX_EOF);
 	mt76_set(dev, addr, MT_CLIENT_RESET_TX_R_E_1);
 	mt76_poll_msec(dev, addr, MT_CLIENT_RESET_TX_R_E_1_S,
 		       MT_CLIENT_RESET_TX_R_E_1_S, 500);
-- 
2.43.0



