Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705716;
	b=NNa1y8+bu60y7UywLpppMiu3c2ZNG47T+NYqT1FTBd8pD/6vakagV2fk+YvAMS6zhitx
	 icj1yFsTw1k5gnMwt4pqawDLEJ9nGCc/a9D6mmyIfE8FHVKXOoUKhAdoLht9KmDxXlcFF
	 V0qde9eDmUGXRqodM2xp0fxCXZEz51khf4G6qfXTP5C2SRxtSlT1E8xxPwEhuTUvjy/Qa
	 e2Ec5gBO/P2B7jgf45T1BY9AG3sHQH6V1/9kltQlyCcCFwfztAcnZA2jFQKMz9BhaF0jL
	 f3gKlovtJx03zPMuElp4xH5yo5lTYcZXSBOVW14K+WsWyHZvCHJi+FCcbBcPhMr0Dwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6i78LvqJxSILiow3chfl+/naE0avT5BFqjAgrvUNDs=;
	b=ZBYYIWKYNqFCZlLTlSEYw23aipObpZjxzqtGNgutFaM74fpdVaOlXf/w6wsI+8tcseu+
	 owzibMv339EQivswN7sKT/n/BnZCbFQipQq7klUPdvNMlFhzEUVJOAz45Q63hAlcFa2XJ
	 IwZ7BwktqKDVVTAL5eFV9mFb+xlvcmtiDv63zbR02ahWO3eg1LwPiLp2DtjLohDLDkZ25
	 uZjTkjPm3E4cImkaEX7fBL1a0tQEdoJz1o4aaIxyDnslGJmjZexBQegZ9y83rqRG0V04q
	 hAqQzEZfoXFkPLiZ9v8IArMvnZwSM4Je61puhS2gS4t8c3Cu9EhpQ5dMug2chuo8XiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8bcJtun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959FD606A31C;
	Thu, 26 Nov 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8bcJtun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF431F000C6;
	Thu, 26 Nov 2026 15:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705716;
	bh=x6i78LvqJxSILiow3chfl+/naE0avT5BFqjAgrvUNDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8bcJtunV3pcLP02nGcSqIO8M2Uvo5Sq7LFErVqQIzbtJlEUeBX6Iol93TOea8kGM
	 dawAPssWKFKCY+eHEk1uFv0Ng45+EaWu6krjI5vuV2xvH5B/s8ICj9yo62kpLO+7eU
	 KBamvUzblM2JMYUWYq29b3yhVJBzkjWyfnw1QfUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 291/319] USB: serial: io_edgeport: fix potential close() use-after-free
Date: Thu, 26 Nov 2026 15:40:59 +0100
Message-ID: <20261126144013.327658207@linuxfoundation.org>
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
 	copySize = min((unsigned int)count,
 				(edge_port->txCredits - fifo->count));


