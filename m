Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E635E93B;
	Sat, 17 Oct 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257172; cv=none; b=XgYF2hndshMIPF55Jmqm0UI8TGjORVmwoXhXYGA9f0eaMnMuWPxqhvmd83NCeGZ5D9pyLLdBtH1EjYIxEGRpTS/vBlddRxOeYwlA2wfnZeoo64uBeMPvNIXsF1yVYlvSNFYSaNw7vF70DGZ++ZTAResQjDgMczka5oaw5Q0S2cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257172; c=relaxed/simple;
	bh=3HBF7quJX2lLx0JDXrHOGRKkY4CuCYGnNSmsZMpBSu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vou0LdYdPLIPR3y6Vh59s7t8poebT7mc4sbK+Obou/5Z1DhWIKzLh2AipFBQd77qW7CJkhQ7GDaFx6ar06ldCHr6Yw6QNLPblhpQBCFi3JvW0Lz63RWV6dIXuyZyoz5uTyOXOdowLq/yqgfHhESnU9ZdNTbXrYyL0S4OqzfZf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyL85cWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyL85cWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4D71F000C4;
	Sat, 17 Oct 2026 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257171;
	bh=YbNwdiN5nre8WQPSMBNI5FVgpYhiBbCDROvg8POZlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyL85cWE6L+ovb/2qhVDxqWNkrzL/TX/exOTbD2BVm4j4Y0av1yrg14qkTyKb1vBS
	 mLmgrzxbUCrZERkj2MeO7Ag60Mjp3MVxpNJpK6MtZMJLJ39IhdpiqsCzB/OQ2MzrO6
	 qLRx2goRpjBKEatVpDU2eXQxwjSJ3kbyWejEY0gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dynetrex, Admin" <admin@dynetrex.com>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Drew Willey <dwilley@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 0472/1674] usb: f81604: fix struct f81604_int_data size mismatch
Date: Sat, 17 Oct 2026 17:45:44 +0200
Message-ID: <20261017160443.232445223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


