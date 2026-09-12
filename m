Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072F41DA62E;
	Sat, 12 Sep 2026 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208976; cv=none; b=Or2ghRie36+7eFy4d6b+hu/fS3JxzvwpWxY0DLs3IcHyVXywY0bHxc5mxHdRJVw0aoSIa6dD/Fkya993/kQ6Yzw5sovO5Lrk+TjIPQuIOuk++AMR9ZrZY4kWHtOD2bNt32dw5nHqqzIBxqu1rNXG9OQzN4Ns8wYSk3ZCdKgpS6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208976; c=relaxed/simple;
	bh=6NJ50/KJNtLqIOrO4THWhKr0PdzLDe0ZEOK4LBuyvMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV18eXtE16w9vZ+T/kDPfroHKVoTDk8zZ6phGzslrgHTJpqL3MvkNXK5AjR7IVh1hVuYBk/fYuGl8I+YQvEEB1Rq+0uxeuioiQ1iOXDBVooC5c0nsWuDdaqvIzhDtwa7YVJ+Eiu+wj9iTj1O4O8WEVmzrUa9CMBCZ5V9ERp5NTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2f+H+Euf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2f+H+Euf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D172A1F000FF;
	Sat, 12 Sep 2026 10:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208974;
	bh=Zo5s9gKWsdhU7XeEeT0lLITTXDKMCMtJ8mpU9MMySYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2f+H+EufAblVajUv0vLKQN07bB3omqOsxK3CIChX48yINzQKQ2LFDBckhRgu628gp
	 hRxg8mekob9gGCe5W+/VcpmpjE3m61k5WRtYSnHvWsDrwliGvsnXGHT5bu2nC/RHsY
	 Nw25Y6VCr22hw73B/l2okAEmTzPbBgObXVjETozo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0726/1518] wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
Date: Sat, 12 Sep 2026 08:48:15 +0200
Message-ID: <20260912065639.857718457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 83488b2d6efb9..06f17da2c0106 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -848,7 +848,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	if (WARN_ON_ONCE(len > skb->len))
+	if (len > skb->len)
 		return -EINVAL;
 
 	if (pskb_trim(skb, len))
-- 
2.53.0



