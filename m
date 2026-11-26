Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704825;
	b=ZTCavLRZH1CREiKSUf9nwaHLzz/i0QkH/c2G2Q5dP9uTy7guAY+FGy7CwLS44UBjhCnY
	 cBI7mqkrJZKT6qZFDnV8ZfAX38zLK7uGygy3KbqvTsANuT7AxdrL0AN0NXiEQcjiPf5W6
	 Hzv0M/vmLZs9RobSgsRz5jOCjSX55GCXr2VHh39bEH2Q6WzK9Hw7PCGJtrFzNHQGK2cDW
	 VGdkMv2FYcwWwlRpbBe7CfQgTvnPboXJF/fAHsmbjrSpxh5uAmrEPq8T1LiXZk08iFMD/
	 tVF4jhAsquK7YSuvRuIw3b28qR5Ap0YfVYQdKkjqKEi7OCJl6cBPr4Yef3tRKiNbQnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0f4CPhYXbxub5/PbiUdQz8bElVJLCE0h0HJ/PdOjEM=;
	b=mqxk/WElT73MK0tb+7P6C7FZyFIA7y2dW+wdCGNyYPLj2/cX9FCoSVoIa+GR8aPHfK8u
	 TKz3vEXiZH7fQIHlqQjSXwj7Jjt87MF3eiuVrczmiPPYQVGZIDX/DZvP0JvMFCvBmAGNR
	 GDkoEMpWSYXRRDsl8FIFyqXIcTjHanOd7BRQEhRjlAel2yZzR08GRV/E0GdnSm+g7KUaY
	 QSiSwZCiIC3ip+2phsMtHXMDBxjG+jiE/0pphyac6gU8z95eYCAm3N69dcjxzhIGFdEf+
	 yQq+mEt3v6yFoqPDy8tlb0Sq78GgoIqW4rZoEtop1hSvHb1NDEHAdp+JgBuFls+NWtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSFWrtTZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F33D606A31C;
	Thu, 26 Nov 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSFWrtTZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB21F000D4;
	Thu, 26 Nov 2026 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704825;
	bh=G0f4CPhYXbxub5/PbiUdQz8bElVJLCE0h0HJ/PdOjEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSFWrtTZ7Nz0HMrF5TcEWvVai31wL+pBoD/5KVR70lPfVU9mi6SjGPs3h6pqpoQf9
	 TTSF6JZ7tjLDCYgIdBSoCY9132m2xSXEDNm6N2Hj3HZbcTil4inNalOvNWH+eSC2YQ
	 3ajEOkSpVxZhXGYRpAjsKt+ga5weCcK8BIGXQOvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 238/265] USB: serial: io_edgeport: fix potential close() use-after-free
Date: Thu, 26 Nov 2026 15:39:28 +0100
Message-ID: <20261126143621.898210191@linuxfoundation.org>
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
@@ -1161,7 +1161,9 @@ static void edge_close(struct usb_serial
 
 	/* port->close = true; */
 	edge_port->closePending = false;
+	spin_lock_irq(&edge_port->ep_lock);
 	edge_port->open = false;
+	spin_unlock_irq(&edge_port->ep_lock);
 	edge_port->openPending = false;
 
 	usb_kill_urb(edge_port->write_urb);
@@ -1203,6 +1205,12 @@ static int edge_write(struct tty_struct
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 
+	/* avoid accessing freed fifo if tty_wakeup() races with close() */
+	if (!edge_port->open) {
+		spin_unlock_irqrestore(&edge_port->ep_lock, flags);
+		return 0;
+	}
+
 	/* calculate number of bytes to put in fifo */
 	copySize = min((unsigned int)count,
 				(edge_port->txCredits - fifo->count));


