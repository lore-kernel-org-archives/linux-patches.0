Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F6B4F390D;
	Tue, 13 Oct 2026 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892866; cv=none; b=G4MDj/KXFlXV0S8y9Qs7dG9+9rt0dyEkNagWil1WP5xgyvysNrYOZPpzrn4BmbAnOmv3pIjOOUe4wfoYXuAsaKycS+SZ3PHYFQ7kPH/jlumOnGZdSA4mNGizI7GrgbzE9sa6ovQ/dkb5E+OAy7BHW/azMHGFtgarCVEb/e4MUzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892866; c=relaxed/simple;
	bh=aCnOGaWutFRYot84IzbY+LbmB19CczZtIl0J1QkRvEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgX/fNsfLeVCI2TxvrICeo91cmUkXsqr/8WZBqfgG05qZWxYowvoMxlWfxBbHBFCBCZLVyrYFn7rbgBBmY0P014Xq3Iu9l2pWnYgjTkNng7NTNtpd1656h898iSbMosNtzPGeoQWK8BFZPPjERgx2tV3HOBfJHOLPvYS3iTxoWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjuaa+hn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjuaa+hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EE71F000FF;
	Tue, 13 Oct 2026 12:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892865;
	bh=FdHcJRsPssOdKkir7yFskCXGQLG0xil1MitlOKAXJXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjuaa+hnftkW62WI8h0NlcrcSyimnYLSVQI3hRWsX2Vla62eFBpZcIWZ7ok+kBg0K
	 ArB6wlKzitaOquXyKbVY21Ab8p0aV/hVv7kgsNa0J/wVSWkuYYa5D8cSD8xAeaPRv+
	 dsd1TpH1YBESdRASv4hPV4x3NACmLc0oncoq3250=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dynetrex, Admin" <admin@dynetrex.com>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Drew Willey <dwilley@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 034/621] usb: f81604: fix struct f81604_int_data size mismatch
Date: Tue, 13 Oct 2026 13:30:29 +0200
Message-ID: <20261013112921.675925060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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


