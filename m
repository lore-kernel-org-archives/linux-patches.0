Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E177B3F4DE2;
	Sat, 12 Sep 2026 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226895; cv=none; b=F1rpgyJCuzDKt8HyPYLFtejGYClhQrR8vGI0YFURfM3fDL8sJmdpw44vMnEvMrmHXjK7aJvWIjN7PP2cNKmpjPqeRLklkt147tI+D8o2zAVfX+jeak1266EgMX7fFvqPz79R+W5El32LpxMiTGmCeaG1bNBt90O+xH1e2yTdhqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226895; c=relaxed/simple;
	bh=TkTwP85g//qrpEV3R2BfiMts4SCvQbn0+0Q2ysNKQR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnChFX6A/0GtjxC9lba7i928RAULfzylfDBGhVSQ2O8/kxZBxac7zmfiQRdgqnXVNE2VIzUcRaZ8plp00BcApKYthNLx0Jv4FcgsgA+VBJORDiTGI0yH/1Ik9ZY/HuHC+esGfMC2snzvt0eVSaOg9qrP7aoAGPaqFB6eklm57h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJv7mogD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJv7mogD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B5B1F000FF;
	Sat, 12 Sep 2026 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226893;
	bh=AobFYQjLKxX6Z1EBXrcgRnpwyvwewLGhYTUF/VedeCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJv7mogDaSZZf7CO86SPunEkrnp0Py/ZLUPx+aYLYL6fwdap3IjKzgXApAzZReU0n
	 6NBSNAUqroq68hy4ITPOgxgItdIlpZoMdol4qsSu6efmhP9CG7sDLjCf6Gyv+bvJi6
	 cN8OYcKRzozr0S44qTGcjWEHxFfeaTLhs5DXqCPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0071/1191] HID: roccat: free buffered reports when destroying device
Date: Sat, 12 Sep 2026 08:46:39 +0200
Message-ID: <20260912065549.755046404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


