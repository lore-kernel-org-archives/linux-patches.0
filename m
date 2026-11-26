Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704881;
	b=jo7wfFQq87vwCkucIbhEVkLLXqKaq7eKnyXsVcdSZxygKkXdCNRqiLdIiZVEKBIoKaMC
	 l9HW2gAAJsDC6Sin87HsJy3wgA+TL8IE4VzMiynQlpPnNJZf3LttVoc7WqCeMnNhwNTPU
	 iES7u4+pTTawG6YeXfT09v8RlQBumOGwHCQcxnRKJbzpF/C2Ur6/gfO4esV7pBCJdfmW0
	 BeXCcZgS97dbYavLQO9aUukZ562o/YW9LFoi2wGo6tCr1opbuyzfKsMi2JOqMfOjzvWTM
	 Chlri0E+hdcutyuanTEqlTwBfy31Yh1VsSe1LLR2Jw4RXbfe3pSMXEUh2oU/0DBM2qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5MKYu7E/KsSleK7Il00rdRYqSss61kS2zqbFIHljvpw=;
	b=JiNqSSnPa9K/+kbJ5COww7eWPQh3gsdDR5CLt5TXm1WI/azPct7tBDnip17bGIyVGTT5
	 /oCBCwuLZsrNM/Lv++dN4QXosySZ8O6XI0+5SlMymazQtWUaDbn21VLKZhPBcB+6Vnaaz
	 RKlb2Nqk0anPJs7AoJ2y+/5SdIRrF/xxpGUkuqgVblV73hUfucsg5+IcTiElfim503YGs
	 +IusWJIYa06ZjmY/1EhgK7CgtcpU2j8oRsBAoQIT9z3ashsTmyEYuxvBYi2TlalmyJMLR
	 weed37kxu/Bp6YiZnwJzZDW/LC4mNJ4UdWHvDJcW9l02DUpvu4/3j7YhCC+rxuVELCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jku2dPWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BC3606A32E;
	Thu, 26 Nov 2026 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jku2dPWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7031F000C0;
	Thu, 26 Nov 2026 14:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704880;
	bh=5MKYu7E/KsSleK7Il00rdRYqSss61kS2zqbFIHljvpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jku2dPWUTvZElNHzX2uChiVtlRQ/U0HwknbG3+g/NpJI5bchCVAStTTc+xYEV2PkA
	 vCUURdhUzxTiVT7suCKCoyXycxB2HAqhD+kjArk93rXSAx7bf6fIU54izCuPif9n/b
	 RIh87MfSZsoGRuCpcoUT08NhZtFH394I91h1EBbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 236/265] USB: serial: sierra: validate URB length in instat callback
Date: Thu, 26 Nov 2026 15:39:26 +0100
Message-ID: <20261126143621.747333239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -577,12 +577,24 @@ static void sierra_instat_callback(struc
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


