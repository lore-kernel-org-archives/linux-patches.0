Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626223;
	b=uyk7Qsh1YpmHH8juxSqYJSEiVnSW2ow/pHIkn2AAHiF4gwQysUuPX0PE7XNnCX+4dewD
	 F3A+NVXwbU9IbTtvB9M5M7zYZNjUG3rONRqq4f/rQnWwbTNFG5SkGwFj5kNQs8slfx9EW
	 BoO8wSc2ZF0EJGizlbPrOymLfhs9QGmyuQUqSV22BAgM6kBIB7Q0voDM7BF6u1vgEWh50
	 TlcZd8URR7g7muQKV4FvX4J5VTdUXsDsYcnj9QBkK5IHwR3leWnby8fqwZFBbadRbS/yg
	 nfLXA3XAG+HXJPXIcXvMharwxRVXsw6IX9xq952khjG2ZF6ryARi9Onko9yZ01AcEFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nyPwty9gP9ee2FUouf6HuZmPazs89lzsjICazIZXxOI=;
	b=eAC24T1a6WfWGQ8+kQCJSQ6XIXDWM7o81ijy0AINkXPlozAJ/QAxf4EvbpiR6amHxgs2
	 GoDiWTW3o7o1zfbNY4i1rmdXjIdx7ZNMJJMtFDuvN1z+ZalcAGI5/j9/KAt6Ebh1DC30M
	 8QgzsDgb6ERJopPmfXrB0GTucv6ag/ePj0hAUWTCVjmwKaw+nTnC4bdcVk7urW+BdcbRw
	 yvqW4PwYC4bx8gnuZSNBG/tz1qB1sfxWjmvD25zk0t/74BmDO54mBDxqHZHcwsOx8nwyL
	 araVFCH60shC8/7TiGEBnVTaNsm44FJAQxAfSvSl5JyImwcHW+f6LyVB1z3APKlA3JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKXAr4+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72106606A321;
	Wed, 25 Nov 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKXAr4+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC51F000C4;
	Wed, 25 Nov 2026 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626223;
	bh=nyPwty9gP9ee2FUouf6HuZmPazs89lzsjICazIZXxOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKXAr4+uAFEuw15gn2zL+Ry94dF4l6dnVjjLM5B99psfu7wsno4n6O34mcMHxKPLv
	 xjuqHqkfyZVpuGwZDjvXIbT+Zq/CH8PPD3yeXGI6cOeb3916Jh28ft2lPSFN1vJv6c
	 CFKdnfGl6dSKuC+C97NxMHtIhefJMDPp7KgDK07c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 773/816] USB: serial: io_edgeport: fix NULL-deref on early status
Date: Wed, 25 Nov 2026 15:38:41 +0100
Message-ID: <20261125143907.065457136@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit ae22e9b6412e5dc99e1cf8bd13c6176d44c7d42e upstream.

The driver submits the interrupt-in URB during probe or on first port
open, which on completion may submit the bulk-in URB before all ports
have been opened and their waitqueues have been initialised.

If a (malicious) device sends a status message for a port that has not
yet been opened this may lead to a NULL-pointer dereference in the
bulk-in completion handler when attempting to wakeup blocked tasks.

Move waitqueue initialisation from open() to port_probe() to address
this.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+763813d65c7e18c1b6d5@syzkaller.appspotmail.com
Link: https://lore.kernel.org/6a8818d8.ae6ddae5.3da009.0031.GAE@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/io_edgeport.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -877,11 +877,6 @@ static int edge_open(struct tty_struct *
 		}
 	}
 
-	/* initialize our wait queues */
-	init_waitqueue_head(&edge_port->wait_open);
-	init_waitqueue_head(&edge_port->wait_chase);
-	init_waitqueue_head(&edge_port->wait_command);
-
 	/* initialize our port settings */
 	edge_port->txCredits = 0;	/* Can't send any data yet */
 	/* Must always set this bit to enable ints! */
@@ -2965,6 +2960,11 @@ static int edge_port_probe(struct usb_se
 		return -ENOMEM;
 
 	spin_lock_init(&edge_port->ep_lock);
+
+	init_waitqueue_head(&edge_port->wait_open);
+	init_waitqueue_head(&edge_port->wait_chase);
+	init_waitqueue_head(&edge_port->wait_command);
+
 	edge_port->port = port;
 
 	usb_set_serial_port_data(port, edge_port);


