Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623169;
	b=gPaWGXeXlMLIZai322BaAtqffMJe/iVTr2IIR7xOcdprW4GmSDBOsf8ZsrEqx7EsR4wa
	 4yjSkakm9+Q2zMsNtBoSVYrVzPY6GdV9pk0wvRym12lnopEVuUrWFbcLyNL4H+X6bfTZ5
	 lp/l1GSJtwbP0B+WJVSWChYUEoFhX4IytjHBxRw1q0mhc5KtQWtIAhVJ+VFHDMVXcjcRs
	 QBFgkAOGdU4/iVSjyQConRZUdbuDh2ovFghMsOjyz9vNT7lJro1BiHdIUVm5he8n1heYU
	 U0VmrRkUfaPMHQsN2+tXi9NDZWqKYFC6gnutOYznGApQb5XiWnKpLS77+zfw3lXVWrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zme0eg6yM0UTzmbOoXARheFqtjvnVpwZlLK6e4cGFYA=;
	b=sFFRq6HoI1k3kQujOegKq45HoWPpuWz5Orqugrr9maZjHeJkiidot/EuAgtU1a2Az++j
	 iJxT+mNagZEAIo9j7Uf3AmmpulPKXrDtvy7LqBww5QfipB1kpfu5lSTTDgpRRn9AX5alE
	 yjZ4EqDcBKk3gmMwp6siihjP/FtRsw8hD2Si2az2UheTEFMOCi3BaG0SYyhxM2r4u9fJx
	 6IXstidVgcqvJmD4Lb8BtrcuFgNYJOPqQfcXinX1zxdaLFCYgmQAndwtE/feLeVQ6oawp
	 G7kdWEbk7eAn5Wwfwaqw7YFtXFrmvqhygA2zYTGrK+BMys2xJDsZsut6FDLh7HdxCsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p2x/s30A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337FA606A338;
	Wed, 25 Nov 2026 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2x/s30A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483201F00A01;
	Wed, 25 Nov 2026 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623168;
	bh=zme0eg6yM0UTzmbOoXARheFqtjvnVpwZlLK6e4cGFYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2x/s30AKkouNoctHtuXP++9RfDCvG3vhhRtT2QcQw5Z/BQOTfJQdDpLq0gFaWOz8
	 UmXy6tv6e1fX7DfiwDzoA5Ni1g5EGaWuNVmaI6ogoq3y9fEMWDtV0kElDdu3GrqAen
	 NOhp3xzleHzoiKKc7IEXK/FZoT7uIIEbUn++ic+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.18 772/990] xen/gntdev: fix deadlock between map ioctl and mmap
Date: Wed, 25 Nov 2026 15:35:39 +0100
Message-ID: <20261125143840.136999146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -676,15 +676,19 @@ static long gntdev_ioctl_map_grant_ref(s
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
 


