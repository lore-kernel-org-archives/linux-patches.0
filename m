Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09557230D0D;
	Mon, 18 Aug 2025 13:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524407; cv=none; b=iBUF6o2rBXtyZHsNImSuxIaoFb67CsXVQIOrn3VfBq7CoiTVNe0fc9OESmZLBK4MQwsPax5uQApfWow7YxatUSTifw6SUOXK5QrvUw3bq1xbcp32fkb3ePnfmOdy6GSBNnxYJZtePkbuu0k/aQs/M3mWH6HBynMZ/cIUXtqNFrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524407; c=relaxed/simple;
	bh=fOOidEfB2pUIxJp1Ix3wzyRnCW7aQ/uExEvPJ05+Z1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyVXWRu4+WaoN0zKfPoCwS6sFCFp0UdFDtPjJ8iwOICAv4WnQJHmifYjDJYa8WOWa2ZLzORBLZ87Y1JiDioENuVweUHbHBYLM15vUafSyht4BYaaIk2Xi5zCvuaAGoS+6GNdZLrXVo1NGv52HPbbwi+75KKy7hviieqSUMmkVc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0yLCae5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0yLCae5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D00C4CEEB;
	Mon, 18 Aug 2025 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524406;
	bh=fOOidEfB2pUIxJp1Ix3wzyRnCW7aQ/uExEvPJ05+Z1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0yLCae5HvuHIBzddfph25/0NjOhcqYEG463f0kWqm3h0zwcDxiKoKkivRQjYxyZY
	 9kqr13JtJHR1fH2yd0osjw9uAxaYwqvdLaIOwjnKUU0oHR3VOgCKdZkbhX+XeBgiYQ
	 mOVBP3GnJ0cBzXq65XfzEjoIPVMZPxdnw/tZuJsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.15 461/515] cdc-acm: fix race between initial clearing halt and open
Date: Mon, 18 Aug 2025 14:47:27 +0200
Message-ID: <20250818124516.166568480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


