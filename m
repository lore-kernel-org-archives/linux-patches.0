Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81461BF7E5;
	Wed, 20 Nov 2024 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107703; cv=none; b=QpHy9qv/TnwUITANfzRvVmsLFSdfpAF/B0IJ+d8UtGH5yapeLfjWkSRnJn3cTUcHPo9NlKCeGd3ERqJ/kt2gdq4jZjl81llPibII9Yw3RL9v6JwcsbW3P+DpR4s/zeDVGGLVtdDVKjhr3qyMmy9N7C6l3F+rTn8XBtIFqE6M0Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107703; c=relaxed/simple;
	bh=d4fV1jNN2u0PdSRzi50/MYHLO3gh3lq1RJo8am/c6CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmxTvWqKFV3XPPaCThdTcjCFOeipQa7GFLYVaZr5477z8LfxzQP1w0k15PFNGRH5CVc4RapabVtZ1iZXcuuN5nf8fKJ2imvvGGocwxFmT7U/W7x5/f8NqvKmLdylpdNUtmz91CslvEP4Z2cTVeFEgLlDZmYi1jMKgSMJeSQ0YM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11GXTXkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11GXTXkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8782BC4CED1;
	Wed, 20 Nov 2024 13:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107703;
	bh=d4fV1jNN2u0PdSRzi50/MYHLO3gh3lq1RJo8am/c6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11GXTXkAvWExxmCcoOaFxutHNpPAdmewTbmPHEX8FiNiqHlhJ4SLTWxvKCBWt8QqE
	 l/Tfx8j34uYL5R+gdqCtER4ojqIX0zJL8eEiu13hT8zxw6mxGVm0D6AejxdfEEb6Rf
	 o5yKf0Pv2CK+x3tgg6CW31HUkPtNwFRZEwxS1xXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Eli Billauer <eli.billauer@gmail.com>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 67/73] char: xillybus: Prevent use-after-free due to race condition
Date: Wed, 20 Nov 2024 13:58:53 +0100
Message-ID: <20241120125811.217103361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eli Billauer <eli.billauer@gmail.com>

commit 282a4b71816b6076029017a7bab3a9dcee12a920 upstream.

The driver for XillyUSB devices maintains a kref reference count on each
xillyusb_dev structure, which represents a physical device. This reference
count reaches zero when the device has been disconnected and there are no
open file descriptors that are related to the device. When this occurs,
kref_put() calls cleanup_dev(), which clears up the device's data,
including the structure itself.

However, when xillyusb_open() is called, this reference count becomes
tricky: This function needs to obtain the xillyusb_dev structure that
relates to the inode's major and minor (as there can be several such).
xillybus_find_inode() (which is defined in xillybus_class.c) is called
for this purpose. xillybus_find_inode() holds a mutex that is global in
xillybus_class.c to protect the list of devices, and releases this
mutex before returning. As a result, nothing protects the xillyusb_dev's
reference counter from being decremented to zero before xillyusb_open()
increments it on its own behalf. Hence the structure can be freed
due to a rare race condition.

To solve this, a mutex is added. It is locked by xillyusb_open() before
the call to xillybus_find_inode() and is released only after the kref
counter has been incremented on behalf of the newly opened inode. This
protects the kref reference counters of all xillyusb_dev structs from
being decremented by xillyusb_disconnect() during this time segment, as
the call to kref_put() in this function is done with the same lock held.

There is no need to hold the lock on other calls to kref_put(), because
if xillybus_find_inode() finds a struct, xillyusb_disconnect() has not
made the call to remove it, and hence not made its call to kref_put(),
which takes place afterwards. Hence preventing xillyusb_disconnect's
call to kref_put() is enough to ensure that the reference doesn't reach
zero before it's incremented by xillyusb_open().

It would have been more natural to increment the reference count in
xillybus_find_inode() of course, however this function is also called by
Xillybus' driver for PCIe / OF, which registers a completely different
structure. Therefore, xillybus_find_inode() treats these structures as
void pointers, and accordingly can't make any changes.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20221030094209.65916-1-eli.billauer@gmail.com
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -185,6 +185,14 @@ struct xillyusb_dev {
 	struct mutex process_in_mutex; /* synchronize wakeup_all() */
 };
 
+/*
+ * kref_mutex is used in xillyusb_open() to prevent the xillyusb_dev
+ * struct from being freed during the gap between being found by
+ * xillybus_find_inode() and having its reference count incremented.
+ */
+
+static DEFINE_MUTEX(kref_mutex);
+
 /* FPGA to host opcodes */
 enum {
 	OPCODE_DATA = 0,
@@ -1234,9 +1242,16 @@ static int xillyusb_open(struct inode *i
 	int rc;
 	int index;
 
+	mutex_lock(&kref_mutex);
+
 	rc = xillybus_find_inode(inode, (void **)&xdev, &index);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&kref_mutex);
 		return rc;
+	}
+
+	kref_get(&xdev->kref);
+	mutex_unlock(&kref_mutex);
 
 	chan = &xdev->channels[index];
 	filp->private_data = chan;
@@ -1272,8 +1287,6 @@ static int xillyusb_open(struct inode *i
 	    ((filp->f_mode & FMODE_WRITE) && chan->open_for_write))
 		goto unmutex_fail;
 
-	kref_get(&xdev->kref);
-
 	if (filp->f_mode & FMODE_READ)
 		chan->open_for_read = 1;
 
@@ -1410,6 +1423,7 @@ unopen:
 	return rc;
 
 unmutex_fail:
+	kref_put(&xdev->kref, cleanup_dev);
 	mutex_unlock(&chan->lock);
 	return rc;
 }
@@ -2244,7 +2258,9 @@ static void xillyusb_disconnect(struct u
 
 	xdev->dev = NULL;
 
+	mutex_lock(&kref_mutex);
 	kref_put(&xdev->kref, cleanup_dev);
+	mutex_unlock(&kref_mutex);
 }
 
 static struct usb_driver xillyusb_driver = {


