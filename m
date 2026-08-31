Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD4478E2C;
	Mon, 31 Aug 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184438; cv=none; b=WCrjPmL1JdtsoB0apdzLsIDbEJgP79Vb5oO6D3RRuxh3tN0A6jrUxiJK+K58H7LJDZ3tNFXBx7mtVB8AH1VXSGm04Z6sFLWbNOJfrg/attE5ts+xH57Tv7+l7GIXKMyX2718p+px7APbaTGAvjyCgKNSM2uCn1tEqOR5JuJszNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184438; c=relaxed/simple;
	bh=aisHjpeflNLfeQNWTm3rkzTGNIq45LPpNZ5uRsvSW/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJigOEmpmAf4GVxN8ysaqXA11p3jE/8YSadMPNqCg2/OH+gRj0BE568H8Xi7VVYjG4OlBRb838+/czVLaJeXbur1arc3B+ffEht/BBKWLUTxVHheHKCLEuWT4tafw2aDnMYcDG4HDjo+JS5GEeE6FwGlGCq36wWWWtgR/Qj3yng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHbhqhas; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHbhqhas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5241F000E9;
	Mon, 31 Aug 2026 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184437;
	bh=WJasz83U+dNdLqLo70JhLT2ALN2pZJCJ8Pr2JrbTV/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHbhqhasxGpTfsK8DsY/+tq70f7LNE/mPimTLvf+OPvfO3o/5RoPLrH1RGduEIwPZ
	 ygqiBfhBcDTB4LA2Lk+rq33pMlGkNQRcBZGjoyyeaAvXApkYQmr/QOVQ9NadABNOD7
	 MAQe0qfL/ZVy0OrZ3FXa109TB4wKR7DboGVIk4S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miguel=20Pe=C3=B1aranda?= <mig.penaranda07@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 99/99] usb: usbfs: fix use-after-free of usb_device in usbdev_release()
Date: Mon, 31 Aug 2026 15:35:08 +0200
Message-ID: <20260831133404.599397508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1110,7 +1110,6 @@ static int usbdev_release(struct inode *
 	if (!ps->suspend_allowed)
 		usb_autosuspend_device(dev);
 	usb_unlock_device(dev);
-	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
 	put_cred(ps->cred);
 
@@ -1119,6 +1118,7 @@ static int usbdev_release(struct inode *
 		free_async(as);
 		as = async_getcompleted(ps);
 	}
+	usb_put_dev(dev);
 
 	kfree(ps);
 	return 0;


