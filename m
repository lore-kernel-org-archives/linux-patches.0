Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041031;
	b=PSjH5O+2je6Od/QKYH6uWdrNNnECS330pzOU6zF+ANsH4SGJbFcNZLdmfayBoZNHxy4L
	 AAhyglWDpefiLidheSjjug81/E21DrnSrAt+aYcjtZpap94D4C5U9PwaGUE7ZpQEg6rtp
	 7w+/dtUw3QgXjKDDXaN/UTHKZNdcpUQorfJanjQxqvTsrB231FoR2d1M+MPg2h4FDIv93
	 gHtpgvGJ2lbJQhoFzMKUmFJ8/q1D3e9NpRc8CCnhjEVkY1fZwS1cODItn5sLZW/FXIBUb
	 ZvHPRLsbg4yj7cHoXU3/eyoNvtDOjHgyFvZHNsqoOTzc+j/hHiaFLOdD3crRou3xJjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jiv/3+WIkAHKKKbx2jXt0bJbtorYYPIEvUTOdx12zG4=;
	b=mauULGT4zCLol/kkAtWhobqBx6Iqnohu73+qg1dGroZGjbnlcnIUIGN8/h1qodLOSo2W
	 Nnxv+aVIaYnLUZvBaTWqe3NIIvInxgC/mC4VkVtpuMGVEh+P5vbKV4UbiQ0ybQC/K7LvN
	 n1dBEpnAAYNbK+7iJu4dIAAjygnufBnQhabli6g2y07xYqNRzOee+4MTw2MOmHARSNrwX
	 GyI+EicW9K2fOLJzFRfGI7GISWEVflqSoNXeTm6B1GM8heKKBnEH+YB/0RGUfGwD6DsAC
	 IUDODGjzTUGVagfoeX2EttGZ9zKdrw6PCz2czxs16QHI86JFQXJwIY+8+5SR+1MAfHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WP7gpjg2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E55606A325;
	Wed, 18 Nov 2026 22:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WP7gpjg2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480651F000C4;
	Wed, 18 Nov 2026 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041030;
	bh=jiv/3+WIkAHKKKbx2jXt0bJbtorYYPIEvUTOdx12zG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WP7gpjg2K9l8+wCzC0tLy4ZHBxI375dN1o0h/qQpAmYFvkm0k3J3lVzbAeY6DK3wp
	 kmM42PcIXY1t9NwaYnO0xIRYVxDiusjZCfKW4xYylpTllkzZ1/HLcf6iNtpx2aDTo+
	 dBY7/226Td53bU2fRjj3IjvPXkeF+hrzF38+llQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2666/3318] wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150440.995694416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 5cebbd7a87df834efe002c8e54211e6adc99703a ]

mt76_reset_device() tears down each wcid's pktid idr before clearing
dev->wcid[i], which is the reverse of the ordering used on the
sta removal path. Until the pointer is cleared, a concurrent lookup
under status_lock can still find the wcid and access its
already destroyed idr.

Clear dev->wcid[i] before calling mt76_wcid_cleanup(), reproducing
the ordering mac80211 already enforces for normal sta removal (where
mt76_sta_pre_rcu_remove() clears dev->wcid[idx] before
mt76_wcid_cleanup() runs via the .sta_state callback).

Fixes: 065c79df595a ("wifi: mt76: mt7915: fix list corruption after hardware restart")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-wcid-null-before-cleanup-v1-1-0e364d9062d6@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 379eecd09d0f0..2d99b1c382bd0 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -784,8 +784,8 @@ void mt76_reset_device(struct mt76_dev *dev)
 			continue;
 
 		wcid->sta = 0;
-		mt76_wcid_cleanup(dev, wcid);
 		rcu_assign_pointer(dev->wcid[i], NULL);
+		mt76_wcid_cleanup(dev, wcid);
 	}
 	rcu_read_unlock();
 
-- 
2.53.0



