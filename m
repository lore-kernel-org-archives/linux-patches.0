Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062710;
	b=KPiztIKkUPxX7QzuaSaqOx/QCzCYFj8smKWE9rqWWz3w49HcMIX2FnDLTunjnaII7nV4
	 mv0GGrwiqpGg12wKsswNwDhHEt84YF5S7nuLV0GHXZE2+K9mC9vrZaSRL7FhocoNww2oI
	 u+STpd0bhd0Kw5N1nXa+Qhn1L++QiwalFhEzNw4RGk/tUfGXg2g8mswHkB9RJry0XD/Yi
	 r2c6wpCbaykJAjpb/Zn750pWIqGBTeAlIIbdIe80ExkqXQM4/YaiuAQGGrAiySZ+v0Z41
	 ITraoqGVqtNR0O/UhrVe9flyf0MHqxoD67MKRFgLXHtLD2F5lut0uVZntJAePkkbNFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IpYJ/u6Rp8ggvY1xRlW64WzCsw+MfSAcPVhq5wE5NRM=;
	b=R21riWYs6oFkZBeymm6Zxnf97BBFfkctSvaWOKsi3eR+Hj2ZKexncPqEmmjiXQBaELaa
	 dTR3ISbJQHuTBZs3n5u3QQYCaFlxPVh1iIpuQ3SyNFhfDYnxfJBUuZvOx0Q3RvV1mA9Nz
	 ijaWq799gCT+EZ4YBcMU6s+AeQw3wcESVw9Jf3Ds7lDdmPOnvrGhr5RQwVaUJU96TWhaq
	 g1ORcVozywJyUCB8EiMGfnq+nbQy7yy1FBt8sSO/XIrsD9deExK7YJuuAz60BQtwHgeXE
	 W825CfubZ/+N4U7eH9lilV6vDPGadPj41ZIJv9VOyK9kdk2pkjBYdQOa26irUcGtrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxgYZmcT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75689606A32C;
	Sat,  7 Nov 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bxgYZmcT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD95D1F0089F;
	Sat,  7 Nov 2026 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062710;
	bh=IpYJ/u6Rp8ggvY1xRlW64WzCsw+MfSAcPVhq5wE5NRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxgYZmcT34nFLu88aug6UsBmylzVcUfN4IDdcPN2SA/M+oMCYW6hxF/7aY4Z6Adtp
	 RZZiktDtBYy6IRh4MCFXuuIQEJ0zaDReCQgMU5h1I8ywDCoFY0CeQKmyTr7Ng2FCvf
	 8MI7EM3gI1nZ7csYoSz1VTz4Ukg8rvGjqSKouG5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/869] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Sat,  7 Nov 2026 08:45:14 -0500
Message-ID: <20261107134853.259653568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 3170bd72a8e6f..4cbbe16a8ac47 100644
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



