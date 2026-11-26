Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704597;
	b=knwZW9QK6r7DB1SYGA5J2ZPWQvIR3PrsUpM6yvY9gZB1XeiGGVKMMDxmViT8n/atLrFc
	 8GVUoIjT2lkfinmMPvWKCtLUgc/mgm5PWDzqQbNorxGhd6fQZ1kMxLzCq6HSwf8WDXvIw
	 AjZwbFd/cV2jWvD0eyDH1yFuGTvk38WWeIL4Hm8Bkossd5rE6yIiWYrtg4H8kH13uyGm0
	 x8Lx44Ul2yC5hooP4/PzUO8VR6mN3agBJDtE7R2LE4lDxEhwjPU2BQkanVUz5fH+UDmOF
	 ndSl23VEMy6Vs/Ew5uJdmSBfskmFY6LCBgRXYmKjEypoO44UfNB/4ccrNsG1NNPp/dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YjuDV3Il7acaOJmMaTG/H9YXOKvkP/PGcjff/tFs9BY=;
	b=3zdiQkaM5E35lR0mj1/8HnEtQjdRaaMZlZqORDk/SQwo8uKbtbqAihGpCNI/HFxCOabY
	 O4w0NcMzdiAJ3I6g1a6MUKZBX3DKlEbLsx0zzptY3lbUpfmMdZe/SSLesD4N0UkM15ERw
	 aFUQDnGwd8hNjZgdtn2hjoM21EFkj1k8FXfhVy5ebhwIa0SdDsu0oiWiEcJybYDxHERIn
	 C3SZoCPARAVnYlnJDjPcetXi199uDk/1COdaRlFUMMJZ7l1nW2v01t3mO9djQ1eSPj9gc
	 5rdeG52PmtSSNOdp9BssoJ0CYP/4/81jm6qjAfBMZaA6MzBa2p20Xhd2zic76QRn1kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wsNKW67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0E2606A31C;
	Thu, 26 Nov 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wsNKW67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DA41F000C0;
	Thu, 26 Nov 2026 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704597;
	bh=YjuDV3Il7acaOJmMaTG/H9YXOKvkP/PGcjff/tFs9BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wsNKW67n2dHqL8cvh9IXXlrawCf0Ojcs/ZNsOkCUrQ3OOn5iUlZ3bO+35hXcbNNH
	 5FdG4OD62Fgil32JAOxUwu07pwxJhGv1YkMXazUM5kWEr9ioi0NI2k8L24NU6hs8YS
	 TIfjHKloozC4+Sya8H2EeXVli5ei4gbVyyRRTbd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 178/265] xen/gntdev: fix deadlock between map ioctl and mmap
Date: Thu, 26 Nov 2026 15:38:28 +0100
Message-ID: <20261126143617.627510941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Misiurov <andrey.misyrov@gmail.com>

commit 7620a997e4854c94eacebf0c2d453fbd78ccdb46 upstream.

Commit 45ca1afe2fd1 ("xen/gntdev: fix error handling in ioctl") moved
copy_to_user() in gntdev_ioctl_map_grant_ref() under priv->lock. A
fault in copy_to_user() takes mmap_lock, while gntdev_mmap() is called
with mmap_lock held and takes priv->lock:

  ioctl thread                        mmap thread
  mutex_lock(&priv->lock)
                                      mmap_write_lock(mm)
                                      gntdev_mmap()
                                        mutex_lock(&priv->lock)
  copy_to_user() faults
    mmap_read_lock(mm)

Reproduced on Debian 6.12.111 in a Xen guest, with the ioctl argument
on a MAP_PRIVATE file page that has not been written yet. sysrq-w:

  task:repro state:D stack:0 pid:4479 tgid:4477 ppid:1 flags:0x00000000
   rwsem_down_read_slowpath+0x25c/0x480
   down_read_killable+0x48/0xc0
   lock_mm_and_find_vma+0x96/0x250
   do_user_addr_fault+0x12d/0x620
   exc_page_fault+0x7e/0x180
   asm_exc_page_fault+0x26/0x30
   _copy_to_user+0x36/0x50
   gntdev_ioctl+0x3b9/0xa00 [xen_gntdev]
   __x64_sys_ioctl+0x97/0xc0
  task:repro state:D stack:0 pid:4480 tgid:4477 ppid:1 flags:0x00000000
   __mutex_lock.constprop.0+0x41b/0x720
   gntdev_mmap+0x4d/0x330 [xen_gntdev]
   __mmap_region+0x697/0xb10
   mmap_region+0x78/0xa0
   do_mmap+0x45d/0x630
   vm_mmap_pgoff+0xf8/0x1c0

Drop priv->lock before copy_to_user() again. On failure, re-take it
and remove the map by index, as IOCTL_GNTDEV_UNMAP_GRANT_REF does,
since another thread may have unmapped it meanwhile.

Fixes: 45ca1afe2fd1 ("xen/gntdev: fix error handling in ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261013170745.583279-1-andrey.misyrov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -668,15 +668,19 @@ static long gntdev_ioctl_map_grant_ref(s
 	mutex_lock(&priv->lock);
 	gntdev_add_map(priv, map);
 	op.index = map->index << PAGE_SHIFT;
+	mutex_unlock(&priv->lock);
 
 	if (copy_to_user(u, &op, sizeof(op)) != 0) {
-		list_del(&map->next);
+		mutex_lock(&priv->lock);
+		map = gntdev_find_map_index(priv, op.index >> PAGE_SHIFT,
+					    op.count);
+		if (map)
+			list_del(&map->next);
 		mutex_unlock(&priv->lock);
 		gntdev_put_map(priv, map);
 		return -EFAULT;
 	}
 
-	mutex_unlock(&priv->lock);
 	return 0;
 }
 


