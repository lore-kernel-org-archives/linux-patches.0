Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026751;
	b=IacNWEhSlqQVrC41VNi133sXrIAxZX6oY1oKovGMvLwoUmaB2zg5s31AthObY8y9YO2X
	 pyMkb+WaRJlykXWWIZ5TqTSv9AYYeoKzT3BT0iWmFcKAkWuSVlcPAO5Mvzciz7KlcW7LA
	 CR/Prv3vOKaHCkIr6pXy1xoPG69PL++MJ4xypmm0BtKyJNTL0f7nWdJRxLwhVozrl9JLP
	 C320ylaJmEnB5/7XpR8NUoC3KxAYR386L168xmuD0z3Spw6SO+LwdjFQRj6fzui8YjXfX
	 YGrYV6bccwDm/IhYFka8/xNPhyzuV6fBv/NvheM5V3KGqxnXShsHYasysMR0usOkxoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q0J27hviXFf/KuzliZ0s4GpKovymIKZ9H0Pb13RnkpE=;
	b=tG0XPn9bIYU6tMWW05lYKJ0poBIp2Tq6498k0eUHOhfQ2Iig1m4vCkbRfA7Xk2cvvSmI
	 6ps1waULT2THZPkOuYQUHbYlfRxC3ETVrYB5/pC0FsffBfvgf3WD3KAMo8j/sFJABbDsQ
	 2xVlvjLB+w3CR04kpQygBYYZWhw+NCROp+PQItqgrTZZKRwKc0RNwUv7TKsStqBtzn3La
	 UUyPFDUMd8ImsW7P35q5AtZhJjam6IfeuvZFSTa1xNQjf/P6aPeQlZ04AB8mfPDo414+S
	 T8ImmqjgWnuIYnYPX22Vh+S9NkvA0dinbOkgOG2+YNvuf+9u5OVav7EPEflDIdexN9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5a8L1IT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7856606A31C;
	Wed, 18 Nov 2026 18:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5a8L1IT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490061F000C4;
	Wed, 18 Nov 2026 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026750;
	bh=q0J27hviXFf/KuzliZ0s4GpKovymIKZ9H0Pb13RnkpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5a8L1IT8NY4Q1gZoeXL5JNid3b9dMA9T9x0WoVu5Wo4yLylX35K/LO3QRWdmEoXN
	 qDJtz7KLdQtQrQ0dWOqauoJ/h44FBlf+C4YVb0G1Me68Isd31rkmWgNFQUxV/KWLFG
	 WsoCJc0mM6Ewxhk2BfbR9sb9QXKmeJqjo4AGWbx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1545/2151] Bluetooth: btmtk: fix skb double free on ISO padding failure
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150218.182991004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 491d2212ea0f0f6a3abbd67729df0c6a3ec9c58a ]

btmtk_isopkt_pad() uses skb_pad(), which frees the skb on failure.

The error is propagated by alloc_mtk_intr_urb() and
btusb_send_frame_mtk() up to hci_send_frame(), which frees
the skb a second time:

	err = hdev->send(hdev, skb);
	if (err < 0) {
		bt_dev_err(hdev, "sending frame failed (%d)", err);
		kfree_skb(skb);
		return err;
	}

Use __skb_put_padto(skb, MTK_ISO_THRESHOLD, false) so that the skb
is left to the caller on error. This also replaces the open-coded
skb_pad() + __skb_put() sequence.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 61a6f33ba658d..961a47a9c8c43 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1081,12 +1081,8 @@ static int btmtk_isopkt_pad(struct hci_dev *hdev, struct sk_buff *skb)
 	if (skb->len > MTK_ISO_THRESHOLD)
 		return -EINVAL;
 
-	if (skb_pad(skb, MTK_ISO_THRESHOLD - skb->len))
-		return -ENOMEM;
-
-	__skb_put(skb, MTK_ISO_THRESHOLD - skb->len);
-
-	return 0;
+	/* On error, the skb is freed by hci_send_frame(). */
+	return __skb_put_padto(skb, MTK_ISO_THRESHOLD, false);
 }
 
 static int __set_mtk_intr_interface(struct hci_dev *hdev)
-- 
2.53.0



