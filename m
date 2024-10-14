Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7701014A614;
	Mon, 14 Oct 2024 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916489; cv=none; b=NQqUfIzSKPFQnatR+rj+085A8gPml+ci36ZEpsdS/7tiTlcC3fWasSWMAYm/1rZPYo0hhp5mXNN6ioCAuMVu3JGHxiUFY5zzjN2TxoZd2V8dJLYyhYKFR2rZEBFfT3293RRgclKNtb1N7n17LRfEtmBLBbMlRZHfoiQ0+1BC/nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916489; c=relaxed/simple;
	bh=QgXgV/F1bVP6byyki1zaAhDcvfAsr1ENNhTDH4VilKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icCtMT4RZ/RFaIFDaop+eH8Y6hgoheJ4mM7l+oFw5Jno3SR4DFosSlmMTsqD6jUMde7b0BLYzZIK3kNFLy0XcmU5sZ2SERIc3QSmu0f+1fUFHgBlxjrUuoqNnsEivmzbLN/OP7sxCakASz2JwogD7dF05vF9hSE77Y09DKnC4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdjINK48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdjINK48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9920C4CEC3;
	Mon, 14 Oct 2024 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916489;
	bh=QgXgV/F1bVP6byyki1zaAhDcvfAsr1ENNhTDH4VilKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdjINK48xgx9Hd/0pM/kvsfpXjaLNk2XNbi8qcaGUpO0Ici9d6lrVMYzJy5UZROzK
	 8NVJCLWMDuLncDgNyP0qa8nFRcTCGdPiGOl16A75ILJP7qzQtwbbN7CJHndTytrfxj
	 Dlwp5snzbGhYZV52XEJnxPZCiwaEXEPkz9TALyzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.11 167/214] usb: gadget: core: force synchronous registration
Date: Mon, 14 Oct 2024 16:20:30 +0200
Message-ID: <20241014141051.498767264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1696,6 +1696,7 @@ int usb_gadget_register_driver_owner(str
 	driver->driver.bus = &gadget_bus_type;
 	driver->driver.owner = owner;
 	driver->driver.mod_name = mod_name;
+	driver->driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 	ret = driver_register(&driver->driver);
 	if (ret) {
 		pr_warn("%s: driver registration failed: %d\n",


