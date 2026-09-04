Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDA415F29;
	Fri,  4 Sep 2026 06:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502212; cv=none; b=IGqSo/XEetA0RrVeDu8mJwaEbgSQ46dIM1W1V8eU9jrD2ckSuaqn3dx/Jh+1obV/NDZBh9CNjUJytdqyIcGEXZGkcGal+T1hrar2iEtKBNDj9BGF6o3gAEMUf3Jtotkyc2mPbFwOckYAoCwKSSbVzzXuyaiVfjFx2Lb7mtPoEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502212; c=relaxed/simple;
	bh=/1ksAtMuHl/7Fg7G16/PDk9R1TNX7HbehWTH02p0mZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjz5FoX2zaCqo/MuYIRg7NZKPZ9mRAtyG+tWL5dfxJBIo7jDDhpNJUubdh3fueqBEMTqKgTf2P45PTIU19BUsmGbH6souEqnr5GVBBGievyDSexyOA0H/HqKj8qdOqK2EL4hOMpb5kpu8uPwokAlkuHvL8h/RIzXnCo1b/MfqO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDUGjbKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDUGjbKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55EB1F00A3D;
	Fri,  4 Sep 2026 06:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502211;
	bh=tBxVq88M/jkljacN5I57oxsc9HKDu8iD1cSy2aD7sPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDUGjbKBCFDNA14kqYCeYkvTw3JdoCuYZB9Y4m7hoUxdT675zE5sWbLRoF/YPka/o
	 Ns89ZvLG895/ryNrJFuMiEE1qkToH6FjjLgggb8iSUclTFZEPdeHp91n5GErJ8v9fs
	 adNZb/zr6s0A5zeTBRjWgBh7+QALrehE8Y+Kejns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 126/403] HID: roccat: free buffered reports when destroying device
Date: Fri,  4 Sep 2026 06:58:49 +0200
Message-ID: <20260904045737.703571198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


