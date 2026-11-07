Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063808;
	b=a8f0j9L41Zy+R80NMQD2jwMsyfFKg0BsVqjYq7ec7OppVNVxCu26bpPxYTpw+zZxjUgo
	 ap18QxfV97vtUCUlEQzRGcum5yZZwasUz6Wv/noHkXjaUCNr0Bf8jCVI7odP4m9eb1xZF
	 Dn2WByNIpvC6mDjzmV3Gg1giW6RiMf1oIR1finHEvxdaTxgrWTI3AoMICTS/gTOw2nKwb
	 fJbDMr9O0De8m9V6xTDsctRdNUGnHcK3dbkj5qpB3bhWxYCDoGT490wZAe7vq0kl+vOHI
	 1JigF/FxkqAunhBKOXDUQSMtazyZv5iw2MmtxniPKiqnW0ozZF3RUghk4uWQOco8qsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G1JBU/bjgMW52qUtu+BB4C04q7nZWLzKBPQNemd3mpI=;
	b=Tvkj7cw6zq08ONJ2UUT5Jex4lIkpW8V/aAArft+TUZp7Pqfac2JdYMMO+YKiJ9fGNQLo
	 wMTOrKRjIRTnsMxkHFH0u3vEjqs+GQ+JVNfsGoucMmTkrtNFGQZltolMKqfEfX3Eb15Q+
	 debE2mugG3JrvfjHB3CHihd/Jfsf8GTs3VhtYpjdun6QEEQJ1hZzkwI7ifrVUSveb5vyu
	 IZZ3W7GX+qEeWTU/qFjWAY+EtmlCoJkTRstOviDF3K6X3n8ulUfrV1iMZqAbMJuWY18S8
	 7i0Oh/JRE9S1nJxfpv7dcIV0qNJe3xBE3b0Z6oynSsxWXSUe1WNEkc5pXJ0ZFQogNzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIOH68eS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F3606EE81;
	Sat,  7 Nov 2026 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIOH68eS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABD11F0089F;
	Sat,  7 Nov 2026 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063807;
	bh=G1JBU/bjgMW52qUtu+BB4C04q7nZWLzKBPQNemd3mpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIOH68eSiG8A0rH1qUdkxwxwm5/vDW69fFX01mlPKi+InyMhKIqCe25Mn80fbzgnQ
	 owuBQRRJen41WU7fZupGhLF+7xv8jqKa25KllRCKGwx/Gqv3cRzoGv+gMTuB7VNnNQ
	 KrCwADYLC5Q3tDzfsU/GPJIX79plLmCvnrlw/CgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0026/1257] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Sat,  7 Nov 2026 08:38:42 -0500
Message-ID: <20261107134940.128426542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 565c490b7051a..1200fb49d8879 100644
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



