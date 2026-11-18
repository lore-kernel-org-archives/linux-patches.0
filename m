Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049291;
	b=TWq93zPQB9L+JEPL9OMVEabHWsMc2Lk0BafS86Gq+/k772LvCDzz9TB1K0JqmzdvoK5C
	 v6GwVeoOvo7ukqdFrFvUzAK5xWviRgHCzBgw/FtzCdJwfbdlo90Yf4UZE7iAoch6B0HYu
	 aUjAFcOpb0OGGESxxX4Z3YFDEly1dWG6nSJhZ0Oy4U1ZKDxrbEAL1Tm3GP1MzzzVggKjr
	 2BVC11CalyePd+h7M+GkyeBqhoyZr6FUC+TI/87ymaal9XbRdgPuUgSS2ZdFsc5KWVLQ8
	 C5UQKQm+bUQ06eLPRIQa145GTv9TGEnsIXbQUdMa+CzjUSOM7PTbqiTAKgFG3+UonaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2e2hM5UJBGcebElZ1QJC/xm9RBXoininbr4ATkGyp8=;
	b=xg4yJqONN1AQZWoyiBxDHANlyPEQRveYsJepwOIJtPonLRnmCQUW1O67j3z4Nm+vr1uk
	 KkC7VoGO/Mimu5T7pSu3cKotGfeccTLjpL6JQ+Gs8gZ3RDgHpfEjAcxymi54HlFKVY/ra
	 Ee8p7fyJLr7puhawL60g0jpd5/MrqdRNDIYmyslRjsaYJ3SR6BJ/abhyWQjCC7wfe7QIv
	 xeDYo5v9oGQIrF5W/SgAgNB7mWAtEcUMsrVKQMeodKb9PtOF7DCdrcOs6PmXXHjgTd4V6
	 LxDSAbQSXCjl4Wv0tQou5CWyYWIjEWi8OvGk1MyMKUhz2RuhzjhniGFNBv0dCTO5aWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oiye/4aC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2082A60A2607;
	Thu, 19 Nov 2026 00:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiye/4aC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA4E1F000C4;
	Thu, 19 Nov 2026 00:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049291;
	bh=h2e2hM5UJBGcebElZ1QJC/xm9RBXoininbr4ATkGyp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiye/4aCrZ/ReNFQoynvbNRzmoiuv05bdHOK32wd/URmIt0inUTFPQ+jVjBJiSkNZ
	 AccZP4NPi3D8ColsGXPhbGrksk4Q7ibmtpHWQTYFKeHGg4U0a+n7gOiIWChgUlyPxW
	 NJjGrMJc+jD6OeSkoO7AU2Az1rx6Ht24gcFec7dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2299/2857] wifi: mt76: mt7915: check default EEPROM firmware size before copying
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150324.259793524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bce4aef211b3941af9ca297162406fc84f22ed5d ]

mt7915_eeprom_load_default() copied mt7915_eeprom_size() bytes from the
firmware blob after only checking that it was non-NULL. A truncated
default bin caused an out-of-bounds read past the firmware buffer into
the EEPROM image. Reject a blob smaller than the EEPROM size.

Fixes: beed8bea8d74 ("mt76: mt7915: add mt7916 calibrated data support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 8b43fb6418088..80f3eee344177 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -87,6 +87,12 @@ mt7915_eeprom_load_default(struct mt7915_dev *dev)
 		goto out;
 	}
 
+	if (fw->size < mt7915_eeprom_size(dev)) {
+		dev_err(dev->mt76.dev, "Invalid default bin size\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	memcpy(eeprom, fw->data, mt7915_eeprom_size(dev));
 	dev->flash_mode = true;
 
-- 
2.53.0



