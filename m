Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73293B635F;
	Mon, 23 Mar 2026 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274335; cv=none; b=YfaINBXyKLUChdFm/6rrGNauIaAK2D7m7cYE8gFjDGc22tiXNacwcts1yp91DkKZuKgRvvUHgoJVtOmzy8M0mPpI3WW3CouZEeh24gMmA8G4G7p1WMo9TSnG9R1ATqUfTIKj83DjQpodeWQ8RSxVFiiJSU7UDt+m29SCgFD9NYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274335; c=relaxed/simple;
	bh=nrwbwbKG9D8G0vkJIDqKGlpwu4rjG1pbovAQxz1Si1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hp32byFSL+DBCXqo/nUv2UZ307ja6Akp7E9/n6GXeKzhTtUkVR0Bs963wY2K+YBLE5Tym+EgaGLQTCSm6tfi1GWGmY6l2tygX5GfY9NX94PAMX8OBpa//kVgpOpHbI9Kl/gUFXVRlA3jMQWytwzEZy2DxnYdIfHg+LQMznGXDPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8zknkgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8zknkgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388F3C2BC9E;
	Mon, 23 Mar 2026 13:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274335;
	bh=nrwbwbKG9D8G0vkJIDqKGlpwu4rjG1pbovAQxz1Si1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8zknkgy/dYTHlv+HrhCLKG7Dkz3twGHqz3xW6EN/A1RNRHs0PfOBocZ/eQbSi88S
	 lsbF8ZD8lGf4cX4lMbsJ2Q9zModUlHl9Axcf97Y01MJKumVzkZpX2WcVdmUChPNMsZ
	 A2sy5Dfzt7S8wOysactslinIyWMxoTL5H2HQEJYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <bence98@sch.bme.hu>,
	Johan Hovold <johan@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.19 186/220] i2c: cp2615: fix serial string NULL-deref at probe
Date: Mon, 23 Mar 2026 14:46:03 +0100
Message-ID: <20260323134510.456877153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit aa79f996eb41e95aed85a1bd7f56bcd6a3842008 upstream.

The cp2615 driver uses the USB device serial string as the i2c adapter
name but does not make sure that the string exists.

Verify that the device has a serial number before accessing it to avoid
triggering a NULL-pointer dereference (e.g. with malicious devices).

Fixes: 4a7695429ead ("i2c: cp2615: add i2c driver for Silicon Labs' CP2615 Digital Audio Bridge")
Cc: stable@vger.kernel.org	# 5.13
Cc: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Bence Csókás <bence98@sch.bme.hu>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260309075016.25612-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-cp2615.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-cp2615.c
+++ b/drivers/i2c/busses/i2c-cp2615.c
@@ -298,6 +298,9 @@ cp2615_i2c_probe(struct usb_interface *u
 	if (!adap)
 		return -ENOMEM;
 
+	if (!usbdev->serial)
+		return -EINVAL;
+
 	strscpy(adap->name, usbdev->serial, sizeof(adap->name));
 	adap->owner = THIS_MODULE;
 	adap->dev.parent = &usbif->dev;


