Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCE0330B0C;
	Fri, 17 Oct 2025 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716204; cv=none; b=ho7YvHG4aOGC2Q3My+Q1AueHCCefk+9D/huk7Yejx2gKgdPZpVRm108OpmzuYc9QOuB5nqQXTK4db/SaPheKosOZt+k2Z37l2VynZNcQrmt3dob9LZQLVeEbQGBoXfj4bBRB4f8mI0llmL5jfEEYcdDoj95vMKBLp6Drjn2Qcms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716204; c=relaxed/simple;
	bh=3+3eM1R9muq+3ds8bM9BgkLzYWeg/fY70PMKM7yW5ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePLAvpr/vw55OyDAQ0wv1Yjg1daBnj/f+IbYOwL9mHI2V90oHGi9VOuUYkYf203gmRz537Bc7VNPfNs3l5ZVQ5xXaxxrR6Tn9ZzcXuYdZ0jIe4VGDsFICjs6x8nU0Ae4UXk9iJRNNQ/TLybJIuujaWfYu931YmOghWSK91LXNnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLdyoCih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLdyoCih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D77C4CEE7;
	Fri, 17 Oct 2025 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716204;
	bh=3+3eM1R9muq+3ds8bM9BgkLzYWeg/fY70PMKM7yW5ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLdyoCihMZSM0L7mIE2qhF/JsPpR+9bte/ePKNY4fsa4KEw17q6UAgYlR+BHzGQVS
	 /IjWWyzNrSWNhqhGx1TP/Chl+Jqsa8+xCTUOE9Okg5cc5GwxdapcrEMOokeuMkIgzG
	 ykeFzFj6yERGCr4mL+3emH2CgAOQfpdqHzsuj5lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/276] wifi: mt76: fix potential memory leak in mt76_wmac_probe()
Date: Fri, 17 Oct 2025 16:52:50 +0200
Message-ID: <20251017145145.298760274@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



