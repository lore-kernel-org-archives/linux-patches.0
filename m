Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C90E38B7A1;
	Sun,  7 Jun 2026 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830061; cv=none; b=n+32a7fBIMB5ehAcx08v2B9y2FZM7WU6163Sp+N1QKTf5SwKaiI5tE6TISKQv6eDCFhdI4xuLRLNTRg8dI3PPL/khB3nEbAu9curPhc3iCQClo2pnSD7Ya0yHOcoQMzrKqvd2kom2EbEO0wo/z3jAkznY/dK2S5ALft1I6W7ZAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830061; c=relaxed/simple;
	bh=OUhaIKauqh0Wmh4VyDqCkVnrcVPYGJU4Rs1Dfoa1i+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EInJSHLs+SgDEA3KArQq9etjHVgZQ1U3LjKZ0B4mWoPvZWZDQqeSbeiqhWPUGsZdp4J1NJI2MhT41+bWvQPi+t4igtc2cG8uFiseJ0lfeu15ZwsfvX9V8wayytIKfv4c5z9axJGsjBKik6iEBwjZAdOD/PL2O8ZK2jcwwnenDJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6ji4H5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6ji4H5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6781F00893;
	Sun,  7 Jun 2026 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830058;
	bh=XvtJMwgUNZu2MAVvHUCvyjqlipaeThBK+iIhCYwti6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6ji4H5wDyIvL2JRDsIbb2dTzfdjgXFI1+WkmIEGFXWryctyCTnGmXRcFprSL8twb
	 psgaPegr9hTc3jStR2THTTfKNExL58wSVqvEr0YwwISAyn3Qgf9+AIybzZI+sAek56
	 Q/ZVqrK/SEbamhEcqduiExeiKGl0TgN6HB8STZ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 304/315] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 12:01:31 +0200
Message-ID: <20260607095738.767909088@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e1a9d791fd66ab2431b9e6f6f835823809869047 upstream.

Make sure that the interrupt-out endpoint max packet size is at least
eight bytes to avoid user-controlled slab corruption or NULL-pointer
dereference should a malicious device report a smaller size.

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context for 6.18 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

This one should apply to 6.18 and earlier trees that lack kzalloc_obj().

Johan


 drivers/usb/serial/cypress_m8.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -445,6 +445,14 @@ static int cypress_generic_port_probe(st
 		return -ENODEV;
 	}
 
+	/*
+	 * The buffer must be large enough for the one or two-byte header (and
+	 * following data), but assume anything smaller than eight bytes is
+	 * broken.
+	 */
+	if (port->interrupt_out_size < 8)
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(struct cypress_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;


