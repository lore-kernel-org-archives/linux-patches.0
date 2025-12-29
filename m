Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91EB1B6D08;
	Mon, 29 Dec 2025 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025667; cv=none; b=GD3hiLNEW73+OE6SUJ3xC916d23ndD0BEaNbDtHcNlxz+RX2M+3al6sx8Gpewl8o1uDwOqRHMD8dpuRmAZZ9MDABY6qeoIFJjijpZwVou3+1dP/8y/QMmj1sRaBNJBdgwQuBG9ygjgrvXgapb9AEAtpRyx/Lauuw0Dgs9+rOMUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025667; c=relaxed/simple;
	bh=ei1q0d6raQe0bIq4f3mNaLsJmSImjZc0OXkk20YIj1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+IOrpTEgSdwSvFq6kl263sizSLZcOmQ4siREi5rHgXc1GbsolYYyUMm1AGWviODG0MbZuh+wQ70Q/xhbz/Gk2rWIQWbk/rjr30ozmHXKb6LiyOziLWIdWfZNbhfQ4G3qdV2lBKVZ+D2ys5EcVY/KZTG0DoVTdurg29hKw0NGTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xABQNC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xABQNC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3560AC4CEF7;
	Mon, 29 Dec 2025 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025667;
	bh=ei1q0d6raQe0bIq4f3mNaLsJmSImjZc0OXkk20YIj1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xABQNC8+eoIlk2wvruN77CRUMW0MrGgc00gGet7098JoKMMUrJ8EEOu7oY7gOlJv
	 vVbckGUzEYoX7jZgi/mnOSjW7/C+lxkppJi83UYntGbSSCVf2lOlpVlajllgmaR1ZS
	 pyAPqueFJlHsNjbJRj2jna5fZgj1xf+KEhb+LYm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 6.18 294/430] xhci: dbgtty: fix device unregister: fixup
Date: Mon, 29 Dec 2025 17:11:36 +0100
Message-ID: <20251229160735.159842573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Łukasz Bartosik <ukaszb@chromium.org>

commit 74098cc06e753d3ffd8398b040a3a1dfb65260c0 upstream.

This fixup replaces tty_vhangup() call with call to
tty_port_tty_vhangup(). Both calls hangup tty device
synchronously however tty_port_tty_vhangup() increases
reference count during the hangup operation using
scoped_guard(tty_port_tty).

Cc: stable <stable@kernel.org>
Fixes: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
Signed-off-by: Łukasz Bartosik <ukaszb@chromium.org>
Link: https://patch.msgid.link/20251127111644.3161386-1-ukaszb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgtty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -554,7 +554,7 @@ static void xhci_dbc_tty_unregister_devi
 	 * Hang up the TTY. This wakes up any blocked
 	 * writers and causes subsequent writes to fail.
 	 */
-	tty_vhangup(port->port.tty);
+	tty_port_tty_vhangup(&port->port);
 
 	tty_unregister_device(dbc_tty_driver, port->minor);
 	xhci_dbc_tty_exit_port(port);


