Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1011AB8FD;
	Thu,  6 Jun 2024 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683275; cv=none; b=bPCqxruthW5MxpimRCpuSuVkQ3E/XVarkKubckStjHxy3MQxUUfQ3IsX+0+z7OhE69zCnzYL7XLk2sPW0NTNcBBQ9xkf/Ni7YWjlTfCCULJ8JqwuVRvpD+Rxil6zp4qGEct78kHXKwf9PHidRc3muZsk5uOm4TzEBJPp0L44qCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683275; c=relaxed/simple;
	bh=xEMtcv63j6RGvtYPau7ednT2Z+NR6txCXtlnvQdQE5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+QN0sSXKSRleoBNKl3AVcNTuI2ivmeH68M/P4fcnwLDi31TgZ3nNNjIxdi6lgsWGCEPN8O1+jwnimS3oQQK2Tmi6ME6mc7/qXS6g2FWcdsRtgMMlv+LONaJdwTAF/ai/1bMW4Lr9u65fTqF5pFygqnZliqUh5303XuIO0CFnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FC5CpK9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FC5CpK9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC3CC2BD10;
	Thu,  6 Jun 2024 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683274;
	bh=xEMtcv63j6RGvtYPau7ednT2Z+NR6txCXtlnvQdQE5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC5CpK9ae4E6pzRXP8vhea/lQtkjqwja8r2ODkMv/+W6+efoSVEgeGMlIR4adc1b5
	 jWWscu3l8s0H37wL2dgzK6KjswvSZ+iE1iHDX64xQKNh97hPA6IEo50ZeJxptJpYiL
	 93KOm8WIBnuIhpcv4XtKwGunvcwQg5Hz2+kvLiKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/744] wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset
Date: Thu,  6 Jun 2024 15:58:09 +0200
Message-ID: <20240606131739.353935179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



