Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25998346E51;
	Wed,  3 Dec 2025 16:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780882; cv=none; b=VTvN/YBV1WJMelc3b5QLrO1IZP9xSJ9EctD1VYVSmUZrQ3c6LQ66ptV3jvAWUnCTjj/menCXDlb5BkrFdOQsElShj8+21X9Vbwt7isATCf44urTxvgSUdQ6O1W7ekMpmCAC9TnB4cAS8s/w1H8pyuc2iBc0qtBMnilj1lLeLYJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780882; c=relaxed/simple;
	bh=bYLze0U1e99T6fcAUFRB63+Q+FWHSnBWiMyLo0hbfJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kS8rfB1DV9eqYnLT8mZeVozNRWlGyZpGEOv4fRjvzniM7IduTmAPptz7bZALfhn/Py4ovGOpRoFTLq3ECvzKfTqCqhZgqfFbzMG7Gxmst/H0jyTz5ZZe1xwTaoH28qfHnUjj95btymc0YtH6rTc3rfbTk92ONdNRDSnRLZVviw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwpvQ8nD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwpvQ8nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8139EC4CEF5;
	Wed,  3 Dec 2025 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780882;
	bh=bYLze0U1e99T6fcAUFRB63+Q+FWHSnBWiMyLo0hbfJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwpvQ8nD3YbsOLABLoehe26OMe+aOJhl2OSLKD5lWAYXLr7TuZSMrPOTaaCZdQdS/
	 5mWHBz4L+Ek1/qKjmGeVow4qqvtHjw5tL1O90RFQnr+lEQvF2xzqp6nbQ02/LTURas
	 7uP5VYzq23jc4m6iUZd9RjL6zdQJph5+ZAVQ2KRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 6.12 100/132] xhci: dbgtty: fix device unregister
Date: Wed,  3 Dec 2025 16:29:39 +0100
Message-ID: <20251203152346.991007822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


