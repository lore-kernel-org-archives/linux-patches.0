Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8D23815F8;
	Sat, 12 Sep 2026 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242871; cv=none; b=QLl2O85XvP+jBTE5Mcm3rM5PM0DZ05aF78k/bSEjDrKDpJld6BwgBL0WAKhUcjgfFn0FNkMMiSg4kpyKdX2tPQ8xuqlecT3APcWgeN0E8ECTpC/C+TyzkucVoPztp4AzCTwxwcToPxR+IWTeLsNXo0x/wdmaxmUHL6P8Z3g90v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242871; c=relaxed/simple;
	bh=TGIMK0+K3W3eCDE5uVb+t604XQanwkciNSoza0BTCfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apY3KSBDhrq3XrvJPtpNcII7WFgLtNiOKXjGmTgIQcJiCvDTiXX4LDrZy84HRcS/ahf2KAyljxZhBE+sq5U4bh+F9thCtqw5Xsio5ku3iJEyTiBa9MOIHnOIqKzxG7QookhjspLmdrd0J0F2NSNDTWzlhCWjMPhruzmkET7zO/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6MeDjR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6MeDjR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD821F000FF;
	Sat, 12 Sep 2026 19:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242870;
	bh=Yp0D7zHnnd0QDCTS8to6uuttp8KHX88Z2mqj29OAg9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6MeDjR2QTRdfkomR3C5+pZPSA1PaB8jU1ZuDcxRTMN4YYlWfEvZv+jKC16k9EMsO
	 WJ0vLwfGghegu0D9XybFSzSZ2GMacsUHCKLOskHQLslBs0xjNGsZih8DeCPxjHBUI6
	 gkKhdtrZ0oJsSSJ6dje4oSPx4jcsoFI1i1ruma7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 555/798] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Sat, 12 Sep 2026 09:03:03 +0200
Message-ID: <20260912065529.851128500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 677082d8659a6..e0e588d51adc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -846,7 +846,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	if (WARN_ON_ONCE(len > skb->len))
+	if (len > skb->len)
 		return -EINVAL;
 
 	pskb_trim(skb, len);
-- 
2.53.0



