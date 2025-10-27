Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A512D6401;
	Mon, 27 Oct 2025 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591089; cv=none; b=rwJfGFTlmS5ydNoudPQz2Cn9kmIJzdNCJ/9LbwMLfbMBMHVJlUsdkf1lDgYnJEXt9QrdTF9hQOaIoSfiBseRwK7c/tNDCXvJxf2faT9lVRff7kM83c6AwJK013F59PS4tPE21PfFeX4z+63Mx2NDdpNIzTaYu9X1z2bGFthMYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591089; c=relaxed/simple;
	bh=fzGQF3Ms0qzIlN7WbwcfXgugvRCLsPzeRqV5yaIcp1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsbUF6HpPoWW7cnolslTtcY+bWBD0Imc4me1tnr9DKvDbU05Tx6r6QmPKCt6vop/sHLU4Qj3eyaPtga9LufZj16+gVb9ENRTSZxAAi0608z5BHq8wVxgoWTaPY9lZ+KWrvlyCyM46akNW654zQevR+iB1ThoVlyLO+8/o+AMbTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+HV1tBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+HV1tBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D2DC4CEF1;
	Mon, 27 Oct 2025 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591088;
	bh=fzGQF3Ms0qzIlN7WbwcfXgugvRCLsPzeRqV5yaIcp1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+HV1tBHTQqDnYWkI5nvqWoVJiOHHpNW04eDNmpvXWOCH5KlkP3GMNbj0LEgwOXVu
	 rNWH29gCl/C0ubp61csXiESYDemfNQoekYZwUsfyv+warW0Dlj5od5o6c/as5HWLBY
	 UIV0cj7268YxSW285KtZs/k+wD+203f5u8vSd81E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/332] wifi: mt76: fix potential memory leak in mt76_wmac_probe()
Date: Mon, 27 Oct 2025 19:31:55 +0100
Message-ID: <20251027183526.256879802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 42754b7de2b1a2cf116c5e3f1e8e78392f4ed700 ]

In mt76_wmac_probe(), when the mt76_alloc_device() call succeeds, memory
is allocated for both struct ieee80211_hw and a workqueue. However, on
the error path, the workqueue is not freed. Fix that by calling
mt76_free_device() on the error path.

Fixes: c8846e101502 ("mt76: add driver for MT7603E and MT7628/7688")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20250709145532.41246-1-abdun.nihaal@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index ba927033bbe8c..1206769cdc7fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -48,7 +48,7 @@ mt76_wmac_probe(struct platform_device *pdev)
 
 	return 0;
 error:
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(mdev);
 	return ret;
 }
 
-- 
2.51.0



