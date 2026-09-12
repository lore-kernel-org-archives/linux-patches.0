Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DDF41A508;
	Sat, 12 Sep 2026 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219983; cv=none; b=Z5QEF1Cbp72c4+NhaywJRVZy4sWozQkZBoJrI1h2Qsj3UQ8RFl8JjEYW69bV6MjlUqZBkFs7nHU+21b9eLnW1JdqCtwqHaq2yhvNO/vDnkVyL5g6SJeLK31WgQfJEYEdkQ8ncBiOD104ehJzgET8CnsdQrg2kNcNdMr6keoScb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219983; c=relaxed/simple;
	bh=iJE4VYcNV1hADfKvh1px8IWqhmMQ3B+Qs+KLAZKuDAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYJRqalUifQnRzEo/TcbNaVu8K0odEPRQMgKr38MOMAp2IH2bsqraEzbYv2F4EVuaYvYOSpKFYdnmZsdIcCUr1WAfeFyX/P7dziu4mWMcp35i/eY+bChYOTK+f15aKytJvQ2dSIAeluaWEFU+jWZvFz2qtsgaDxRjkYGSCWICbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7DYLmS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7DYLmS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322AA1F000FF;
	Sat, 12 Sep 2026 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219982;
	bh=8LCme8TwX/gUr9qViQQiAqMVhrr051eL2jpzciXUtBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7DYLmS15lblU48AYoQYRZHe250AvFN+6Pus0kmhcfR7R0MNp+fKu02FKwqOr9gBz
	 jVekjSOu77f30+YkdhdKlDF6upBhsWQsLEDg2hBUNPhHYqJJ2Sbx7T+BGrl8Eowir7
	 HjdHmkiknRUblXrQW/CGV8ctFh6giNxvO4t6ZBzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0085/1424] HID: roccat: free buffered reports when destroying device
Date: Sat, 12 Sep 2026 08:41:57 +0200
Message-ID: <20260912065609.210510533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


