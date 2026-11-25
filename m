Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623679;
	b=nY/2Xq0lAe8FqGQqyqwvcUff7wT6H39Lh/id+Dmv6lkynu2kHO7BnEhP9d9cLH748jUX
	 UQ0X+Qa6I2fvz4VKM5Q+JJSgFFycYP4fE+CGdKEVPNBVmG4KWJpHMrQjs2gyz55AiW0UU
	 pgAdbkBmqckrFtSshqtnK7aKTT2J2eoI0L+L/mGFD8UCB1Dz6plM18aOZuuAl5lrzr0oG
	 cX0wjQjRWbhIQRq9sBMFAH6pIRbopu1+Yb8/Nfk4pLTUDBDNGJLNLPCwCk1NGQISdfFPr
	 Jsicx9q7tRC9SL9kCFBKCOdfb7kTyg3lGo7oxpCKDR0B7vreDs4WWnb8K3jb4AJ8ppw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4emsa4a0m0+MChQtZHWWISc9JPNUd3Qpn3xDHDVBgA=;
	b=SGGFtKRS3ucC9t5lYznijeXGEF31P2BCDbDDpmB3H9cxe9Ce4+6Xx3C6TjVu+1Xfs74a
	 8hhHSv55PaFYTAjKE6jrSPiMOQQweMcW/mw4YDFEqt+xTx38ucusql+31sxwde9wylemY
	 v8NZXecOlLThBEWsVXv+nEN0G+NLCs0/X2gmQhggs1SFawQqn65LHWcs/vom3NXZ7QlGF
	 DN9USPPbemq9DoHI8l+Kz0fbKUrIhEk+5UnO2hHQJSmuV3ZMO6xvHdSPTgeEpYAskwgrA
	 b1iroxdjrrinY7VcEzPr9dqR/16RlEtJDmvoGDeUHS1A/ockzl7lxgqfNHxn+GQcE8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqFxumQ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C130606A332;
	Wed, 25 Nov 2026 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqFxumQ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AB31F000C6;
	Wed, 25 Nov 2026 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623678;
	bh=H4emsa4a0m0+MChQtZHWWISc9JPNUd3Qpn3xDHDVBgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqFxumQ7qo03draTMmIJy4tgpEfli4AfDIzbyXHZUlShv4BcX+dWjuR3yZ1IvS7Mp
	 wIvmYYEZUoJgwbBiAcYDMd1paKQl1GmtXrnw/EwZnyIiafzuOaxHYbytY9d7OZG48O
	 t/Lewh6hcq5exIJrl64Q/pYZGUgoN4IZrcjO/fLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 937/990] USB: serial: io_edgeport: fix potential close() use-after-free
Date: Wed, 25 Nov 2026 15:38:24 +0100
Message-ID: <20261125143843.940187552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


