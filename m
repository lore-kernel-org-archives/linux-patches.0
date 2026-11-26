Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705710;
	b=co6Q+HSHoI4w74GWxhcleT7WE3NBXAm4aRJpLCx6sy6OGA4ZzDuRwN1bEtb8iTGdyOib
	 B0Ww4Z4TiB1RZEVXDKwZ4+mZgKiU+D+mH5cv/ZbTW9Oi/Yg3qdBwIPGZHYw7FIShXX35v
	 5FhV7JKlKcI2La+1Fs6B5KyXK2LVboJuXPQyqsO62kbKih6AAkv0mq5Q3TWTJ/ddHyUZT
	 AskUGX2Y0AsDO+be8wXet+tpjX9eQFTH9vb8gPBBYaHSGdob7S/ckN9O1DvKH/ENLroK7
	 N197D5XtjgLF6vLgEZHN57oIeFcRCB0bWO750x1Zke0mbN4bup+9LPS6xX2Z2V+6AIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PVABOE/p22x3sZp93erGFRZy1bTYvGWDU/Nz55tdbA=;
	b=pBIxvnfLDnOawFjl4z3PtQjUkAtGSC7jP0wIhUDJoqE5SD2g2FiLPdOO8Swk9JFoZROZ
	 9U45ypjmbbt9fgwHbz0wF3XrkIQHSXzWQYDJQMMvLLn9QWzRWcjhouyuQ4DU+GaXqgPIq
	 /CHFfdTZQ7RCYkd5xdFgLjDSzKO+HqV4aqsisYF2md0deDlIq6TA7eGARrAfiHM9KjJ1u
	 Pg2hPXCSlegw7Mx8c3LWAwBJ8uxh58zuALPCNLqTFqmCQ7HtiCr0qAHMbWmrXibEtMugh
	 vuUNZgmDomZdOxK97mLyx27dwStZGs4bqf4Fb0B7lHfR8fZ2Q0mOf1OqLvSvKKYjwDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOlVxu9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5956606A31E;
	Thu, 26 Nov 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOlVxu9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62301F000C4;
	Thu, 26 Nov 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705710;
	bh=7PVABOE/p22x3sZp93erGFRZy1bTYvGWDU/Nz55tdbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOlVxu9VlsT4jRGWLzHQ3N+7rCHF5QF3NkqaWxzYK+dn4pxhg5M5TXpeTzuR/rx2d
	 0vS0bFEUhrKhn95Yhfq+rsulSRY76pWxRPK4lG/kdVTvYnGzp3qM5emrfBLRKrR+Zt
	 gFQVTX5DToydk8ZyGT/8FBjm/priOJAuSTLhFeD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 289/319] USB: serial: sierra: validate URB length in instat callback
Date: Thu, 26 Nov 2026 15:40:57 +0100
Message-ID: <20261126144013.282967191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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


