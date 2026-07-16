Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8E93FF1BC;
	Thu, 16 Jul 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211123; cv=none; b=mwmDhzl7MfA8hxMTpLGTzA0hkoOJXIj/IXhh5rXvQUAcN2S8ClMdAvDYUq3hTgcp8KrQnvtgpZ1uowUP0aHHxRcVDD6W4t/lu6U32gr5PMqHsVGXnep4xBMJmtrpsx9kg/u51imTwdib9j/VA+0CQP7IafXuPc3uj7oXpfD/5Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211123; c=relaxed/simple;
	bh=5P/pu1S+DG6WwzOFH1+tNg6iWhoRH5ytfNOImqgidRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBqtmkL/7oPADvoKFYuxmuIxLThgLZSDbnpiTM3kYgWV/skREgwEe8jvrkK6hknD8cav8pss+2zvf0wnCOblDa5/o+8PP62hg0b5aj7uRabw2GL5s/TfclH+Ipily0Q2yMP0reN4OAXp7Tvl2b21daDIMkNGNaeAbT5zwRTf+rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jD3n3SUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jD3n3SUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18E51F000E9;
	Thu, 16 Jul 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211122;
	bh=cHJBwJ2Jddop0CgKpE7F2x4r9dSk2XX024kKLiwXFAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jD3n3SUT72RQXOyBSiCNtClazPAmkYK7Nof28E4lubsGi+SLBClEdpi+e/PRrIcGL
	 a4M9kVoPUWuDAh+oi6dFZ978eHLwK6hJJSlnpMREXh/BHShxtTwPYUmNqyvBiBi3iR
	 MsMCTxyOXjBHn+BO4hY1v5FqCpaFshRKvqAhl5Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 307/480] USB: ulpi: fix memory leak on registration failure
Date: Thu, 16 Jul 2026 15:30:54 +0200
Message-ID: <20260716133051.461260294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8af6812795869a66e9b26044f455b13deecdb69c upstream.

The allocated device name is never freed on early ULPI device
registration failures.

Fix this by initialising the device structure earlier and releasing the
initial reference whenever registration fails.

Fixes: 289fcff4bcdb ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260608145803.69360-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -281,28 +281,24 @@ static int ulpi_register(struct device *
 	ulpi->dev.parent = dev; /* needed early for ops */
 	ulpi->dev.bus = &ulpi_bus;
 	ulpi->dev.type = &ulpi_dev_type;
+
+	device_initialize(&ulpi->dev);
+
 	dev_set_name(&ulpi->dev, "%s.ulpi", dev_name(dev));
 
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
 	ret = ulpi_read_id(ulpi);
-	if (ret) {
-		of_node_put(ulpi->dev.of_node);
-		kfree(ulpi);
+	if (ret)
 		return ret;
-	}
 
-	ret = device_register(&ulpi->dev);
-	if (ret) {
-		put_device(&ulpi->dev);
+	ret = device_add(&ulpi->dev);
+	if (ret)
 		return ret;
-	}
 
 	root = debugfs_create_dir(dev_name(&ulpi->dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
@@ -334,9 +330,10 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret)
+	if (ret) {
+		put_device(&ulpi->dev);
 		return ERR_PTR(ret);
-
+	}
 
 	return ulpi;
 }


