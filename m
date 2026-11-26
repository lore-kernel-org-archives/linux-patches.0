Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705497;
	b=X3NDr+wZEbAiIdoAQc3UC7KY7SkgjHqLSABKnM603otijdspR7yHBEkU6bRhOuM1lK8t
	 NI/OlHRDmlzYUX7gG1g3oCE5eNgypNxMNarghFeblTrMSSIAKopFfHEVpT8W5SPLO8Fuc
	 /A1oF910xdkxPFDi4AKU7XZDxIK1YuS2vnc36Q11NgWX7sqo9xGybuqgOKRMavfOmtrFb
	 Nu7z1GI365WJSKTRit80s25aQ4SjYsQLMmJrkNy36uDQWvbEzoMZ3AVZsWdvA2cU31NUl
	 Ktyj4TshBPcZLHTwfRvnJsKQ/BTAoEJah8It93mTel8uS1BZNhCeKEBgUId6YJeprww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBvbW2GNtUJjM0B4cOwZtiaL49xwwJEywQWFQdDVzrE=;
	b=s/Je3xPxLnGIVw2aHGac/jEouQVdqqYZKIb1hHmfDZaP++QZtAuahUBBNpDRyWGYxhBh
	 PABApnTNoR0TSt+bo6Z2KC+8BU14kyUm0BpjgwRbTqndaM6ZhSlxPde5bSKx7l44lkqDI
	 c9VyS3xjdt6eT8kTiBas8WH3MpMRYjicjhOZLSBrMzHq3FujjiJ7Ic2yeQmi/Y2KgYTja
	 HLT0cQymksXECJv47PN7ks+Z7wrnTsLpl4NkA6j8tQba8HRcB7MgzAvsuvS66k6L6c5XN
	 DjYHoEZqb3A0oHR0EJyYT+W69zdJzADDUOyeRssn2PCExOZifth0UfFAL8Xr/dOCmcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROzQrdYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591C2606A31C;
	Thu, 26 Nov 2026 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROzQrdYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A5E1F000CF;
	Thu, 26 Nov 2026 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705496;
	bh=EBvbW2GNtUJjM0B4cOwZtiaL49xwwJEywQWFQdDVzrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROzQrdYGQ1GDhemk+8ygoIU14mJJ0gkII75qi6FSh+TcVqoOTZQRbigFVuiRMkmtU
	 hS8ZDc42WhasSB3U0QjzOgY1Nl1hODBuRPjdqIUDKd+T43Fm4W0w+ryPMkT7MCu3ge
	 nb20IxSVxsv+6kYpzY6r+hbxJDRD1ntY0+H7AZOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 216/319] xen/gntdev: fix deadlock between map ioctl and mmap
Date: Thu, 26 Nov 2026 15:39:44 +0100
Message-ID: <20261126144011.621706963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -678,15 +678,19 @@ static long gntdev_ioctl_map_grant_ref(s
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
 


