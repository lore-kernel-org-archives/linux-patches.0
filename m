Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4428B3101B9;
	Mon, 13 Oct 2025 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369753; cv=none; b=in54qveYe83+gE8bLyvtlxpZvaipidtnY3e8c6lEU/YbMEh4K5ekrWZ10SndBU9Hc2jykcIkbX1dIulekqSInuKTly76dObj4NQeez/eq6W9BeHqO9gcPy+FY8d/N+hFGQFSzh+4ShfdHhOBGMe4D3GdIFWWyMikt/P65sGkA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369753; c=relaxed/simple;
	bh=OK2xlydCewkHyPZRm7yRz7EMnYU4hWxAM91BbxhSvY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzT9DveFEMND3GY72WexhXVgb5r+VVPvsFdO0w/nu2OJaxb3eFUHkN9o3/IGLyOGk37A9MsVm5D++n7DuOFahc3haAoeTpkwhM2nAI1UtfiJBcm4JlbNqtrdHi9FSiJXonL+yoYZbLLy70QlVTb7w3Jx5DHGmaPg4LbPe04X3Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lxwuReT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lxwuReT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C15C116C6;
	Mon, 13 Oct 2025 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369752;
	bh=OK2xlydCewkHyPZRm7yRz7EMnYU4hWxAM91BbxhSvY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lxwuReT4YHSE7QtQKdCZZu7iuphBG1t+XvutYmoY4+H5B22No1+Zf0ycpHRnmPyo
	 ulC1guG9dsAcYRQtQGFC1o/64luITcRc0+YgC2l1sqYXJHAz6UgwClW0HvKfIe13e6
	 B+7Mbvrc5XS88RUnuorQmonHTR5Wz3FTw6ffwsAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 357/563] wifi: mt76: mt7996: Check phy before init msta_link in mt7996_mac_sta_add_links()
Date: Mon, 13 Oct 2025 16:43:38 +0200
Message-ID: <20251013144424.201522123@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fe5fffadc6c77c56f122cf1042dc830f59e904bf ]

In order to avoid a possible NULL pointer dereference in
mt7996_mac_sta_init_link routine, move the phy pointer check before
running mt7996_mac_sta_init_link() in mt7996_mac_sta_add_links routine.

Fixes: dd82a9e02c054 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250830-mt7996_mac_sta_add_links-fix-v1-1-4219fb8755ee@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 81391db535866..d01b5778da20e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1080,16 +1080,17 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			goto error_unlink;
 		}
 
-		err = mt7996_mac_sta_init_link(dev, link_conf, link_sta, link,
-					       link_id);
-		if (err)
-			goto error_unlink;
-
 		mphy = mt76_vif_link_phy(&link->mt76);
 		if (!mphy) {
 			err = -EINVAL;
 			goto error_unlink;
 		}
+
+		err = mt7996_mac_sta_init_link(dev, link_conf, link_sta, link,
+					       link_id);
+		if (err)
+			goto error_unlink;
+
 		mphy->num_sta++;
 	}
 
-- 
2.51.0



