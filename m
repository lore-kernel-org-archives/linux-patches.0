Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1898BEC;
	Mon, 18 Aug 2025 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522690; cv=none; b=a0w2NgotFcYTd4F66/NtAMXvi0UJ07t3sUZ50vjRjhy2ffrLMmk7ULBMKFuo9qVENtqlKP+9zEWDSbk+qh/9qLcSvhbBjOfwicnR9uGI9pWscbuXHyiwSFSfmI5GPqtqfpHPBNXxiy7ditzVxQbIGc3uxaT7yzCzOjlanPc6dt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522690; c=relaxed/simple;
	bh=JBfrEdOq/e3b69O2efy+OfgHu+8DF+LkEvqqqVFyPbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek25rf0VCGhaXJf6cOnIo5WuO+ZVimslyr8f6Jkf68XTt2rAbd+uJgRtGngCP35zjntat0V151C9dOrkQ76GUCkmk4UBj6W2S9Vk/hnohgPnMtJU+ZeKxMQr9QN65kcD6KCV3pFRr3BRrORs2yJxK7ft1s5d8s2LQJ8arECA1rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR0bq2ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR0bq2ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF344C4CEEB;
	Mon, 18 Aug 2025 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522690;
	bh=JBfrEdOq/e3b69O2efy+OfgHu+8DF+LkEvqqqVFyPbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR0bq2adPJvHc+oLICBKN6+e5fFpYkDNi7ZWundK/nEdRPGQxwolgbX59K9TwC7QJ
	 KKmpSrj2h2yFV071XeCYRZjeZmYseQ1/qnb5ffJfH42EAul+hPLYa0ammANuO+DJt/
	 tjILj/dJ3JGN7yglOCnsgkFBiNGgY9xnMaD/J028=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 390/444] cdc-acm: fix race between initial clearing halt and open
Date: Mon, 18 Aug 2025 14:46:56 +0200
Message-ID: <20250818124503.525158936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


