Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D982B3A6F0B;
	Sat, 12 Sep 2026 18:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239343; cv=none; b=Cc/Ne4g8hNONWGVC9bSYCxf3OvpZAuZdkO6KxhRp4JYdd2te729sVSp1S2Qm8n4UlIrEXp3CDwHPh3nnwoBS+kcSjvAMsiM4RKvMm+INyrH+C+wxls0jTnaFmhf0v3SFm02LyaLKMjd4j3lrO0AsbtsHLAn9n/BQhD9Vn43yar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239343; c=relaxed/simple;
	bh=AoRFLGse+JNd50j/a2wsQ1DtNOB0sNzvcWewmw3q2Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTH+ohjikP+/7cypGYwRflG5v6BTj6V4LBPmtiU3MWjCyIQxW17I+EjogQOFltzRDZhX/rq+/iI0n9qb+ylWCuvLhnqAzLXlVGzKQEo+jOZ52TNUXcMDvjF91G88hy+4/8xyvjrP0r4KVXGiZStHNdldFziH/0Xd5k57pyb7bZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2BLmkT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2BLmkT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2FE1F00893;
	Sat, 12 Sep 2026 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239341;
	bh=6Qhh4oe3ia9q6LdWvuV7tf2hIeAVouRFi2brrPyjJbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2BLmkT9d2d0TqvwI4sKMOulZV69Z9xeAB2uTnRlf3DE/18Zr7/7PtSPx8AfIVzYw
	 FbpUg/AvbssYeAFZduX9JgkjYFD5o5+8hl/LWZGDa114k31PSrikahriP2YRk4HJic
	 QhQxg0LysyfqlVj+m3qvvlxPDpR2j++bSF7FCe2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 646/935] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065541.659384680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index eacc5d39d5834..d29d695a433d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -850,7 +850,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	if (WARN_ON_ONCE(len > skb->len))
+	if (len > skb->len)
 		return -EINVAL;
 
 	pskb_trim(skb, len);
-- 
2.53.0



