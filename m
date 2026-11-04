Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827198;
	b=R+3i6Cer0Wpq1mfbgLmad278pbASVjOjEp+5ZTWhrG1ybLjf9duWHwgAMCi5fX5HNivZ
	 LurTi2z7RuGHlECwOOWbpEOKjNjotRiil/8bX7ILPLBSDdNCCopuTd+BDc1MQXU3HhGNx
	 BrfILeymSpjfDR7J+6NjTpJu8i0TKhjI9Gmvk5GS1Fz+rjFGzDXgxLMeVfuF8Ygz94Ynj
	 /fMhCuJnYjBgKUhzrBQEqb7oojpciMBI3IwbdbV3OpowpxXJQTny/vU1QBT1usjPmA8Vy
	 O1A31tg3HRFtYN3W80MIaJD6y4vakjEe7QdBotFbp/UhWIjsuu0gcilsDyCRcbYl8AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LS6I8kYwwXeICSNnHxDcQY1+x6EnknZ3oDw5SJvylYU=;
	b=4BqwEDRq+B+2drHrQ4EfVweVW3Hly2IWv+qWhmn1cy+l8upHCpuk+FYBFAPE6rQmYiEs
	 SqKthYHKNozK5KDDqm8RgQ/4wURUY/Gap4fVQjjMuU2vi6ZJqy4FcNZ7j5ctJjW4aeL3I
	 9cSCRxYU/l1wgL/09UVh4UsFMbqny2Gxe5Uu/pWc1mEhK8PKKxtS1dL2XMWIdHPSlqRa9
	 gOqhobbWyamOktLHfgV942MapHwJ2InBfBuE5tsy3gUcbanen4fKSiu9gOW979RYVl23X
	 ytOUdcWl5MKqeEzL7u9VEudt0SdOOWKgRWKycHTKuVF9mWlVM3Sz9V9+iTElCvStr7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecLjEneD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AF76075DC3;
	Wed,  4 Nov 2026 21:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecLjEneD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20591F00919;
	Wed,  4 Nov 2026 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827197;
	bh=LS6I8kYwwXeICSNnHxDcQY1+x6EnknZ3oDw5SJvylYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecLjEneDVs8vZnt+A6y4O7EbqDd/JoiiU0ueucD2VAnUzrwkNPBbHK0B9rR+EkW9S
	 cavcafUHju9XRZpk0rnre/YmkCyOwBDpNIGZ1/G/epBqSm8iLsXYdLZYEmU5aRJISZ
	 X9RDwr3l5Z5YoYiWML6ddVPPloNliP6kUKxJkpxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8496ab5e117502750445@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.3 252/547] usb: gadget: fix refcount underflow in gadgetfs_bind() error path
Date: Wed,  4 Nov 2026 16:07:16 -0500
Message-ID: <20261104211045.335358314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>

commit cb3b441f2698455a48e9a023d5f7f4e3fcb94c73 upstream.

gadgetfs_bind() calls get_dev() only on the success path, but
gadgetfs_unbind() called from the enomem error label unconditionally
calls put_dev().  When bind fails (e.g. ENOMEM), put_dev() fires
without a matching get_dev(), leaving the refcount unbalanced.

A subsequent close of the ep0 file descriptor calls dev_release() ->
put_dev() which hits zero and frees the object; then gadgetfs_kill_sb()
calls put_dev(the_device) again on the already-freed pointer, triggering
a refcount underflow and use-after-free.

Fix by calling get_dev() at the start of gadgetfs_bind(), before any
error path that invokes gadgetfs_unbind(), so the reference is always
balanced regardless of whether bind succeeds or fails.

Reported-by: syzbot+8496ab5e117502750445@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=8496ab5e117502750445
Signed-off-by: Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260811060810.295666-1-khiemtranzo532001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1692,6 +1692,8 @@ static int gadgetfs_bind(struct usb_gadg
 	dev->gadget = gadget;
 	gadget->ep0->driver_data = dev;
 
+	get_dev (dev);
+
 	/* preallocate control response and buffer */
 	dev->req = usb_ep_alloc_request (gadget->ep0, GFP_KERNEL);
 	if (!dev->req)
@@ -1706,7 +1708,6 @@ static int gadgetfs_bind(struct usb_gadg
 	spin_lock_irq(&dev->lock);
 	dev->state = STATE_DEV_UNCONNECTED;
 	spin_unlock_irq(&dev->lock);
-	get_dev (dev);
 	return 0;
 
 enomem:


