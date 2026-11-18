Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020297;
	b=Ou9FWpdBNJK8o5+vqkzKk5Zn/NLzuo4KHzZi1QV+GZvptBggFd/jwa1iokHDnOat8+sS
	 RC1Yc+8o3FFZg5MqwpBmrs57DyY9kTM+T3zRXPM6Odf4r79oqJbuzJxKt4OH0jRntOqW3
	 nWgtP9lbEr4RYYE6+fnc258FIwQiVlTf4h5B5/SeuHx4SRGa7lgzAsYG6t34hlFtNYMsc
	 syqZWaFOHrAi2wb/4UrBIVW0y3cEtOUNqOpWl2aabnMjypSgANXfWVGwASSN0RZhYFSQC
	 Wrm7QOS9apaxYhNZoSJg6YoF3adaalVbuao6H8VonlM7+Ia81ZCgvR4I3phf+yEX3Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uE3jhTuTQuq2c3e99vqbD4geEeycfoQkRMHsFyv8fXA=;
	b=3xBgCB4SO/KUIFHTBx1zod5a+9BwnUIgXrtKUbgH3ht8N4rvoDkxDr+0KSKdtOYXTu5K
	 qL0S1vSWkbwBvZhlTwKFpMVcQiAJAcL1KCQd6wmQx/tTfuyUl8SkX8o3TAqKKLlwWvl6b
	 yR0H4/576VC45RTK/R6xUME3kDznDO5bcBOJE6xhoNwc3H00vR9+JccWrX80ThGLqMSIa
	 jQ/NhvggEc333JE0UPJter2ngkWgfdLtkinvE8nihTotVTYuak9xW/GcxXcDnswfMN+lJ
	 ti5NrNyGsJ2UxvMB6mWjtMfl/desXLpj+LHm48F6Laz7StMlyJzNBiDzMslEc5lyGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Na1d9OWI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C16606A31C;
	Wed, 18 Nov 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Na1d9OWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1BC1F000C4;
	Wed, 18 Nov 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020297;
	bh=uE3jhTuTQuq2c3e99vqbD4geEeycfoQkRMHsFyv8fXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Na1d9OWIXvsyh0cnDll0hA824LC8i8uhvuxujCsFqaMJxHOnlu1bWLSWj3X+hu6Qk
	 C7wJJJKt/l/8AuNalBTfROOOllTuyHkG3UD2+qxtcS6MzXG8z2/Ap350n4gefmivKk
	 iyRqQsRr3o7o1uSqNv/IKPhlZ/ikQASPjl0K5fIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1901/2651] Bluetooth: btmtk: fix skb double free on ISO padding failure
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150355.269784392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 54cfc83032fb4..56296d142187b 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1093,12 +1093,8 @@ static int btmtk_isopkt_pad(struct hci_dev *hdev, struct sk_buff *skb)
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



