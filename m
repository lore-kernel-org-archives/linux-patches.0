Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A952857D2;
	Tue, 26 Aug 2025 13:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214811; cv=none; b=NXv0P5ED7M3n/MvRl/o1DUTEJF+JpMytrfzi+RiNKhvI0IC0+gJ+7GyGScXLE6bbjcxqZWX70351AhMDHTeZZZs3NFErY1hj+cYSGtsMbdzvpzCI8oq2m+0KTPcIin9dyb2bNfRh4Or0I3503ESLACwr62JojA19+apHr8oHZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214811; c=relaxed/simple;
	bh=mZrVOWj6SxNyhScPPCq57GCxnUu5hpjNbXSpdgnC+1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIpC7Ir3ShbjXICBAUMme39Bn9852t78cSGpebBakkzFLrAjns03sbS2d1kvXzznP32NIsdfHHoxq9j0oogxujpo/7qfH/d8ONCVNouuB3oqO9Wax/6Ecjf8oBAqkQSgkfLOX5TzYtZ3t/ewjSP0Pb7CHOHVCrzYGkk8DfYPNRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIKlemnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIKlemnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15125C113CF;
	Tue, 26 Aug 2025 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214811;
	bh=mZrVOWj6SxNyhScPPCq57GCxnUu5hpjNbXSpdgnC+1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIKlemnq0SHUdUO9JrW3pp205P66my1AYTTZRIwV8sZHQXiLCfZGNYBf5pczQb3be
	 d/OWQm2fmWvNAPW9KIMccgNwqjWGCPchJksQ/bVIRv7PmxWwjnoYXtUEw4et/+SPfp
	 dgJ+NXPTvDtkJzDeShW8CPqPawIMGKcaZVEsAZh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 251/482] cdc-acm: fix race between initial clearing halt and open
Date: Tue, 26 Aug 2025 13:08:24 +0200
Message-ID: <20250826110936.969045813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1496,6 +1496,12 @@ skip_countries:
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
@@ -1503,11 +1509,6 @@ skip_countries:
 		goto err_release_data_interface;
 	}
 
-	if (quirks & CLEAR_HALT_CONDITIONS) {
-		usb_clear_halt(usb_dev, acm->in);
-		usb_clear_halt(usb_dev, acm->out);
-	}
-
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
 	return 0;


