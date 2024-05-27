Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757D17727;
	Mon, 27 May 2024 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838220; cv=none; b=NM5R6hGVRyyD4LTLbFaKkihoBV7EqmbclSdM0JSHdP8KivCQ18IIg6IT6cu22d6cLc6pRvbIc5O/Pv2KkCBFAYwop8Nq60z68T7J1uT1ekjWiAAfr8VFxebHeAnffvMpOd6yQxZp0fCp2rTm4XYOUGCh2Ov190xC76s5VnXm1zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838220; c=relaxed/simple;
	bh=0dGTTdDRH54SL3sh59eKruyde5R1RDmn7zSyWY/vcEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUkAjJQNxZs8vJ1lE5g3dGj5WxepLLv00aBvInv779NGA9P2136pYSgjtE4UvbDrLpMKPRpC5iB26fxY8KL+YcSEi2fdwgEN7zkff7xJUNa7oWr7fiE/tvr5eIO76yYajYEkxLSMBFVteV7kgl3Chyq4FPbD52AOfn5I6aJ/Q7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiQvVpbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiQvVpbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340A4C2BBFC;
	Mon, 27 May 2024 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838220;
	bh=0dGTTdDRH54SL3sh59eKruyde5R1RDmn7zSyWY/vcEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiQvVpbJS1H69TlLG3E64imszwx6Wkqd3jjU4O5gth4BRyWbB3XMqETv5aEL9S4rO
	 HfeL7Z8DqcfO98XGUd3xOLBKh9ANEL8RC0N5av6yn7ZN2uTMDW5E5D7Yc30eJAxwgy
	 6c8/WDJEw2f/KQZ8JZzvVRFHQiht+2lHY4Kr0BfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 270/493] wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset
Date: Mon, 27 May 2024 20:54:32 +0200
Message-ID: <20240527185639.116032076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index cf21d06257e53..dc8a77f0a1cc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1393,6 +1393,7 @@ void mt7603_pse_client_reset(struct mt7603_dev *dev)
 		   MT_CLIENT_RESET_TX_R_E_2_S);
 
 	/* Start PSE client TX abort */
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_FORCE_TX_EOF);
 	mt76_set(dev, addr, MT_CLIENT_RESET_TX_R_E_1);
 	mt76_poll_msec(dev, addr, MT_CLIENT_RESET_TX_R_E_1_S,
 		       MT_CLIENT_RESET_TX_R_E_1_S, 500);
-- 
2.43.0



