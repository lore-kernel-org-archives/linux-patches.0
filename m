Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A57F319851;
	Sun,  7 Jun 2026 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829421; cv=none; b=A9ppNZ+o1ShWsXN0lovZreat/HBwZuKG3y6gV6e2CUgaMUFAUtzupkd4VisJPy3plcMBr9ZbWp8u/m3bz1yOA8EsL3gfTKMlsDrjcJNbyXIuGV04mzaS/o4565vmT1+Ujn/BVIswK4jhr28VyYsEwSHIir1JRYUP9hqYEPh2WcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829421; c=relaxed/simple;
	bh=7I0q+kLxJxDyBUkO7kuUOUKIVjZmeWDteG0/HSLvB6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYShm3i1uirk9hgB0Q2rjYC1oNyj90elrliPcHf5yeT6mQjOKyzGc3zR9pCcI5pJJPV8sTcL2+8amsd/etIkeA0jt28kmXYbfpLGXOHtTRpoGzPqq04ZjvL7pBTx3DAQYYiDAGPydfNeiUraTrzApoyhmOjPpm1XyHnO89Lj5h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDc40h57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDc40h57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D70B1F00893;
	Sun,  7 Jun 2026 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829420;
	bh=u9z3L1ilCzH2eSmRaHJgTkKaKdJkXSsT+OITud1scQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDc40h57oMNGri59MI6NIfGZfOIoCyQWQRPfB1HQMjMSB+mlHAcEXl1RMyWDMuoda
	 QJBvIiOeMqlB5+S6YZaI4EPuC7dhR3VZUNqvNEhgxMUEEWSVQ+QmdH+Wox8H4XBoRU
	 faaXHIN01joJYx95leCM4zGeRNP+fz70mHyf5qZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 6.18 246/315] usb: gadget: f_fs: copy only received bytes on short ep0 read
Date: Sun,  7 Jun 2026 12:00:33 +0200
Message-ID: <20260607095736.597744723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -622,7 +622,7 @@ static ssize_t ffs_ep0_read(struct file
 
 		/* unlocks spinlock */
 		ret = __ffs_ep0_queue_wait(ffs, data, len);
-		if ((ret > 0) && (copy_to_user(buf, data, len)))
+		if ((ret > 0) && (copy_to_user(buf, data, ret)))
 			ret = -EFAULT;
 		goto done_mutex;
 


