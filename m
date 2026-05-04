Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9829C3D9DCF;
	Mon,  4 May 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902927; cv=none; b=mRC2QJ6PaARxGZjI7kjdb09eAe57rtp03N4V/WQ6Y4kHJQp7uCs7WdJnPxkOKyYXu9L62AES8DU5lZOz3ktsvuqSaZRcULcST04VSxoJN901wfwm37AaRaJ+NBNT5XNVKSm0/j7bnRGQut8p7lE/2yiUmg2zdaWU5Dz+C4caHtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902927; c=relaxed/simple;
	bh=S4okUYUSNRewU0uxC2o/P8trTBuQCjsFKAv0YC6zEPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Je54ZG9/t/5CEG6byM41YXSmeCBdtXknLi1AZP7wJmU0VDufp3gRe1Osjwzju3Jr7J8+2rKNGCER5/5NS+PLZSAJGVLs3R1rE52WJKgAon1HGEheS7u36Dc8pv2a22yGOBM/u+8ddtjcU/QlwfZ3DdIjVHMN8aLg7RDCHpWj+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEXXW4ef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEXXW4ef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB90C2BCC4;
	Mon,  4 May 2026 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902927;
	bh=S4okUYUSNRewU0uxC2o/P8trTBuQCjsFKAv0YC6zEPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEXXW4efkl7OHQDmkU5qx0D8SQKc1l2ybPigxomOAfFxst7DmrdcVrxx9HC7S0Kv5
	 7wx2jjXREGZb2HKEBTpyhw3oQgDKMICaID2j14ehc2ie1NJ1Oyj5c+KMaOhGD2HdD2
	 xvLtsDEPPIH/nJ9UyN76yUeOHAm9F0SFCGUkjaNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.0 037/307] vfio/virtio: Convert list_lock from spinlock to mutex
Date: Mon,  4 May 2026 15:48:42 +0200
Message-ID: <20260504135144.218479558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@nvidia.com>

commit 903570835f12b7436ca0edb0a9ed351c0349121e upstream.

The list_lock spinlock with IRQ disabling was copied from the mlx5
vfio-pci variant driver, where it is justified by a hardirq async
command completion callback that accesses the protected lists.  The
virtio driver has no such interrupt context usage; all list_lock
acquisitions occur in process context via file read/write operations
or state transitions under state_mutex.

Convert list_lock to a mutex to be consistent with peer vfio-pci
variant drivers (hisilicon, pds, qat, xe) which all use mutexes for
equivalent migration data protection.  This also fixes a mismatched
spin_lock()/spin_unlock_irq() pair in virtiovf_read_device_context_chunk()
that could incorrectly enable interrupts.

