Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031993;
	b=4wPpGkI71YXKdx9Vpjm1Lc0rzLaOR7ZXF6yNUvkKuJtogsxDgi8w7JdhST3tdXu49QzW
	 9tXd8jVLVVgNnKMmEmjGuW8KfxB00KTlIIQfrHuafYNib39JWEFj6W/CAPB6kzDIORQB9
	 sylstONaGhixsfXn2lqb0PS0H2VM1PStsS6OEG2pUdUVRK4DBldINO1c+d2TfwIxAqLMY
	 C4bzpOr/51jiECTjC4a3u+3TWWUAHQ7vphZtnewqpsZEs+u8AEEv0WjlKOV/w82DOJFjo
	 jqfbH9tTRIJU2DUsrLY2n9eAXape310WM4p4315W1SKqqeZp1Qth28IbzRRpRjo23tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tcH5ZipNcQ6UrEK5sKTr9wUIUTgBHLDfVJxKwukMO6g=;
	b=3MihvEF7qukPP4ZKLLZi69lFiFqCqczJmK119ryV9cy2DivljcVXZVj6T8VDtPKOrFfC
	 3TSro7TpAZ0PVRf+66WVSopEcI4pO9j2JmvlGMOcB8X0kg6yfN10w3va3VK8AtJy0gcXC
	 vIubsoj2ysMjWs8IdMumw0J6pYWAYOoGxEAnPPyKEhTmYnxRW1jifpJNa0Pn+EpybR6Ju
	 r2CsaE5IsszrwhUREENRSDGTIjNa2RcSxS2zmi1NpWKtFdMJFr9yHxKnGwmfBrVTfIiS1
	 HeyuzjzAo5AgwN9rT1GJTniqChvR3fQOXhd2J/Qz2ISemyFy9X6J465ZTpiLZl7M48A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5gklIqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5966606A320;
	Wed, 18 Nov 2026 19:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5gklIqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9A51F000C4;
	Wed, 18 Nov 2026 19:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031992;
	bh=tcH5ZipNcQ6UrEK5sKTr9wUIUTgBHLDfVJxKwukMO6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5gklIqTDXR3sst4ZZ/PryRddX+W5QXNxtyU/3WG/OxvIJwVvYhSiohgS5BF6i9Kf
	 wfmbiIdxai7Eo7QVt4hCj0DXvghOHz6BM4Ic3FmfgbHxW0GDMxHnqF2JwJz9WHgarq
	 ItDR7q4mfRwGyHkqdwfc9RUz8t8/2HWTpa2bLEaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1237/1756] Bluetooth: btmtk: fix skb double free on ISO padding failure
Date: Wed, 18 Nov 2026 15:56:04 +0100
Message-ID: <20261118150059.014630337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d7e26ca8a0364..0444804a472cf 100644
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



