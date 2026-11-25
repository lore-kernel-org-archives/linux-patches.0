Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626217;
	b=UnhY9dwmsvXnPyzCec2oMD/wNMgtjRb3HSPycAfHDdwEYKBqJ7qXC895I6Zz+KCp8guU
	 VQ8hCIM7PHBPHZ0PO9+QYWjoekpntV9h+cUk+pcKGTdMTsOUzQgtAnlFzpaHUirDRSdpt
	 C9sshAqo00vFPlwQZChpRpPP755o/NHUwWGXzJtHQ3tMdTtITuPyav2hVX41ZzXnw9KnG
	 T4jNRDI2NQaGiB8GphZXeENQgkFrFH3aXERgF6VWUNQOrrU/cdftQd4UrgVbLXVYrkpqE
	 5n3ohisFQtG/4zzeOFQ+yhrsGv1ExUbooefIKOnLt+y0D5hTilhIcwv+zqylWDwl27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7zW4lnlu2Ui1fJ8EruXZO5kaTcHhv0LGEnh5Fcv+4iM=;
	b=fBj/AO5txuy86/UEzvw1ojcPLpKdQEK3WOf/m1Os4h8hfR5n/KXj7dejf+JbeChtuTwt
	 9cNvm6xmsNfWWNuWBjWqRPEvlktLOnI3YKIR1xqw1hXVOvuEE2P3l4z9RFnqdkbVIG0ME
	 lIWuDdHzcKtX2DzMOBCFhVSCsBPXaR4nDno1GnED5SlGHRxn3J3EcKIey8BSjJ4LMgG+s
	 ghU6qaGP3Cl4oxtuQlR+YZP/3cJkvvWythqJYo0GDct+HE2NrudFQuC/c7nrgXRxQGYy9
	 nynbOyyAvLudzkx3MPnvJNo0ti0UlzvQiDPwDdngVo35BNe4dvOmSvdTWGeriu3itZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i08+7TSL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9656F606A321;
	Wed, 25 Nov 2026 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i08+7TSL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B3F1F000C6;
	Wed, 25 Nov 2026 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626217;
	bh=7zW4lnlu2Ui1fJ8EruXZO5kaTcHhv0LGEnh5Fcv+4iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i08+7TSLlEI/Pqss8hmCovmYYP+zrbWDSg+/T5BKZlG2ZWLWSsjco0XHNoKUIO4eg
	 0YEMh2GBjenbnGlqOcW3YZmbGbOK7f/ax/LgrqykNfJ9aS0mjWEIZguezDfr0gGVJu
	 UQfX8la2cwGWh1ZNK4ZMGF+vDnuXNC9EGJgiBGB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 771/816] USB: serial: sierra: validate URB length in instat callback
Date: Wed, 25 Nov 2026 15:38:39 +0100
Message-ID: <20261125143907.018712781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit a3d43b39032cc5565a5693a10c581844342372cd upstream.

sierra_instat_callback() reads request fields and one byte past the
usb_ctrlrequest header without first checking that urb->actual_length
is large enough.  A short USB interrupt transfer could cause an
out-of-bounds read.

Add two length checks matching the pattern already present in the
option driver (option_instat_callback): one for the request header
before accessing bRequestType, and one for the line-state data byte
inside the serial-state notification handler.  Use dev_err() since
failing these checks causes the interrupt URB not to be resubmitted.

Fixes: 033a3fb980b041 ("USB: Sierra Wireless driver update")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
[ johan: use sizeof(*req_pkt) consistently ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/sierra.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -575,12 +575,24 @@ static void sierra_instat_callback(struc
 				__func__);
 			return;
 		}
+		if (urb->actual_length < sizeof(*req_pkt)) {
+			dev_err(&port->dev, "%s: short transfer\n",
+				__func__);
+			return;
+		}
 		if ((req_pkt->bRequestType == 0xA1) &&
 				(req_pkt->bRequest == 0x20)) {
 			int old_dcd_state;
-			unsigned char signals = *((unsigned char *)
-					urb->transfer_buffer +
-					sizeof(struct usb_ctrlrequest));
+			unsigned char signals;
+
+			if (urb->actual_length < sizeof(*req_pkt) + 1) {
+				dev_err(&port->dev,
+					"%s: short interrupt transfer\n",
+					__func__);
+				return;
+			}
+			signals = *((unsigned char *)urb->transfer_buffer +
+					sizeof(*req_pkt));
 
 			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
 				signals);


