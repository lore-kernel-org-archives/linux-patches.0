Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56C8395266;
	Fri,  4 Sep 2026 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500777; cv=none; b=ZhJEaicODyHW2F/FIShS6xItuduHqpa30ij3xvgbc+9dVNZw8nHuMeOlV9eRdwgSxVYcWlkCohQJ8ej4dx3VYmez+4kTVyPqSQ2ZWzuo2jLfPNRGtM1kM8iUYYHeQbo3EPMIYEYjh17faaTbEIiD/wNOeGLK1bBILySZ5SSxCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500777; c=relaxed/simple;
	bh=NmHcthi8ueaWoKL8W2qS4ggTG7R13hAik5fAcmtErXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRUNaBokhO+G/WvCFnZu3a+EEuaZZYG9Wv7gaXX3mSfikIRmRsUbQPqzpN1KDS/bJ/jg0o29V/9qio0Gs99VECnl3rSMj0u3abBZLli4h6BUrYdeS4PpV0ce7tvQRYsvMrzo3zf879hBy2/GKG2rToXtvqMhhyy+u+9/v8YKBAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwjspTJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwjspTJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1123D1F00A3D;
	Fri,  4 Sep 2026 05:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500776;
	bh=iwo+TIB6EYKN+yp4K8G28brDmwNUVJlnEJV8g+w3m9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwjspTJwM3DH3m4VLBFOWsn7GQZ3U5RmdkAIZ4UgVgH5Hgs+ffq/OI3I4nOxOuN+1
	 y7vqMh4n3JBE1trhXTjdcG0ivRx99n1bDRyOzZR/jFIJYIg41gH6aFqdMaoxcgjCu1
	 Fe/6X7HFBjqrfD5kkoeW0aWZLtoYah3IIIv4ub+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 177/552] HID: roccat: free buffered reports when destroying device
Date: Fri,  4 Sep 2026 06:55:34 +0200
Message-ID: <20260904045753.033476540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit bbff0ccbff360a5498075525005f6a913239a3d7 upstream.

roccat_report_event() duplicates each report with kmemdup() and stores
the allocation in a circular-buffer slot. The allocation is released only
when that slot is reused.

The device destruction paths free struct roccat_device without releasing
reports still stored in cbuf[]. This makes those allocations unreachable
and leaks up to ROCCAT_CBUF_SIZE report buffers per device.

Add a small destructor that frees every buffered report before freeing the
device, and use it in both paths that can destroy a registered device.

Fixes: 206f5f2fcb5f ("HID: roccat: propagate special events of roccat hardware to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -70,6 +70,15 @@ static struct roccat_device *devices[ROC
 /* protects modifications of devices array */
 static DEFINE_MUTEX(devices_lock);
 
+static void roccat_free_device(struct roccat_device *device)
+{
+	int i;
+
+	for (i = 0; i < ROCCAT_CBUF_SIZE; i++)
+		kfree(device->cbuf[i].value);
+	kfree(device);
+}
+
 static ssize_t roccat_read(struct file *file, char __user *buffer,
 		size_t count, loff_t *ppos)
 {
@@ -226,7 +235,7 @@ static int roccat_release(struct inode *
 			hid_hw_power(device->hid, PM_HINT_NORMAL);
 			hid_hw_close(device->hid);
 		} else {
-			kfree(device);
+			roccat_free_device(device);
 		}
 	}
 
@@ -374,7 +383,7 @@ void roccat_disconnect(int minor)
 		hid_hw_close(device->hid);
 		wake_up_interruptible(&device->wait);
 	} else {
-		kfree(device);
+		roccat_free_device(device);
 	}
 }
 EXPORT_SYMBOL_GPL(roccat_disconnect);


