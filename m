Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC8F494807;
	Mon, 31 Aug 2026 14:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185165; cv=none; b=mIWhBUKwf0nKG/vwQ305ghTv+kxRog/zV25ZGYyY2R2VPtXsrrSIkcA707VuKO4wS/wpDHmQHGrlp6SJuguQpE2tVO49/TakgTIUH1yt1+Aj3Kd4l+ojrZu4HyPO1f2UlJ7UZUpVMsxslxRngEsX/WaliNhwgVTnLUUN6jw4dH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185165; c=relaxed/simple;
	bh=uPz/QihLj1b10N1w1gL+drDzwzY56IVz7zQgyXHaPOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rj6wtO1JgAgesSMCp5sAl/u9BW2bFNh2Mn6QlNKb3TwdatGJr3ctj+H9JcQtd7KASNsir21nO51DzWpvNXIPsuFM6RoItqGT+r/OpD1aQmusRVCwU+OlVhZ22PFEeuPkXTJc1d4Qc7rq/nu+FGQC7AuAcW05SNZhM+v2eT8ch4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWgAsKTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWgAsKTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA371F000E9;
	Mon, 31 Aug 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185164;
	bh=YWbbl7BUmUAb8mW6C6kIuxVhWdJLiSyse2ntLVE6ryk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWgAsKTu7+XtJjaBrvleamqs5dMKs8Y1M9TOViDKnlK77XZ8D/NY5IdDDExtqnr0m
	 hrzDDg8AUkP0cxUCva6AFIoOP1dEXYEJxX7ukYBc/uB6GAbBaQTXL+BJB2isns1zG7
	 sfGzYi2PFmbVrNz+pHJSXsHCySRfZflp/CgNq/20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miguel=20Pe=C3=B1aranda?= <mig.penaranda07@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 69/69] usb: usbfs: fix use-after-free of usb_device in usbdev_release()
Date: Mon, 31 Aug 2026 15:35:42 +0200
Message-ID: <20260831133402.202024907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Peñaranda <mig.penaranda07@gmail.com>

commit 0dd68b5d01d022fc9c5e71c82a82b0a94d3d0671 upstream.

usbdev_release() drops its reference to the struct usb_device before
draining the list of completed async URBs, but that drain path reads back
through the same object: free_async() calls dec_usb_memory_use_count()
for any URB whose buffer came from the usbfs mmap() region, and its first
statement is bus_to_hcd(ps->dev->bus).

After a disconnect the usbfs reference can be the last one, in which case
usb_put_dev() frees the device and the subsequent loop reads offset 80 of
freed memory and uses the result as a struct usb_hcd *, which
hcd_buffer_free_pages() then dereferences.

This is reachable by an unprivileged process that has read/write access to
a /dev/bus/usb node: mmap() the fd, submit one URB with a buffer inside the
mapping, wait for the device to be unplugged, then munmap() and close().
It reproduces on every attempt rather than being a race, because a live
MAP_SHARED vma holds a reference on the struct file, so usbdev_release()
cannot run until the last vma is gone and the freeing branch of
dec_usb_memory_use_count() is always taken.

  BUG: KASAN: slab-use-after-free in dec_usb_memory_use_count+0x3ae/0x410
  Read of size 8 at addr ffff8880122ee050 by task poc/769
  CPU: 1 UID: 1000 PID: 769 Comm: poc Tainted: G    B    6.12.94 #3

  Call Trace:
   dec_usb_memory_use_count+0x3ae/0x410
   free_async+0x2aa/0x4f0
   usbdev_release+0x375/0x460
   __fput+0x3ea/0xb50
   __x64_sys_close+0x86/0x100

  Allocated by task 11:
   usb_alloc_dev+0x55/0xd90
   hub_event+0x2524/0x43d0

  Freed by task 769:
   kfree+0x121/0x360
   device_release+0xd2/0x280
   usb_put_dev+0x23/0x30
   usbdev_release+0x2d8/0x460

Release the device reference after the drain loop instead. Nothing between
the two points requires it to have been dropped.

Fixes: f7d34b445abc ("USB: Add support for usbfs zerocopy.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Miguel Peñaranda <mig.penaranda07@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260810121209.795089-1-mig.penaranda07@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1099,7 +1099,6 @@ static int usbdev_release(struct inode *
 	if (!ps->suspend_allowed)
 		usb_autosuspend_device(dev);
 	usb_unlock_device(dev);
-	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
 	put_cred(ps->cred);
 
@@ -1108,6 +1107,7 @@ static int usbdev_release(struct inode *
 		free_async(as);
 		as = async_getcompleted(ps);
 	}
+	usb_put_dev(dev);
 
 	kfree(ps);
 	return 0;


