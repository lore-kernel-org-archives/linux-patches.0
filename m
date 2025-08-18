Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503F02E22B0;
	Mon, 18 Aug 2025 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526293; cv=none; b=pBbOfYLmy522O1vjYLmDmJHRfqsCWAjeb7nlptUuVFxdVAHs5rcP09h3aB2kebMfIKfh8X3nprcuYM4SZab5HMol9cElo47lVL5XFlWGn23tNviD1CYuZhUomG5ME2iDJpiy90wo1AWdll7TfpYNtZcp7hjQOlZ66yOoytVq8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526293; c=relaxed/simple;
	bh=xWbveJ6YuCRD9z8OGGCl7cMAj1UrvvRyP62547fJCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjqclnFRAv5WOYwVqToApXeEOCFywU88nJYBM2bz0RKTDMPMWskZJqnIM2PUvKV/AD6y8Ko+3vgxMfxj2Dk0QKwCyGZZimO1/eCoDjiTliD4fwNqLMYflYyYYuBIRxIDljIAJTaPVWIO3NHeWDHqEOTMIQfhSJdteiHaySp2dJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5PQVkqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5PQVkqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF287C4CEEB;
	Mon, 18 Aug 2025 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526293;
	bh=xWbveJ6YuCRD9z8OGGCl7cMAj1UrvvRyP62547fJCrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5PQVkqfGU0E6olQTA44/skE8R11+2wC1g238OisHYzEDl8COs+uvx0GlUSA4nzTw
	 nPpE3Cu4qX4zbgRrjBrerP70XlyOABXSIBgoyfZiCGe+GvQjfYn7+urYDNSJjD1zWu
	 K8EDOHtMDp9RexzQBKkpvy54U4Xzgwz3jGFggsqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.16 511/570] cdc-acm: fix race between initial clearing halt and open
Date: Mon, 18 Aug 2025 14:48:18 +0200
Message-ID: <20250818124525.542847923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1520,6 +1520,12 @@ skip_countries:
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
@@ -1527,11 +1533,6 @@ skip_countries:
 		goto err_release_data_interface;
 	}
 
-	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, acm->in);
-		usb_clear_halt(usb_dev, acm->out);
-	}
-
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
 	return 0;


