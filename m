Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A752FE577;
	Mon, 13 Oct 2025 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367730; cv=none; b=fZcDwTGTSoFrHTTaeAOKm1QZcF4NhLju3wK28imwk8SdMjS43rxqm1Ja4VA+7iC+k9kK7wT3UM9rEz6fBAN8Rz5UNIE8G9NNuFr4BuUzfnZf7NdX6hy6rVFuvk9HH11YVJ9rrBag3XaieGrVvC89IBns6L7iqOeYLy5YeWL5xSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367730; c=relaxed/simple;
	bh=9JEWfKFIeT+o1ovoU5HfchG4YfKZv4J/rPgYEacNpvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4qT17YcSf/tQgoqlFLMQLTJDrWiQCl4+N67yLyRhzEvkTnVSPL7IFuWXJkc/ZVKOW30lyodKm8FvFFTFCQJPxGODVKu20m7qGfVexwHoLUutKSiGA6RytGuPpFDX7f8WqLJYyNyx5T/zMdl4BZsou4FPoZD/+sLVaQ21p8cack=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sD/vB8Tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sD/vB8Tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00118C4CEE7;
	Mon, 13 Oct 2025 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367730;
	bh=9JEWfKFIeT+o1ovoU5HfchG4YfKZv4J/rPgYEacNpvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD/vB8TffVKSonQMc2DVLImvGQ2K8kTYzvy6A5QuaCN6ZeWOALo5BuH9INCNLdMNw
	 cjdh3ClYvDxpPZ95lreAr9H2N4s5FylUyjzoJi7OhZXJps3ODwkkj7Hq5eVyMxIoGT
	 4d82B+MFK+6RQz5zax1qCEKecjniAYahNdlx9ewI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/196] wifi: mt76: fix potential memory leak in mt76_wmac_probe()
Date: Mon, 13 Oct 2025 16:45:05 +0200
Message-ID: <20251013144319.435253611@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



