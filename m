Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052084;
	b=rSCqGsh8fvPv2a3sCok0WUfTR6teUZ0AaY5MxVYhT+v+Bx7VZ0CqX/++ADu3AxqAn5+A
	 o4OBMluwLx72tXhU90TJSoHelPLgRiu3bUR2cT+CD0IiaXr1k7DWZjUPNWLLKXBG0uq/Q
	 uW7K6N/sOGKMmwqKyIDmpeEAAQWjTTe4LlqP/gQ85p/nj+7urvBK6QhFfPOwXm0/imnBa
	 Iiq+zWN3rr4SUXDcQl7GLPN82NKSBjjJ/L8nIGOKhCpqOJFlgogUKreSF0YaTA/buQusk
	 9ePbWsRDPgYQ0OQOoQ4mL7AbW2Xh5FrbNY52OlB/ER56fflhcrCiLXT1rBBa6BYPg1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hi+378mRizH98TD/eqmPrQr3d+eTnxip9SmDZ6hLHTY=;
	b=K1Gk7nyM6EWTquBkcKFB2jWIBHAt9p4UI1OJy+KQYSBHFZaEDI4v1KPcu9+YTc15F0mN
	 llDmxtsWAiIzF2CIU94VJ4J4jqQy7eVMqcMV0UMR6u7OLKhIUndvnfx/qn3pDVaFf9Ld0
	 9lpUAS8ckhJluBPaih/VngX4ArP0XIx0RtXUrbhcFO4cfBBPvpzyfqNuOqxvLOQKbks0J
	 nric/4FlGfnkPgiD4NbImbY4R01OUfIewjgPjic7KMhTznp/qaV5TOCm8XkDzsshFg8CY
	 CKGDGWQod0N0vbRg6i6yE8YEGGlgMoJLXHSiwygk9MRnXz41mbNgY7twv7SxCVONlIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeETvNee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C2606A31C;
	Thu, 19 Nov 2026 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeETvNee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5419B1F000C4;
	Thu, 19 Nov 2026 01:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052083;
	bh=Hi+378mRizH98TD/eqmPrQr3d+eTnxip9SmDZ6hLHTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeETvNeeyuNSjGs8m7vTnKIuURc/jiuO9LjNf/xmKPyWqlNHa0zC9AUWVJ5HPArdq
	 X9Kf+Mhepv5cMsopduDOzOJkIfl/oUIL83lpAWrbNFOma528zap6wZ+wpTcaqMwMJr
	 CXtC43ABuhCocFcrOzZTxByw5dgezLE+nTRUeV3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0438/2214] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118150028.603366729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit cd49f62f4161c7340d9c9f53b67757575900c0bc ]

The length and offset is provided by the usb device, so it should be
validated.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 42781332679b0..52b85a1898bfa 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -358,8 +358,24 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	/* process each rr3 encoded byte into an int */
 	sig_size = be16_to_cpu(rr3->irdata.sig_size);
+
+	/*
+	 * Note we are not checking if we are reading beyond the end of the
+	 * packet which was sent, and reading stale data. If the device
+	 * sends a packet which is short then we get garbage IR, but no
+	 * out of bounds read.
+	 */
+	if (sig_size > RR3_MAX_SIG_SIZE) {
+		dev_err(dev, "length %u is incorrect\n", sig_size);
+		return;
+	}
+
 	for (i = 0; i < sig_size; i++) {
 		offset = rr3->irdata.sigdata[i];
+		if (offset >= RR3_DRIVER_MAXLENS) {
+			dev_err(dev, "offset %u is incorrect\n", offset);
+			return;
+		}
 		val = get_unaligned_be16(&rr3->irdata.lens[offset]);
 
 		/* we should always get pulse/space/pulse/space samples */
-- 
2.53.0



