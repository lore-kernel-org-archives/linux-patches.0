Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF06D472544;
	Tue, 21 Jul 2026 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656772; cv=none; b=lTP0SFd0H5JARW5rQGWDSGTxsLJGbqA8yx80wsSu2oYB8oHhhR3mp63wv6BIxtDH/bUY3wUgNSrlqt1yuIP0iXz/UCxSOc9WsGtfuIKC3dNgMwRjqLH24qqw1/D9rpdY8kLQ/b+cYcU/sZxK/iZ3KLwPysuygeB3vPpS3TO57zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656772; c=relaxed/simple;
	bh=N4v11HA6OZugicNMqunJ4Wl2uLZUz29yFI47UM8OCag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoT0sNsQkd2hkOqLqRrL7IuNZ4EB9CIPGxQj5BDQSaV1kIka1/i5ASDpoTEBilN1UlMxT68IHbZhRZssKYGvS0DhYz9LqBR0StrH7V4kZzqVo9lcyYEY4CIsJA/3cIRP2jq5dMnZwbd3/JAvQsQzgU+3asQhfcnxpoJaIProwG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDNRtJT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDNRtJT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191621F000E9;
	Tue, 21 Jul 2026 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656771;
	bh=/Ty28rvliiCVpWl3qyZACpRIPmNoy823by/fnyyI0zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDNRtJT+EdsfDzh0pFwjKKOy2KNkv7GdtUvGMGNJt5+A8ALDzs/qFQuO+DeBLUCdj
	 ghxa1oIodEQ/RmP3c+kcL6CM6UxJsZUatyz6ypVS3ATWOjxY48+upg8mvE2Eo8gJSI
	 K1n3cV8s93gpQ4yj+fJ589enwApGFq+f0VMaDBBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0469/1611] Bluetooth: btmtk: fix URB leak in alloc_mtk_intr_urb error path
Date: Tue, 21 Jul 2026 17:09:45 +0200
Message-ID: <20260721152525.870532738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit f396f4005180928cd9e15e352a6512865d3bc908 ]

When btmtk_isopkt_pad() fails, the previously allocated URB is not freed,
leaking the urb structure. Add usb_free_urb() before returning the error.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 38ba8f2bd2f967..a908e7b46ecaf9 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1051,8 +1051,10 @@ struct urb *alloc_mtk_intr_urb(struct hci_dev *hdev, struct sk_buff *skb,
 	if (!urb)
 		return ERR_PTR(-ENOMEM);
 
-	if (btmtk_isopkt_pad(hdev, skb))
+	if (btmtk_isopkt_pad(hdev, skb)) {
+		usb_free_urb(urb);
 		return ERR_PTR(-EINVAL);
+	}
 
 	pipe = usb_sndintpipe(btmtk_data->udev,
 			      btmtk_data->isopkt_tx_ep->bEndpointAddress);
-- 
2.53.0



