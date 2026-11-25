Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623800;
	b=ETGt+sFYNq1SvljPfIjMlIxBqN4Jo0aq7udUJBmPKESo8IBcsYJ60OVkwPtR2tE67III
	 BsNTUXi76PjJJrz8HkU26s0+QZm1x3bSraASfpGbWmCtOKNfNpX69aIub6G7CFO3E0wft
	 SHXjeiZ68AOLMa4xjZ40QXvSA0EfCNBpf15V1DvjQyAp88hMTl3T9a7YSxRaNHOmdwM63
	 63gDEF6LDh7foaXhHCclwguXx+lpreCJ2vWgsHNtsj8p8EZn5bUied077nw+8+3vCyiyh
	 pYk5ya78ikhEMRxEaXx2uVvKOu/2ZLEZCDC90Ibhw3z9NPwa9E5Dm4U9xuUy6IGMhDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fDplGw26RBqf0Ewppd5VV5kwKcxTNNBnxwcm4/gJ+YI=;
	b=Ga+EN6gmfZ5o5RQKChwdTaphAZeds7w6oH1L9BhkXLOgqjpqJlmLHosbcs7Wto7STN8D
	 YzP42xjcWsbJPpDe79+F80myq4uzy7jKDhD7zk1IizFxebPqpwfiakng05XfZR2SDi+F9
	 9mTOWICb23cZmCkH1fad6vRMnOl7aI761JlwOSXWj7n5CxYCdSvTsGk9ostbtJHFCWEDv
	 ZLXlxCDe41uwr/u+Fw82ppqIvXJewV2+901glItyLwNIysec6ZhLEganVFxWKzMMChipZ
	 HgJ4iEvdTLhlzwK7t2MoyE5JVCCnEhPp7r341H3kSJv9rOIAN9ujP37F83AnCPtSF1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ecex6S/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFCC606A323;
	Wed, 25 Nov 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ecex6S/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289111F000EB;
	Wed, 25 Nov 2026 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623799;
	bh=fDplGw26RBqf0Ewppd5VV5kwKcxTNNBnxwcm4/gJ+YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecex6S/o+KqXI+/72IYtVJMMniHCqtfHPGnup+L+u0fa1djzp8a4EFgo5GH4wXmbq
	 cv9aMb7mxgXLN+FYakWYCt/16Und7Aa1whu2iSwGKES3gefgRwwCb7tpmw94GqKZAI
	 aSdjntf5RFlwNgrC1/c8cqSzExz0DkLy/ESw2x2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mani Tofigh <mt4022@columbia.edu>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 973/990] nvme: fix deadlock on nvme_subsystems_lock in nvme_init_subsystem()
Date: Wed, 25 Nov 2026 15:39:00 +0100
Message-ID: <20261125143844.776751656@linuxfoundation.org>
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
@@ -3317,7 +3317,11 @@ static int nvme_init_subsystem(struct nv
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


