Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D9D38888C;
	Sat, 12 Sep 2026 14:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224315; cv=none; b=UbtfyBGFXxmFztTFtt5+dYA4pJpaIWE9ktVg6+fgJ6uZToT2Zn3lZ3VXL9chMDZLGRoOk9Nmou+U2pGLa2SImUaoCq8eqph+3SKLZTL5Dm7P5ebHAbV2PtOXUr6M9Hu8BmcHBbgJOdeqynti20hGgyFhe7tJeAkva3s/LgDuR0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224315; c=relaxed/simple;
	bh=qpjUcbhR7epTdgTSANZWqHj2Q830+yEve8lE8l+r4a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYKndTKJkx5nSBNsGqky0GVDCJ56puLgSaVFLBvHXN9sPfihuuwY8kHkvTj8A2tser6KsLv8qlzZhJYb5RNqBFxoCbX/HlU7j7IrBpoV9QVIXt5aIb5f1qc6CDlcUCm0EJI6WBM09t4lZAz/DUK6FQtgoWdvOFvaCXyBmvj2nT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ev1TfGoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ev1TfGoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582FC1F000FF;
	Sat, 12 Sep 2026 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224314;
	bh=mi1xVntzpY2sG0gYGY0gsCLYx3ppNKXJh2N3BgzmeE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ev1TfGoOKVwL94popP4EsZaxfWUgwuRz/kn6ELID/SNB51QrOSMmAVvT2tQntdxPu
	 Nt2iNBIkhr51qqHJ4oZRfdAfOnsxcTuJkMd5qe9WhkJGrX2NEvt/GIhqhnK1iqvAx5
	 U6bjyyD4wCwAw9kxmW6b5igBRgI2vJ9mIK9re5RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0969/1424] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065629.012330003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 81497634d9f872fd3e8b03aada55574afff6f174 ]

The MPDU length in the rx descriptor comes from the hardware. In
monitor mode with the fcsfail filter enabled, the hardware passes up
corrupted frames, and a corrupted frame can report a length larger
than the received buffer. The bounds check correctly discards such
frames, but its WARN_ON_ONCE wrapper means any over-the-air garbage
frame taints the kernel, and panics it on the first such frame when
panic_on_warn is set.

Drop the WARN and discard the frame silently, matching what
commit c2d4c8723dbf ("mt76x2: remove some harmless WARN_ONs in tx
status and rx path") did for the neighboring rx and tx status paths.

Observed immediately on rx with an MT7612U in fcsfail monitor mode
on a busy channel.

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260613002544.27750-2-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index d5db6ffd6d365..338f5b46c6511 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -850,7 +850,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	if (WARN_ON_ONCE(len > skb->len))
+	if (len > skb->len)
 		return -EINVAL;
 
 	if (pskb_trim(skb, len))
-- 
2.53.0



