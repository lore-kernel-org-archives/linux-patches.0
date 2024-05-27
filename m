Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D2217E90E;
	Mon, 27 May 2024 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836827; cv=none; b=kJhuB539fmD8qfM+F5IFn4EsL5cPSv/ApdENSVkg+lk8Rcvt4rbhKJLTQL9+KTOXfH+/jEdm20yvkOetdCbGLmYxFgqc0+oqcoBwi9CpZtSU0LdQZ8FQ+t9PFd4zmX6nxKHdqNWyzNYoSu2m54Jda+72nGgHr2pSdAo1q63JIoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836827; c=relaxed/simple;
	bh=pVhw/oRHD/tx3fBJyOkMx/PPTWPX0ZwA4pKMK+rIlqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGGpX6F9EjkVEXB2CEsmJPvjKnr87N8ZlX1mHbqmj6D7nwhhFGl5ClPF79FspBxQ5bSL04UbtuCiBT1GTO4SxaOWIei6SYTapAU1WHZjyd5+hDijaIXxqSReY0xKwjnRxvQl6xBuf8A9oQaATUopShIvgLtuKZFDwTVzd0jiALs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlvy86j6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlvy86j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF59C2BBFC;
	Mon, 27 May 2024 19:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836827;
	bh=pVhw/oRHD/tx3fBJyOkMx/PPTWPX0ZwA4pKMK+rIlqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlvy86j6sBBr/4yYB0dM0j/exaGLKVsjmTGL60JDHDR48GJahPV9yIDm4T5hHvTT+
	 p9L9ZAXOKS0Yjkj+fyxzpX6dEbpsvqqflgllberLdD7t/8WiyCnu15HH5rFcqdvGHA
	 QWWijGA/hsOPHuRc5/MTeqk0OyM7Rkx3lH+Rl+Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 203/427] wifi: mt76: mt7996: fix potential memory leakage when reading chip temperature
Date: Mon, 27 May 2024 20:54:10 +0200
Message-ID: <20240527185621.268256377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 474b9412f33be87076b40a49756662594598a85e ]

Without this commit, reading chip temperature will cause memory leakage.

Fixes: 6879b2e94172 ("wifi: mt76: mt7996: add thermal sensor device support")
Reported-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cfb5a7d348eb8..e86c05d0eecc9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3729,6 +3729,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy)
 	} __packed * res;
 	struct sk_buff *skb;
 	int ret;
+	u32 temp;
 
 	ret = mt76_mcu_send_and_get_msg(&phy->dev->mt76, MCU_WM_UNI_CMD(THERMAL),
 					&req, sizeof(req), true, &skb);
@@ -3736,8 +3737,10 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy)
 		return ret;
 
 	res = (void *)skb->data;
+	temp = le32_to_cpu(res->temperature);
+	dev_kfree_skb(skb);
 
-	return le32_to_cpu(res->temperature);
+	return temp;
 }
 
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state)
-- 
2.43.0



