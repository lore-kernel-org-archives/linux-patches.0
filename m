Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169D33C1A6;
	Wed,  3 Dec 2025 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781159; cv=none; b=f/3vB8mRCSG4QLhndjEvdGryNNeLDAit2qUbT8QRIm3uTw9JjyaGiSQNYflpu+H/250Z/4qF60L1EtCDDJFW+/gdUZbEYCuB+D5z8SfTlT2vQGjgMM82eiEElqNsxW7EdpdgwViO/OafcFF7J85zMFbXbptchAuUXiutY3W7x34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781159; c=relaxed/simple;
	bh=GOpxJI8KY5pJ6dflJZgJa0a0aCPF/u7jmQdSVrVwQws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bFKKFIcr6j9vj1tyRzESLqIRIIzVKOi4TwiYBR3eZDRQJj+p6k6C3P1iavyX8UzqPU0Xwk1aWfQacWytU8vRjeyTd6332x+iv4ma+gxTv01JmNjRlH/dmln/qDrx6kmvj9k4VoZmxZ12jSEpHmB1roLw+w4FP0mbSD1kwlhY8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgrDw2jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgrDw2jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9F7C4CEF5;
	Wed,  3 Dec 2025 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781158;
	bh=GOpxJI8KY5pJ6dflJZgJa0a0aCPF/u7jmQdSVrVwQws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgrDw2jUEe92MFThzxeRa7R1YpfWfJeftRP8E58KKysUMXQIDLJxocYk5Crm5ddFW
	 D1p+/Y2VLq5RwucviCQR2acxbN6tBaGEdwbpjIr8luengL8y1NOrFaC+qA5BuEXdiU
	 apNCO3TJKf3p2+B0viDpceZYM4jlNJWWW4GVBYxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 6.6 68/93] xhci: dbgtty: fix device unregister
Date: Wed,  3 Dec 2025 16:30:01 +0100
Message-ID: <20251203152339.038684679@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

commit 1f73b8b56cf35de29a433aee7bfff26cea98be3f upstream.

When DbC is disconnected then xhci_dbc_tty_unregister_device()
is called. However if there is any user space process blocked
on write to DbC terminal device then it will never be signalled
and thus stay blocked indifinitely.

This fix adds a tty_vhangup() call in xhci_dbc_tty_unregister_device().
The tty_vhangup() wakes up any blocked writers and causes subsequent
write attempts to DbC terminal device to fail.

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Link: https://patch.msgid.link/20251119212910.1245694-1-ukaszb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -518,6 +518,12 @@ static void xhci_dbc_tty_unregister_devi
 
 	if (!port->registered)
 		return;
+	/*
+	 * Hang up the TTY. This wakes up any blocked
+	 * writers and causes subsequent writes to fail.
+	 */
+	tty_vhangup(port->port.tty);
+
 	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);
 	port->registered = false;


