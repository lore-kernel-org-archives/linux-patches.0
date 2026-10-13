Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB5E4FD279;
	Tue, 13 Oct 2026 12:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895271; cv=none; b=IJzDRCD6Lica12Ug/thjC8Cnu68y2BtIwNuvQ8GfVGgLqvn8Mqw+YMzgaqrdVgTmX9aOf42hqqIAcKZ5quhIBNPIEZ9hBM6zwZAolTILhzwieDWXguY6AYPJJAUYYFmK1YxNgVoihEGpnhRRHgs88bU4IMbY7gumsEVF4f7FBVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895271; c=relaxed/simple;
	bh=0uwBjXZrO9Rz7BgnxdFsXxIwIsFIauFoUG294PfPMTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZyyxeRnJGykC7eEDEy13zB/+uUbavbAKpvG4V/096IX4yqb7YZ1vPT8SHDAh43uHB3jPsaxsIZO1YJtjGGLC8/0twKsiBOdvHsXytodNlgTPh7so0dhC9hdGWR5DEGi6oTePF9fvmFbBdgYVrP+8icvb2yiSr9v3jiRf4c2LO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzDpzRNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzDpzRNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE11F000FF;
	Tue, 13 Oct 2026 12:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895270;
	bh=hmYglSTN7pwUpIgz+LDWKdFyYyKYwH34kO4rOemnZck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzDpzRNq2qe26QUZkElPn9VjXrSnJsw+yeS0LiF+ptXQExARdmHsIjbJPltuLdKQn
	 EL6AFoNH76TwiDyAe3owroUm/KPVnxfSXml4gDIg36wDChNKfD/PUuBfA8C9aUbvyH
	 0cB8g78iNZlUG4SBuduaGjabMxkDf2z+ObiSbAS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 217/497] USB: serial: fix dynamic id driver deregistration race
Date: Tue, 13 Oct 2026 13:36:24 +0200
Message-ID: <20261013112913.045314046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 63594e8ffe097bc0b7639936f33799a7653dded2 upstream.

Only free the dynamic ids after having deregistered the driver and
removed the "new_id" attribute to avoid leaking any id added by a racing
write to the attribute.

Fixes: 93bacefc4cc0 ("USB serial: add dynamic id support to usb-serial core")
Cc: stable@vger.kernel.org	# 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -165,7 +165,7 @@ int usb_serial_bus_register(struct usb_s
 
 void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 {
-	free_dynids(driver);
 	driver_unregister(&driver->driver);
+	free_dynids(driver);
 }
 


