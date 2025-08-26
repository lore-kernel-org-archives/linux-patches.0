Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3C82BEC45;
	Tue, 26 Aug 2025 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216530; cv=none; b=C0U0WZ/BJa0aKKeAmBtghrkPguBi9Gq/OHzpwMT7y2iV2avxWwQVl2BIyb0HzjdF/u1OH84eGjCAwE8sluaaj9frKsokV7OutmGDuz4W7xbtYPt0/UxNw9wYcrSD95XBft9HZcPyETo463usmsqtao9bOwVXGfv25laNAbnQpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216530; c=relaxed/simple;
	bh=rS+fr9WjJ2KCfaTPzdRPLAoqkqNafROlW6FU0E/o+4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJN5MiMORXnfsM4krgRu/3ZozOQphJ+znHSXvcS49wvHCY56CwEBMTuK2Zd4yAnnqZN3eZwpYzoD21/FWoUpbG0yF4XBOa0cQs/uTu/37Qg8z9vkUKBc4pG5KslxRyxvYPybfG89JdTqz2k/DBk3qnPZ/ssQKCfr8+k3UJDyOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYpBIRtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYpBIRtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7CAC4CEF1;
	Tue, 26 Aug 2025 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216530;
	bh=rS+fr9WjJ2KCfaTPzdRPLAoqkqNafROlW6FU0E/o+4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYpBIRtdMe4KVIH29KgKOYQhPGAx9nClWLPV3uukueWFAff2SUfZHYGFOrvPAESEf
	 duikjS6TfE4lgGMzZGLjiVDaBd22eOkFBj9feA7b6fRQndoO2ZwOwcRD6vsFsgjms9
	 FU6dFcjnMDSXd94d4FKvCQc1hvlcJEBgG4qU5b6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 446/644] cdc-acm: fix race between initial clearing halt and open
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826110957.519811441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 64690a90cd7c6db16d3af8616be1f4bf8d492850 upstream.

On the devices that need their endpoints to get an
initial clear_halt, this needs to be done before
the devices can be opened. That means it needs to be
before the devices are registered.

Fixes: 15bf722e6f6c0 ("cdc-acm: Add support of ATOL FPrint fiscal printers")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250717141259.2345605-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1500,6 +1500,12 @@ skip_countries:
 			goto err_remove_files;
 	}
 
+	if (quirks & CLEAR_HALT_CONDITIONS) {
+		/* errors intentionally ignored */
+		usb_clear_halt(usb_dev, acm->in);
+		usb_clear_halt(usb_dev, acm->out);
+	}
+
 	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {
@@ -1507,11 +1513,6 @@ skip_countries:
 		goto err_release_data_interface;
 	}
 
-	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, acm->in);
-		usb_clear_halt(usb_dev, acm->out);
-	}
-
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
 	return 0;


