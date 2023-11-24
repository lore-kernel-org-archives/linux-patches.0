Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D713433CCA;
	Fri, 24 Nov 2023 19:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u45skHGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BF0C433C8;
	Fri, 24 Nov 2023 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853394;
	bh=EUrY0vQZUhY2c3Y9WyGHZzWnr3KLZGb1KmkWbjKzqT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u45skHGCPZHOxVbM6B7XF7LAjAcl9Xss4uoEl1qfEqtKjlwoh+JAAtfOAWmbTS9HW
	 +ofEIFTpqzkTLTJM5EylMEIN2hsQEyN7PYjDcTDFkBf+IW65kzNRLql0iP4U0nA/ri
	 QQaTL4X1YbiHb4Eh4PZDND7V56tjSEyFgBm0ESDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 5.15 171/297] hvc/xen: fix console unplug
Date: Fri, 24 Nov 2023 17:53:33 +0000
Message-ID: <20231124172006.242354617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit a30badfd7c13fc8763a9e10c5a12ba7f81515a55 upstream.

On unplug of a Xen console, xencons_disconnect_backend() unconditionally
calls free_irq() via unbind_from_irqhandler(), causing a warning of
freeing an already-free IRQ:

(qemu) device_del con1
[   32.050919] ------------[ cut here ]------------
[   32.050942] Trying to free already-free IRQ 33
[   32.050990] WARNING: CPU: 0 PID: 51 at kernel/irq/manage.c:1895 __free_irq+0x1d4/0x330

It should be using evtchn_put() to tear down the event channel binding,
and let the Linux IRQ side of it be handled by notifier_del_irq() through
the HVC code.

On which topic... xencons_disconnect_backend() should call hvc_remove()
*first*, rather than tearing down the event channel and grant mapping
while they are in use. And then the IRQ is guaranteed to be freed by
the time it's torn down by evtchn_put().

Since evtchn_put() also closes the actual event channel, avoid calling
xenbus_free_evtchn() except in the failure path where the IRQ was not
successfully set up.

However, calling hvc_remove() at the start of xencons_disconnect_backend()
still isn't early enough. An unplug request is indicated by the backend
setting its state to XenbusStateClosing, which triggers a notification
to xencons_backend_changed(), which... does nothing except set its own
frontend state directly to XenbusStateClosed without *actually* tearing
down the HVC device or, you know, making sure it isn't actively in use.

So the backend sees the guest frontend set its state to XenbusStateClosed
and stops servicing the interrupt... and the guest spins for ever in the
domU_write_console() function waiting for the ring to drain.

Fix that one by calling hvc_remove() from xencons_backend_changed() before
signalling to the backend that it's OK to proceed with the removal.

Tested with 'dd if=/dev/zero of=/dev/hvc1' while telling Qemu to remove
the console device.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231020161529.355083-4-dwmw2@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -377,18 +377,21 @@ void xen_console_resume(void)
 #ifdef CONFIG_HVC_XEN_FRONTEND
 static void xencons_disconnect_backend(struct xencons_info *info)
 {
-	if (info->irq > 0)
-		unbind_from_irqhandler(info->irq, NULL);
-	info->irq = 0;
+	if (info->hvc != NULL)
+		hvc_remove(info->hvc);
+	info->hvc = NULL;
+	if (info->irq > 0) {
+		evtchn_put(info->evtchn);
+		info->irq = 0;
+		info->evtchn = 0;
+	}
+	/* evtchn_put() will also close it so this is only an error path */
 	if (info->evtchn > 0)
 		xenbus_free_evtchn(info->xbdev, info->evtchn);
 	info->evtchn = 0;
 	if (info->gntref > 0)
 		gnttab_free_grant_references(info->gntref);
 	info->gntref = 0;
-	if (info->hvc != NULL)
-		hvc_remove(info->hvc);
-	info->hvc = NULL;
 }
 
 static void xencons_free(struct xencons_info *info)
@@ -553,10 +556,23 @@ static void xencons_backend_changed(stru
 		if (dev->state == XenbusStateClosed)
 			break;
 		fallthrough;	/* Missed the backend's CLOSING state */
-	case XenbusStateClosing:
+	case XenbusStateClosing: {
+		struct xencons_info *info = dev_get_drvdata(&dev->dev);;
+
+		/*
+		 * Don't tear down the evtchn and grant ref before the other
+		 * end has disconnected, but do stop userspace from trying
+		 * to use the device before we allow the backend to close.
+		 */
+		if (info->hvc) {
+			hvc_remove(info->hvc);
+			info->hvc = NULL;
+		}
+
 		xenbus_frontend_closed(dev);
 		break;
 	}
+	}
 }
 
 static const struct xenbus_device_id xencons_ids[] = {
@@ -615,7 +631,7 @@ static int __init xen_hvc_init(void)
 		list_del(&info->list);
 		spin_unlock_irqrestore(&xencons_lock, flags);
 		if (info->irq)
-			unbind_from_irqhandler(info->irq, NULL);
+			evtchn_put(info->evtchn);
 		kfree(info);
 		return r;
 	}


