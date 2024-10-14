Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C441ABEC1;
	Mon, 14 Oct 2024 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920032; cv=none; b=krZnTMsJhBx3Q3e0bWk+JFzZreFEEBo0XwBALICLGgjbM1fCwzrtLxezyBRpR8NzrOKacdwhJC8qplkJTDqkkeV7JVhS+YeijcdquvPhZJb3dr4VOvyJjOvYaFKp0Z2GW4dQYPcC0svDo5xEkaf82G2W814aspZIIlEJ6RcW5ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920032; c=relaxed/simple;
	bh=orEDQybkGHXN6ECHtK2bn9P4u8EjN6ucBp19wGdJ5fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMwyYwmaImJqvX8ZP3T+WVufnNcxZSluQ7l/Nl0pShfv1pQfhnQ2nW2aHzXfnupFiSxgNRG/oHW41rI3WmRVKW37b1vIigrkW+xSeOm5CdAqVtCaM6fsAAyo74TCkIcbj4vdcHHXsL1z7L2XDnZcZnEAxID+vPA8elnonYXNq0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JM4d4G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JM4d4G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C25AC4CEC7;
	Mon, 14 Oct 2024 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920032;
	bh=orEDQybkGHXN6ECHtK2bn9P4u8EjN6ucBp19wGdJ5fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JM4d4G77nfboxSCwmrqw0LMJOMkEVOhR0iFm1y9JuywHj6gieZO9cGAJS8/Ol9cF
	 zHrrUjjvU07AaiQQCCfL/9uXKnrG9DcmKlDjKZWQDyv35UbmC6U6biwq3VqetBaLSG
	 MEuOYjqrmzd8LnsSCdlhbDLd63RbZ3Lybbeeu2zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.1 779/798] usb: gadget: core: force synchronous registration
Date: Mon, 14 Oct 2024 16:22:13 +0200
Message-ID: <20241014141248.668427060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

commit df9158826b00e53f42c67d62c887a84490d80a0a upstream.

Registering a gadget driver is expected to complete synchronously and
immediately after calling driver_register() this function checks that
the driver has bound so as to return an error.

Set PROBE_FORCE_SYNCHRONOUS to ensure this is the case even when
asynchronous probing is set as the default.

Fixes: fc274c1e99731 ("USB: gadget: Add a new bus for gadgets")
Cc: stable@vger.kernel.org
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20240913102325.2826261-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1671,6 +1671,7 @@ int usb_gadget_register_driver_owner(str
 	driver->driver.bus = &gadget_bus_type;
 	driver->driver.owner = owner;
 	driver->driver.mod_name = mod_name;
+	driver->driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 	ret = driver_register(&driver->driver);
 	if (ret) {
 		pr_warn("%s: driver registration failed: %d\n",


