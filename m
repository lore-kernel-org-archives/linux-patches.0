Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2D63370F2;
	Wed,  3 Dec 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777231; cv=none; b=h/0vnePoy2jaVxUNdPWycK7YWKrFnRXb1TiOIsDC13hDy2B95qN5eTbD70mOx2gej/ci+1J/QQO7lLSg5Q+I4e78YcJUZWSDhzfQ9GqxWagCwjpvpoC3zX8Q6uekcxK9YbvMMfPUUGZRrXHNA/49OMzVbAm2po/M6NGj+bjjd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777231; c=relaxed/simple;
	bh=PAylfpklgSLNbsVJ5blf0/Dx6VtMn6LTnmNR0mCUa94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPRDHMcifFM8Eehoj7EKs/gvLYrgJI6cALa2jA+4I+ARqeBztRVqJG1iWuWntqfxoQv9xPd2+X+++WH/zl8EaG0QN7ibdv+hYFaI4fW89IQRFlOhHjHcRVme/dsbPgVjHJBZF+WooIqi9UUe+bTPRwemji80AliIABuE26GrAes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW9+uOec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW9+uOec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939B6C2BCF4;
	Wed,  3 Dec 2025 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777230;
	bh=PAylfpklgSLNbsVJ5blf0/Dx6VtMn6LTnmNR0mCUa94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW9+uOecfFkgS++fez1Ut23aQWJittmjR8wnDufNZ616iMn5CFtdyb1SSyskGiov5
	 vtmVKFNo6c0i9fgdyjDs22FWcgsMHT1b87gOY0ZBYqXOQZUJs8nsLjmIPMOk7+1QMD
	 oTCD+AZ/LXuUwtKNnTe2z44eZncvWjE1gd1YkOzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 6.17 123/146] xhci: dbgtty: fix device unregister
Date: Wed,  3 Dec 2025 16:28:21 +0100
Message-ID: <20251203152350.963382060@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -550,6 +550,12 @@ static void xhci_dbc_tty_unregister_devi
 
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


