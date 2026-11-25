Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620557;
	b=yQtjpzkvBNMD8YAbPH4BB6iWgTwmgtWtUxPvJ/H60GHYb2l1K8moGp32BHrd7V1dPf6+
	 Yqa3C4dw9fiAwEhvGBBoIiH89TvfV97ch7fjXDDkWAU1AY53iQhYgEWl8pdyfP1Qu8DZc
	 71onYGU1DzzhIodQynSrybrJXsLP+PmHdUI5eGUK2TWbogjgJev/bcp16MnaD73R0OovK
	 JCG+TxrWhPIFw645vVXAdb/g4uS5teqwQkg5BUIJxzrGPcG6TMUma/HI/4TqKaRcjowK0
	 PPQ8z2YyYZ6d1PZtlKlZMmgHR4jromtDWfGKxRWBKfFWg3r5VUfAVY/XE1aHXsiLHPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VAM7YJqFOFcSwissMV/S8KnEfCbYtUHQqwTjns9lVSA=;
	b=24PsbmHapbbpf/J8n7HlPjx7B1XMuMc5rA+qPKWVAl1zLj0c6Bq0H9LsJEpDK2KI318k
	 EaL49X6uHF1LGr+9T57qWcSEHzPLe6d7d+1kdV1WEz1SVv2fyBMNJ8MNoQmROUiaBvLS/
	 YZt7I9oF8gFBHm3SCYH4HeSq0/vIn374Hwo+AGwPzYqFI5VuTROcPvVSfQ2hn6AutBDsm
	 zCD6UMDNf/hFuBrySSDBJYY+k/APJ/zV9aP8lyoRb5NG21q8lv4+dyzHv28FIST94VNc/
	 KvgrMoJVtVylIlGXx69HYnvbtwIN/YonjNNelbfqZbcSZ8URNsJWNuyile2z8l5E6OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MCyI/Ebt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69122606A31E;
	Wed, 25 Nov 2026 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCyI/Ebt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A321F000C4;
	Wed, 25 Nov 2026 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620556;
	bh=VAM7YJqFOFcSwissMV/S8KnEfCbYtUHQqwTjns9lVSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCyI/EbtePte5EzaNAj8DFFKen6jUnkKQH2v5o1IGRHOSMR8ePlRy8J0/SPwqKMJ+
	 nZOS5BjKca7BSfgbXwCaxooW4xTez5PhrH+MkF5y9SJ1do+dQzYfXZgJ/EFEynkB02
	 1pyHuZyfT1GlVfk9/jWNiSkZVRfxFYHsJNI8X3oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0957/1005] USB: serial: io_edgeport: fix potential close() use-after-free
Date: Wed, 25 Nov 2026 15:38:15 +0100
Message-ID: <20261125143844.090962080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 839ff5fa30995c40cd5fba15fd976ad63416738a upstream.

Add the missing open check on write() and locking when updating the port
status during close() to prevent a racing interrupt completion handler
from trying to submit more data for the port while its write URB and
FIFO are being deallocated.

This issue was flagged by Sashiko when reviewing a related fix.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260714101316.823942-1-shpark061104%40gmail.com?part=1
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1085,7 +1085,9 @@ static void edge_close(struct usb_serial
 
 	/* port->close = true; */
 	edge_port->closePending = false;
+	spin_lock_irq(&edge_port->ep_lock);
 	edge_port->open = false;
+	spin_unlock_irq(&edge_port->ep_lock);
 	edge_port->openPending = false;
 
 	usb_kill_urb(edge_port->write_urb);
@@ -1127,6 +1129,12 @@ static int edge_write(struct tty_struct
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 
+	/* avoid accessing freed fifo if tty_wakeup() races with close() */
+	if (!edge_port->open) {
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+		return 0;
+	}
+
 	/* calculate number of bytes to put in fifo */
 	copySize = min_t(unsigned int, count,
 				(edge_port->txCredits - fifo->count));


