Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA4C3148CD;
	Wed,  3 Dec 2025 16:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780393; cv=none; b=Cmi2tIh9sNORBIVDQhhDwoyVsAzbAHwYjDUeAZSg6ZMMIYGQ9tI10GJ3Z+wHvF6iIKS2lRLs1jcHlJdK7Mv817oIZyaqktKhB/sCNKISED96/fUVls1/v0PVABXpGeaAJEB17awIrtO4+La/AsUpSFvhJhdNUkuVpRgAhuMuvYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780393; c=relaxed/simple;
	bh=SP70hSBlLfJr7soh/lJJs3dqpRtoH97hxMvUyl/J1uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQDHkokqji9Mcs4H2LFYODpQMoCGHXytEPqWi4Ik2pm+8GeJAR2v1lp7fmgm1iqo3iD4gM2nwv/phUjHYEWUfgroS0CKNlIYjGq0KKrwvGL+ezRcuxUoMrJTu6C8i9jc1651/s2dcOknj7Ke1iZoMaw1X9mHUAvP9tIiDUPPXYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2W9XYRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2W9XYRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C9AC4CEF5;
	Wed,  3 Dec 2025 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780393;
	bh=SP70hSBlLfJr7soh/lJJs3dqpRtoH97hxMvUyl/J1uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2W9XYRpONvJg1KViVTtKw4K2rSPAtLDP4bGGvz2f+oug7nFwUpdcJC4AaMrAjYbX
	 plLJPj762apsVnhIkxmP4CZ2VV3QBxFA5M8sbrwmKcD8MDFt8yFsdatYrbHQBSCG8w
	 ibZv2r0lxCg2ADls9nFkmeSCQ2Dwl4PWZSDfnnOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 6.1 544/568] xhci: dbgtty: fix device unregister
Date: Wed,  3 Dec 2025 16:29:06 +0100
Message-ID: <20251203152500.635478452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,12 @@ static void xhci_dbc_tty_unregister_devi
 
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