Reported-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Closes: https://lore.kernel.org/all/20260413073603.30538-1-guojinhui.liam@bytedance.com
Fixes: 0bbc82e4ec79 ("vfio/virtio: Add support for the basic live migration functionality")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://lore.kernel.org/r/20260414200625.3601509-2-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/virtio/common.h  |    2 +-
 drivers/vfio/pci/virtio/migrate.c |   33 +++++++++++++++++----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -68,7 +68,7 @@ struct virtiovf_migration_file {
 	enum virtiovf_migf_state state;
 	enum virtiovf_load_state load_state;
 	/* synchronize access to the lists */
-	spinlock_t list_lock;
+	struct mutex list_lock;
 	struct list_head buf_list;
 	struct list_head avail_list;
 	struct virtiovf_data_buffer *buf;
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -142,9 +142,9 @@ end:
 
 static void virtiovf_put_data_buffer(struct virtiovf_data_buffer *buf)
 {
-	spin_lock_irq(&buf->migf->list_lock);
+	mutex_lock(&buf->migf->list_lock);
 	list_add_tail(&buf->buf_elm, &buf->migf->avail_list);
-	spin_unlock_irq(&buf->migf->list_lock);
+	mutex_unlock(&buf->migf->list_lock);
 }
 
 static int
@@ -170,21 +170,21 @@ virtiovf_get_data_buffer(struct virtiovf
 
 	INIT_LIST_HEAD(&free_list);
 
-	spin_lock_irq(&migf->list_lock);
+	mutex_lock(&migf->list_lock);
 	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
 		list_del_init(&buf->buf_elm);
 		if (buf->allocated_length >= length) {
-			spin_unlock_irq(&migf->list_lock);
+			mutex_unlock(&migf->list_lock);
 			goto found;
 		}
 		/*
 		 * Prevent holding redundant buffers. Put in a free
-		 * list and call at the end not under the spin lock
+		 * list and call at the end not under the mutex
 		 * (&migf->list_lock) to minimize its scope usage.
 		 */
 		list_add(&buf->buf_elm, &free_list);
 	}
-	spin_unlock_irq(&migf->list_lock);
+	mutex_unlock(&migf->list_lock);
 	buf = virtiovf_alloc_data_buffer(migf, length);
 
 found:
@@ -295,6 +295,7 @@ static int virtiovf_release_file(struct
 	struct virtiovf_migration_file *migf = filp->private_data;
 
 	virtiovf_disable_fd(migf);
+	mutex_destroy(&migf->list_lock);
 	mutex_destroy(&migf->lock);
 	kfree(migf);
 	return 0;
@@ -308,7 +309,7 @@ virtiovf_get_data_buff_from_pos(struct v
 	bool found = false;
 
 	*end_of_data = false;
-	spin_lock_irq(&migf->list_lock);
+	mutex_lock(&migf->list_lock);
 	if (list_empty(&migf->buf_list)) {
 		*end_of_data = true;
 		goto end;
@@ -329,7 +330,7 @@ virtiovf_get_data_buff_from_pos(struct v
 	migf->state = VIRTIOVF_MIGF_STATE_ERROR;
 
 end:
-	spin_unlock_irq(&migf->list_lock);
+	mutex_unlock(&migf->list_lock);
 	return found ? buf : NULL;
 }
 
@@ -369,10 +370,10 @@ static ssize_t virtiovf_buf_read(struct
 	}
 
 	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
-		spin_lock_irq(&vhca_buf->migf->list_lock);
+		mutex_lock(&vhca_buf->migf->list_lock);
 		list_del_init(&vhca_buf->buf_elm);
 		list_add_tail(&vhca_buf->buf_elm, &vhca_buf->migf->avail_list);
-		spin_unlock_irq(&vhca_buf->migf->list_lock);
+		mutex_unlock(&vhca_buf->migf->list_lock);
 	}
 
 	return done;
@@ -554,9 +555,9 @@ virtiovf_add_buf_header(struct virtiovf_
 	header_buf->length = sizeof(header);
 	header_buf->start_pos = header_buf->migf->max_pos;
 	migf->max_pos += header_buf->length;
-	spin_lock_irq(&migf->list_lock);
+	mutex_lock(&migf->list_lock);
 	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
-	spin_unlock_irq(&migf->list_lock);
+	mutex_unlock(&migf->list_lock);
 	return 0;
 }
 
@@ -621,9 +622,9 @@ virtiovf_read_device_context_chunk(struc
 
 	buf->start_pos = buf->migf->max_pos;
 	migf->max_pos += buf->length;
-	spin_lock(&migf->list_lock);
+	mutex_lock(&migf->list_lock);
 	list_add_tail(&buf->buf_elm, &migf->buf_list);
-	spin_unlock_irq(&migf->list_lock);
+	mutex_unlock(&migf->list_lock);
 	return 0;
 
 out_header:
@@ -692,7 +693,7 @@ virtiovf_pci_save_device_data(struct vir
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
-	spin_lock_init(&migf->list_lock);
+	mutex_init(&migf->list_lock);
 	migf->virtvdev = virtvdev;
 
 	lockdep_assert_held(&virtvdev->state_mutex);
@@ -1082,7 +1083,7 @@ virtiovf_pci_resume_device_data(struct v
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
-	spin_lock_init(&migf->list_lock);
+	mutex_init(&migf->list_lock);
 
 	buf = virtiovf_alloc_data_buffer(migf, VIRTIOVF_TARGET_INITIAL_BUF_SIZE);
 	if (IS_ERR(buf)) {


