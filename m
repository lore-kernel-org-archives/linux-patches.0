Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB03D5657;
	Tue, 13 Oct 2026 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895869; cv=none; b=LpML3bX3BJ1+X0CcXi55T5CaRG2Auygk/viCQRRRZbFpE7+MDnXOGOYDYeyKMuAd2VXGT2LorarH+ymdwLR2TUZaiu9NWDGI8Hce/a9wxDqJ0/qH3lV/gLl6grrmUqZ5HSViILHlRfjImt7O7EIwz5pAS0axoE2TaHlVHgx3jjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895869; c=relaxed/simple;
	bh=+N/6lqEYbOutydAbJIi+fuHDd3qY54NS4HVUZJMDsks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKZL+HjL8ZtaZB0BKaI3Qb8ZqH6qpgZx6ZCfshS0HvdOC5nvboAFfsJPIQ0ct4sbr8aP2Sm70U4VqIr/414IGj2WiIa/G25xgoeT5IlyCbzkGcqOEgFZtI97hn4dUqPzbTjrA/avMC+i1oOQzmMD4YC6vi3QWaM+42sodG3AgDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XK3iazSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XK3iazSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4631F000FF;
	Tue, 13 Oct 2026 12:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895868;
	bh=bUv0W4apV583nGXEF2jc8T3W1pX3/ldW+OLvg3l+XQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XK3iazSyGl+X1TAx8f6tkuOvLvZunw/y20TM5wvtxCKzfkXXQ6fTF96j3d4S4JRnz
	 sX3S6an5ap2bdW5J2uOQQD8I0hWvVFPuVJW0K+OTbrkbCyugttGX5eC6t1zdIWnYru
	 4YJbMqey1ZSeqOxHGgJMpYht0FPYGsEGgK2G+ej0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dynetrex, Admin" <admin@dynetrex.com>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Drew Willey <dwilley@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 366/497] usb: f81604: fix struct f81604_int_data size mismatch
Date: Tue, 13 Oct 2026 13:38:53 +0200
Message-ID: <20261013112916.589408770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>

commit 7f85d1170575645f9f327062d78017a23b2714eb upstream.

The struct f81604_int_data defines 9 bytes of interrupt data:
- Byte 0: Status register (sr)
- Byte 1: Interrupt register (isrc)
- Byte 2: Interrupt enable register (ier)
- Byte 3: Arbitration lost capture (alc)
- Byte 4: Error code capture (ecc)
- Byte 5: Error warning limit register (ewlr)
- Byte 6: RX error counter (rxerr)
- Byte 7: TX error counter (txerr)
- Byte 8: Reserved (val)

The hardware sends exactly 9 bytes for the interrupt endpoint.
However, the struct was defined with __aligned(4) attribute which
caused the compiler to pad the struct to 12 bytes.

This causes a problem in f81604_read_int_callback() where the short
URB check compares urb->actual_length against sizeof(*data). When
sizeof(struct f81604_int_data) is 12 but the hardware only sends 9
bytes, the check fails and valid interrupt messages are discarded.

This results in the driver only being able to transmit once because
the TX complete interrupt is never processed.

Fix this by removing the __aligned(4) attribute so the struct size
matches the actual hardware data size of 9 bytes.

Fixes: 7299b1b39a25 ("can: usb: f81604: handle short interrupt urb messages properly")
Cc: stable@vger.kernel.org
Reported-by: Dynetrex, Admin <admin@dynetrex.com>
Closes: https://lore.kernel.org/all/A3834A07-5639-4779-844F-C5843DFC3928@dynetrex.com/
Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Drew Willey <dwilley@google.com>
Link: https://patch.msgid.link/20260824-f81604-fix-v2-1-fc9be5581394@fintek.com.tw
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -169,7 +169,7 @@ struct f81604_int_data {
 	u8 rxerr;
 	u8 txerr;
 	u8 val;
-} __packed __aligned(4);
+} __packed;
 
 struct f81604_sff {
 	__be16 id;


