Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626365;
	b=vIlcJrBft8ww4p6exxd0/01KXrZR7A9iy+tmerWXyCSRr49WWi6azOmjvQw7wYLpg8FA
	 9IiRXDFe1giB99X82tSK5eieIPrE5LADSfdilFOzPMxGvCQnWJZe6iq/BhTEhAPiZB71T
	 uMsI8xHEWrGFPFKIquTx4dU4Tx5SLVTKohwZzoD46WwrQcVSs7Sp93CDFgEr5cr96Smbw
	 +YX5aFxkEJNU+hWPyibuOWljqmAcGIzDff667n0yiQrToyZBvYDGfMJyYnetB72jciBUm
	 xoru5/senAw0nal1otR0lnAsBapnTw6qTlclpQnMRmrzXk9CeXggKZjX1SWeNKlqUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/FQVgSU31aQsY/9Yh1QzLQhIlBmUWppZQ+rKTC/s/i8=;
	b=1r4w+A/yTtO72FfJIh2hO+Zf6M7KeV75YKF9JxMW4TpnTnbSOZ5DdRaBUMQcPPX6fbVg
	 MeELrOfrf5g/Tqtkac4yMb/UXR02RI78D6jCJRNt+/uPXLBoJTIVvijAw45QHj6dXavmH
	 PagOGFaPsz1Zd0/QiiHz3uKcHh4xd1IhaqXRcDfWAdHf/odmpZGgPXtdoy1AZeTtvNqgf
	 hl14oKw6qga/ImalTJkcr2TKa6Yi3EgIhIfO/Rh1c9cIaDp051U/ydviuqQ6k0BZoiaDZ
	 TwX8ANJuHjsTtNi+e/guKcGupG5FEOsa9oSm+Nxd25hL7SJ/D2YGhBZ+4onTYMf7+ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGUCzkmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95F606A321;
	Wed, 25 Nov 2026 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGUCzkmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC80F1F000F4;
	Wed, 25 Nov 2026 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626364;
	bh=/FQVgSU31aQsY/9Yh1QzLQhIlBmUWppZQ+rKTC/s/i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGUCzkmmTJoEioEsW9vaokIY2C2z3qSbmxXgncdE0T5QRDnp783gK3sv68uw0BTX9
	 T/qDDCreM/y+SZgChI/dkVkVPF8UKTq2tp6K2DKe3gzSi99nV0s2+Y3meYqqGyWGa9
	 aYLlte1HxzWCeioMJEpWAUmU16JfpDSLgztLP7kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 804/816] nvme: fix deadlock on nvme_subsystems_lock in nvme_init_subsystem()
Date: Wed, 25 Nov 2026 15:39:12 +0100
Message-ID: <20261125143907.780927483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mani Tofigh <mt4022@columbia.edu>

commit ba1213be15c613a1c03db69ea6480ca140a6ca00 upstream.

Connecting a controller to a new subsystem deadlocks when
sysfs_create_link() fails in nvme_init_subsystem(), e.g., on an
allocation failure.  The error path drops the last subsystem reference
with nvme_subsystems_lock held and nvme_destroy_subsystem() takes the
same lock again:

  nvme nvme0: failed to create sysfs link from subsystem.
  ============================================
  WARNING: possible recursive locking detected
  ...
  nvmesubsys/95 is trying to acquire lock:
  (nvme_subsystems_lock){+.+.}-{4:4}, at: nvme_destroy_subsystem+0x1b/0x1e0

  but task is already holding lock:
  (nvme_subsystems_lock){+.+.}-{4:4}, at: nvme_init_identify+0x81e/0x34b0
  ...
  Call Trace:
   __mutex_lock+0x1a2/0x26e0
   nvme_destroy_subsystem+0x1b/0x1e0
   nvme_init_identify.cold+0x3bc/0x56f
   nvme_init_ctrl_finish+0x1bc/0x7a0
   nvme_loop_configure_admin_queue+0x205/0x2b0
   nvme_loop_create_ctrl+0x480/0xd10
   nvmf_dev_write+0x365/0x650
   vfs_write+0x1e3/0x1250
   ksys_write+0xfa/0x200
   do_syscall_64+0xfb/0x590
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  INFO: task nvmesubsys:95 blocked for more than 20 seconds.
  INFO: task nvmesubsys:95 is blocked on a mutex likely owned by task nvmesubsys:95.

Every later controller setup or removal then waits for the lock too.
The nvme_validate_cntlid() error path for an existing subsystem does the
same put, and deadlocks the same way if the other references go away in
between.

Drop the lock before the put.  For a new subsystem, take it off the list
first so another controller can't find it in between.  With the fix,
the connect fails and the next connect works.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 30s.

Fixes: 32fd90c40768 ("nvme: change locking for the per-subsystem controller list")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3109,7 +3109,11 @@ static int nvme_init_subsystem(struct nv
 	return 0;
 
 out_put_subsystem:
+	if (!found)
+		list_del_init(&subsys->entry);
+	mutex_unlock(&nvme_subsystems_lock);
 	nvme_put_subsystem(subsys);
+	return ret;
 out_unlock:
 	mutex_unlock(&nvme_subsystems_lock);
 	return ret;


