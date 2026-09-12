Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69134475334;
	Sat, 12 Sep 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230442; cv=none; b=HAY6g/QtUoF+zo0cooYU9S6MXc7aQdkbCdOtRiHQGaQSmaTX63+tFnIeH6N4C5+J5b5VaMR0NklSLE/BiM2saY6c+VCFkCHiGG975FYr86imycJF5gjj0+7jzQ+UcP3mORtPEUOl74fXT5G9Y/k8ZV3uNIoM2Bz3t73Fc+5nSUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230442; c=relaxed/simple;
	bh=IitXPDowB6g+tp2iH4/uuNO733Zox0rrwOOdH4vsO3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8GYbkiwvRzg5yYa5G8V9iF69J+i7U624M7GrRl6+DU0dB7UtOxrxuPC+HhEKE9slvswPi0vTfrX7BWg+jgzJc0PHpMbCmEEfiNd6dvm6bIEYFL2qAQsJt49xEYjA0Ti4sqOJo27kPNs1c1NOd5Q5/whl0dOc7SVJy3jbu9v2LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpY6TGbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpY6TGbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B435D1F000FF;
	Sat, 12 Sep 2026 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230438;
	bh=1nUMI85UDP00rFMG92pyMa7uBa+Ut+4TcsPmE6gsIdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpY6TGbKlhYCp6ROia6uCHdLbkVWrWfATzT6OIxPKsVx6k0DwuVyDRRA6zCITNk+N
	 d/RNQSBI9TZi2AidKgpLPhNLmKRF+rLtFZa9cFy1GSfFMOy+M6a4q8v+1FJ3WCmhq2
	 MbACuHpT1KirkZ2t+EFJWM0fkIFRASWyUrjOCBnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0795/1191] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Sat, 12 Sep 2026 08:58:43 +0200
Message-ID: <20260912065606.129436573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 48ef2a5992675..b236f943949be 100644
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



