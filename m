Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B5C35335B;
	Tue, 26 Aug 2025 14:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218232; cv=none; b=Ecr25M9QUoPU5c9vC6vP7szOEeZtyimgRxvF7c7GcjtQUElurfbKZVif4QeNqselpd7UzFbyRW3lfuBToFT335uxFIR4LhSYFLPEQjZo85hJsQm6KcT8fLNkL5BOY2DBCjMpqTUlCXLlXJW/9a7MbEW0uB9mBkdTbM/7/tHbsCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218232; c=relaxed/simple;
	bh=E+iGdNKPltJjBOuYYrrqnk+QHlOFN7xqxzdXlWXowOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSl1mM5GX8dOvoQPdq+FctnbfonOyr4SqPj29xuPdQPA+25em2Y/4RiYAe5vtKbQXh8kCYgeBMPmLDph5A2zE2Ite5YZGmeCE07xbYN9cKpHm5WxOCU0kYZPeQTzHG26nFFhT9ZvoSbqUbXlgpYD6BmwOAj1ZRuS6+92U/KmUnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0Ymyjtl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0Ymyjtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77DC113CF;
	Tue, 26 Aug 2025 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218232;
	bh=E+iGdNKPltJjBOuYYrrqnk+QHlOFN7xqxzdXlWXowOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0YmyjtlVy1ikVZKcdYIoagL10ue6KGjxrR85zYonCYSQ+jPn5SRrB2jp/e6r5OBP
	 n9yI2QNLlobwDCl/N93RTJPZCJ8ID+SZT8AE+O9neqsfmeo4VuXU0mYa1LGm/rIkW1
	 po5a9kAyivujefePqI7X32VYXI1/fORS8kVLuC4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/523] cdc-acm: fix race between initial clearing halt and open
Date: Tue, 26 Aug 2025 13:10:46 +0200
Message-ID: <20250826110935.209432826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 64690a90cd7c6db16d3af8616be1f4bf8d492850 ]

On the devices that need their endpoints to get an
initial clear_halt, this needs to be done before
the devices can be opened. That means it needs to be
before the devices are registered.

Fixes: 15bf722e6f6c0 ("cdc-acm: Add support of ATOL FPrint fiscal printers")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250717141259.2345605-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1517,6 +1517,12 @@ skip_countries:
 	usb_driver_claim_interface(&acm_driver, data_interface, acm);
 	usb_set_intfdata(data_interface, acm);
 
+	if (quirks & CLEAR_HALT_CONDITIONS) {
+		/* errors intentionally ignored */
+		usb_clear_halt(usb_dev, acm->in);
+		usb_clear_halt(usb_dev, acm->out);
+	}
+
 	tty_dev = tty_port_register_device(&acm->port, acm_tty_driver, minor,
 			&control_interface->dev);
 	if (IS_ERR(tty_dev)) {
@@ -1524,11 +1530,6 @@ skip_countries:
 		goto alloc_fail6;
 	}
 
-	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, acm->in);
-		usb_clear_halt(usb_dev, acm->out);
-	}
-
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
 	return 0;


