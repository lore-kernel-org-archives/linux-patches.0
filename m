Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314C82E7390;
	Sun,  7 Jun 2026 10:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829431; cv=none; b=VRevzcrsUu4cYdFAvxFOfG5mlnyFz8fozEbbQCM3BeFFEMkcZbgZG2m6aUDm7xPgeYWToK06gf9i2lGxTLZ/rowAOm0w3/rutab6bPiyjAxn9Rbt8gTP/R27q/XYVAt3wbVSdJGfQwjFO17QwCpxHohvxOG/YYXr9RM8EX3o3fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829431; c=relaxed/simple;
	bh=CnMqB+SfCB3M6Hxm+MZZeOvRdTLqCN8P7Z9VQ0GmMA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjYPO65BPm+m0l0w3Fyfwt/OjhTLG70GvFLr902ybFf5v0CpGAtPNYyLpd21XnUevvIOeczXa3r0/q8ssxDUvPxW/EpD/EiXTQ9Ff8McVuRWQynN3bXzN7VHk+pqO3klsjw4qOrQkO1n7UjGIQiuVPydT2zvxKlm9StDvSz7WQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGZzAY5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGZzAY5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740511F00893;
	Sun,  7 Jun 2026 10:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829430;
	bh=ml4m5CjOu4TMOL/vPKi1Jz+b2nc+psdagHrJMf9WpZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGZzAY5NUAaCtXZUNLk4vhHbKCfvZJNYKw4Y6USPB/SDOGEP/oLbvxpsDNc2qXxDC
	 CQR//LlrvrkjVo4O0Q5vaZstUDNf4s9G0LJxFDa5DZq9ZciTtTR74Ut3MOXyeRY+LA
	 MVCYkKBcwEoEfSHQLiysEoGEBr2FHbUPEO3iDdDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 7.0 278/332] usb: gadget: f_fs: copy only received bytes on short ep0 read
Date: Sun,  7 Jun 2026 12:00:47 +0200
Message-ID: <20260607095738.256683080@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 4e036c10e7f4df5d951c69cc3697bc8e209c6d02 upstream.

ffs_ep0_read() allocates its control-OUT data buffer with
kmalloc() (not kzalloc) at the Length value from the Setup
packet, then copies that full len to userspace regardless of
how many bytes were actually received:

    data = kmalloc(len, GFP_KERNEL);
    ...
    ret = __ffs_ep0_queue_wait(ffs, data, len);
    if ((ret > 0) && (copy_to_user(buf, data, len)))
            ret = -EFAULT;

__ffs_ep0_queue_wait() returns req->actual, which on a short
control OUT transfer is strictly less than len.  The
copy_to_user() call still copies len bytes, so on a short OUT
the last (len - ret) bytes of the kmalloc() buffer --
uninitialised slab residue -- are delivered to the FunctionFS
daemon.

Short ep0 OUT completions are specified USB control-transfer
behavior and are produced by in-tree UDCs:

  * dwc2 continues on req->actual < req->length for ep0 DATA OUT
    (short-not-ok is the only ep0-OUT stall path).
  * aspeed_udc ends ep0 OUT on rx_len < ep->ep.maxpacket.
  * renesas_usbf logs "ep0 short packet" and completes the
    request.
  * dwc3 stalls on short IN but not on short OUT.

A short ep0 OUT is therefore not evidence of a broken UDC; it is
a normal condition f_fs has to cope with.  The sibling gadgetfs
implementation in drivers/usb/gadget/legacy/inode.c already does
this correctly via min(len, dev->req->actual) before
copy_to_user().  This patch brings f_fs.c to the same safe
pattern rather than trimming at a defensive layer.

The bug is reached from the FunctionFS device node, which in
real deployments is owned by the privileged gadget daemon
(adbd, UMS, composite gadget services, etc.); it is not
reachable from unprivileged userspace.  Linux host stacks
normally reject short-wLength control OUTs before they reach
the gadget, so reproducing this required a build that
bypasses that host-side check.  With the bypass in place, a
1-byte payload on a 64-byte Setup produces 63 bytes of
non-canary slab residue in the daemon's read buffer.

Fix by copying only ret (actually received) bytes to
userspace.

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260419160359.1577270-1-michael.bommarito@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -619,7 +619,7 @@ static ssize_t ffs_ep0_read(struct file
 
 		/* unlocks spinlock */
 		ret = __ffs_ep0_queue_wait(ffs, data, len);
-		if ((ret > 0) && (copy_to_user(buf, data, len)))
+		if ((ret > 0) && (copy_to_user(buf, data, ret)))
 			ret = -EFAULT;
 		goto done_mutex;
 


