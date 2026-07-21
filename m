Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FB046A5FB;
	Tue, 21 Jul 2026 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656562; cv=none; b=KBNpAjpNCGVPqttnM9CWyTTwPDGSBaMfTV6Imvug5Veqh5SXgISet7JJ5SSrasTL+Tbt9ORnpxjQZtWQDEJ5SH97iIokLNmZssQ+Cx0/12uVpFJZONflE6eTnu7SUlnjL/3Rmt/USOPPKwwbwuOn6y5IqmdUXjuVHtqP7ip5RAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656562; c=relaxed/simple;
	bh=ffO/e+Cxb3tJF1M2lehFMR33MrfDBApi9m4YWzvFLfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozxsqKoYurX306l95JifxidPFJ6F4/AVVja0hNeDMjqyphVKoIw6quVb2Ai2ZeQ93J+co/wTp+FRbjGC9rWqPjMVoxkxI2fSCX4w2APNC4rt40JSIFgvFbWML3hnSpOnbd172uiVffdOGcAWqr8ZACd+61iOuQm6s8VGZanak0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCIv86p2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCIv86p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BD71F00A3A;
	Tue, 21 Jul 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656561;
	bh=pmizYdku6VA4E3eEcmkZkr1oHCR0EmjXKfu60cSubQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCIv86p2Wrkt7Cnzgx9J6tMgJ9qBn3t4C7X0l0dQNsPAJXhMHWgLs7y9B6slRtKPR
	 ek1jjS6NZnBkUw93fdNy9UZ1v8hfhZzhjfsPh3rO9TPPACg35a8uEMoCMTW+A4ZA7U
	 ph7cg6YhFbMkxwOCTt+4t/c/DSkf6tgqCODGKqgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0435/1611] vhost/vdpa: validate virtqueue index in mmap and fault paths
Date: Tue, 21 Jul 2026 17:09:11 +0200
Message-ID: <20260721152525.068324617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang Tang <q.h.hack.winter@gmail.com>

[ Upstream commit 929e4f044621c8cc30b612fb74e1410bef09e41b ]

vhost_vdpa_mmap() and vhost_vdpa_fault() use vma->vm_pgoff as a
virtqueue index for get_vq_notification(), but they do not validate
that the index is smaller than v->nvqs.

The ioctl path already performs both a bounds check and
array_index_nospec(), but the mmap/fault path only checks that the
index fits in u16. This allows an out-of-range queue index to reach
driver-specific get_vq_notification() callbacks.

Fix this by extracting a unified vhost_vdpa_get_vq_notification()
helper that validates the queue index against v->nvqs and applies
array_index_nospec() before calling the driver callback. Both the
mmap and fault paths use this helper, and the bounds checking is
consolidated into a single location.

>From source inspection, the most defensible impact is out-of-bounds
access in the callback path, potentially leading to invalid PFN
remaps and crash/DoS.

Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Qihang Tang <q.h.hack.winter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260508075821.92656-1-q.h.hack.winter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7e51eec842b8cc..a6c6c28bf2d9d7 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1480,16 +1480,32 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 }
 
 #ifdef CONFIG_MMU
-static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
+static int
+vhost_vdpa_get_vq_notification(struct vhost_vdpa *v, unsigned long index,
+			       struct vdpa_notification_area *notify)
 {
-	struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (index > 65535 || index >= v->nvqs)
+		return -EINVAL;
+
+	index = array_index_nospec(index, v->nvqs);
+
+	*notify = ops->get_vq_notification(vdpa, index);
+
+	return 0;
+}
+
+static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
+{
+	struct vhost_vdpa *v = vmf->vma->vm_file->private_data;
 	struct vdpa_notification_area notify;
 	struct vm_area_struct *vma = vmf->vma;
-	u16 index = vma->vm_pgoff;
+	unsigned long index = vma->vm_pgoff;
 
-	notify = ops->get_vq_notification(vdpa, index);
+	if (vhost_vdpa_get_vq_notification(v, index, &notify))
+		return VM_FAULT_SIGBUS;
 
 	return vmf_insert_pfn(vma, vmf->address & PAGE_MASK, PFN_DOWN(notify.addr));
 }
@@ -1512,8 +1528,6 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	if (vma->vm_flags & VM_READ)
 		return -EINVAL;
-	if (index > 65535)
-		return -EINVAL;
 	if (!ops->get_vq_notification)
 		return -ENOTSUPP;
 
@@ -1521,7 +1535,8 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	 * support the doorbell which sits on the page boundary and
 	 * does not share the page with other registers.
 	 */
-	notify = ops->get_vq_notification(vdpa, index);
+	if (vhost_vdpa_get_vq_notification(v, index, &notify))
+		return -EINVAL;
 	if (notify.addr & (PAGE_SIZE - 1))
 		return -EINVAL;
 	if (vma->vm_end - vma->vm_start != notify.size)
-- 
2.53.0



