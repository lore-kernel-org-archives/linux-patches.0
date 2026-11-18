Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041177;
	b=b+J4FBhSjeUnzkP2ki3TPMRTOl5+JcBP3ELfm1/8drXfo8qt//AYXojCuL3fjWAWEry5
	 hs0Qh5hVOolMKJ/PkzYU3FRVfcqM5QlBqm3H0vjRM9N4GO0+QBp9Mpiw7ggpR1Xfm8DSo
	 XS0WaEa52wjaCiKj0rmurOsW+CjKN1SsTTiRGwM+2+K8MwAhRYXOKz7Kr7AJibJ+82VA3
	 3C1e58i938DOVgOkcjMSiFBuPCwqD3+oBrmzbsXAJwGYYcmvZvyQJhZv6ggV8gTo0LVx3
	 lC2PRJjhYTHxRpYUueRhx93wjfzmXQuHRhwU89kTa6joHJI+xgaBanErgTgpE1Rqn2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NX1GhlElIW9MAl+/u0hVWQbiy+h4WB03PsmOxqUGKow=;
	b=Hie/nRu6gH4xD92+jayKuPS7hCdlEaBANuQzK8Yeo/9ms6m7TPDUR/B10TA2XXpaXHvA
	 PjaGiJ6saDldP19IxVEB80ADSHrn67qV2VEm4DKtYjardVYPEmyFneji9mvzZ2WNfRVTf
	 WB5A5CTE37U1jjfOzTUeSS+JubLin0uY3gowlXxiPq/n7YCLoiBYO6AB5aZUpW/rD9yyH
	 PH66wZn8oQw+y40RloNCng1qnetZARlsbVJTkTRDkiYF1mLdLhvb/34e5IjIivDeLJUa2
	 Xt9hTNn4k4aEN1z+6UQmcbf79nySqaky1+lKvHrC8ezq/uDZu8SSBvO1pLAbqkZPBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBoQrCCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA293606A325;
	Wed, 18 Nov 2026 22:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBoQrCCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262181F000C4;
	Wed, 18 Nov 2026 22:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041177;
	bh=NX1GhlElIW9MAl+/u0hVWQbiy+h4WB03PsmOxqUGKow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBoQrCCyQv09apZQfTFQxeQ2+EI1RaBb8lFpAbtB/CKHzsUuc8+b2wWtuP5gUSezx
	 oJ4bSdHpNRxDEtmzcFvrdNBSfgMDwaPCseRY/RRBuRqIdH+6iEmpqHE4Mt1cm2g1Gl
	 UD+feDgXjUZMJ1CzZZGBOAZOg30WRYKOFP9jb7UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2669/3318] wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150441.079310238@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 0c2fcb5225361f71905697ef9db287b24bcc67cf ]

mt7663u_copy() rounds up len to a multiple of four and uses the rounded
length as the bound for memcpy() from the source buffer. When the
caller's length is not four-byte aligned, the final copy reads up to
three bytes past the source buffer.

Keep the original length for the source copy and zero the remaining
bytes in the transmit buffer so that the hardware access width remains
four-byte aligned.

Fixes: 6cb596ba84e3 ("mt76: usb: introduce __mt76u_init utility routine")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925150556.2304003-3-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
index 04963b9f74983..07a86c668aad0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb.c
@@ -58,15 +58,22 @@ static void mt7663u_copy(struct mt76_dev *dev, u32 offset,
 			 const void *data, int len)
 {
 	struct mt76_usb *usb = &dev->usb;
-	int ret, i = 0, batch_len;
 	const u8 *val = data;
+	int len_aligned;
+	int batch_len;
+	int copy_len;
+	int ret;
+	int i = 0;
 
-	len = round_up(len, 4);
+	len_aligned = round_up(len, 4);
 
 	mutex_lock(&usb->usb_ctrl_mtx);
-	while (i < len) {
-		batch_len = min_t(int, usb->data_len, len - i);
-		memcpy(usb->data, val + i, batch_len);
+	while (i < len_aligned) {
+		batch_len = min_t(int, usb->data_len, len_aligned - i);
+		copy_len = min_t(int, batch_len, len - i);
+		memcpy(usb->data, val + i, copy_len);
+		if (copy_len < batch_len)
+			memset(usb->data + copy_len, 0, batch_len - copy_len);
 		ret = __mt76u_vendor_request(dev, MT_VEND_WRITE_EXT,
 					     USB_DIR_OUT | USB_TYPE_VENDOR,
 					     (offset + i) >> 16, offset + i,
-- 
2.53.0



