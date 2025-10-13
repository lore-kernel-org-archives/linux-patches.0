Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AE631AF16;
	Mon, 13 Oct 2025 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369747; cv=none; b=Y9neeV6+D56TPlWz8g4SCjvrffcB/sEDqupo108Q3OFvUh830Yt6yHrCpYMKMWP1bopB6vVe7nz5tQlxqk6IOrdTFRrpPJ2IoHsL/y04IBkfenX8g7bJEYu6Me5gs3EzKCDD5m7jANsj+KnhSEI1/wnC2hw93kslICNU3Du37Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369747; c=relaxed/simple;
	bh=TY/zMOBg6NlhFlQ2cTvwkGXqrmaEnqAShvKuRxAZHUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKTBjpPWWGyIKkd2B3dNZ2JaeHLRvr+0ZUWCkaTzMv6t291vhjcJBeYyg0Qh0M8KbVrvy9btmCVznpoiswlTYR80UXKwYn5v7idbqj3R9Zf6gwOwpFv9Ywpj9R5Uwih3CH16LK1LUptAUVkOBCiweJrEo3DiI4t/xBzgydqgFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVvQy98G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVvQy98G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFA0C2BCFB;
	Mon, 13 Oct 2025 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369746;
	bh=TY/zMOBg6NlhFlQ2cTvwkGXqrmaEnqAShvKuRxAZHUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVvQy98GrUy6TG8M7p3KbgngPkZvzB2wWRfpSgh9wAWcdxR8QBmFbquflbPIRb8rK
	 yTcblbrcYJd+38JsjA91R21ag2hft+FtYArTuvE7GdHK4q04LZkZ0M9dhSiIWaSsw/
	 onvtG4fSTe9fFz9xlLkZTn5SeD+zc+yXpXg460Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 355/563] wifi: mt76: fix potential memory leak in mt76_wmac_probe()
Date: Mon, 13 Oct 2025 16:43:36 +0200
Message-ID: <20251013144424.129712060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 08590aa68356f..1dd3723720480 100644
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



