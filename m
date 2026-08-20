Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EDB32B110;
	Thu, 20 Aug 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238303; cv=none; b=beUoQ2r4K2ijiorgyth2wKtb+ur2YlE3TMZ7Uc1HsF16aMviP8SXbKJY+HEXsMtBYwEXgl+KT5DDFcmAqmnL0l5+KWEDpCIMhEQ6oTrc+YJ5mTmS1IPR2SJ0AFdhvIKUENKuQ11+xCfAu4rGF+cSTboO6uu9IQjkau/pD7GEbZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238303; c=relaxed/simple;
	bh=MBAMO3Car9Xnq8N54CQBp7/iMqie0M/YHBCXTlk699E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEA3E+QPNx3keVicfvNJf3Bf2NmA6EZsxK5qfSXIWQGhPUgfhBHvMt2+x1jL0MUSFVmsKtQVmPagoMUJU9Gyru3r7Gbzl9xOIJ6ZnfBQckVzgFMTfJOpTZROpqC3t3AjwuM4STBCAmXXVMmY7+sH/3CN+depAOcC6USvZG8h8rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtNQCNlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtNQCNlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944821F000E9;
	Thu, 20 Aug 2026 15:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238302;
	bh=D04ZXYXO6TOyWXjHT3O4DdLWBiW5rXe05yac4Tfi5o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtNQCNlL+D+m4Sp/EMHH28ic0z94CQnGtsApJ48pV5xH28ENxs5aURH3sf6DiiFyW
	 OAV/Bkf/2DLqPxJ6exSQIMk7k5WCvj6+7rh2qkwYC9D6HAm1yFvifQwM+Gzu0cYwSw
	 PLvfCatHdNUnKodiaNXkxbboHUDx02waBglfbtuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cornelia Huck <cohuck@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 098/228] s390/vfio_ccw: Ensure index for read/write regions are within range
Date: Thu, 20 Aug 2026 16:54:00 +0200
Message-ID: <20260820145247.630563070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

commit 9f5f9a78fedc45bc29d6a0a64e3a3472361afae5 upstream.

The introduction of the capability chain rightly clamped the
region indexes to the range of the capabilities itself, but
neglected to do so for the existing read/write regions which
should also be enforced.

Fixes: db8e5d17ac03 ("vfio-ccw: add capabilities chain")
Cc: stable@vger.kernel.org
Cc: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_async.c |   16 ++++++++++++++++
 drivers/s390/cio/vfio_ccw_chp.c   |   15 +++++++++++++++
 drivers/s390/cio/vfio_ccw_ops.c   |    7 +++----
 3 files changed, 34 insertions(+), 4 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_async.c
+++ b/drivers/s390/cio/vfio_ccw_async.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/vfio.h>
+#include <linux/nospec.h>
 
 #include "vfio_ccw_private.h"
 
@@ -24,11 +25,20 @@ static ssize_t vfio_ccw_async_region_rea
 		return -EINVAL;
 
 	mutex_lock(&private->io_mutex);
+
+	if (i >= private->num_regions) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	i = array_index_nospec(i, private->num_regions);
 	region = private->region[i].data;
 	if (copy_to_user(buf, (void *)region + pos, count))
 		ret = -EFAULT;
 	else
 		ret = count;
+
+out_unlock:
 	mutex_unlock(&private->io_mutex);
 	return ret;
 }
@@ -48,6 +58,12 @@ static ssize_t vfio_ccw_async_region_wri
 	if (!mutex_trylock(&private->io_mutex))
 		return -EAGAIN;
 
+	if (i >= private->num_regions) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	i = array_index_nospec(i, private->num_regions);
 	region = private->region[i].data;
 	if (copy_from_user((void *)region + pos, buf, count)) {
 		ret = -EFAULT;
--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/nospec.h>
 #include <linux/vfio.h>
 #include "vfio_ccw_private.h"
 
@@ -26,6 +27,13 @@ static ssize_t vfio_ccw_schib_region_rea
 		return -EINVAL;
 
 	mutex_lock(&private->io_mutex);
+
+	if (i >= private->num_regions) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	i = array_index_nospec(i, private->num_regions);
 	region = private->region[i].data;
 
 	if (cio_update_schib(sch)) {
@@ -97,6 +105,12 @@ static ssize_t vfio_ccw_crw_region_read(
 		list_del(&crw->next);
 
 	mutex_lock(&private->io_mutex);
+	if (i >= private->num_regions) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	i = array_index_nospec(i, private->num_regions);
 	region = private->region[i].data;
 
 	if (crw)
@@ -109,6 +123,7 @@ static ssize_t vfio_ccw_crw_region_read(
 
 	region->crw = 0;
 
+out:
 	mutex_unlock(&private->io_mutex);
 
 	kfree(crw);
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -258,6 +258,7 @@ static ssize_t vfio_ccw_mdev_read(struct
 		return vfio_ccw_mdev_read_io_region(private, buf, count, ppos);
 	default:
 		index -= VFIO_CCW_NUM_REGIONS;
+		index = array_index_nospec(index, private->num_regions);
 		return private->region[index].ops->read(private, buf, count,
 							ppos);
 	}
@@ -310,6 +311,7 @@ static ssize_t vfio_ccw_mdev_write(struc
 		return vfio_ccw_mdev_write_io_region(private, buf, count, ppos);
 	default:
 		index -= VFIO_CCW_NUM_REGIONS;
+		index = array_index_nospec(index, private->num_regions);
 		return private->region[index].ops->write(private, buf, count,
 							 ppos);
 	}
@@ -353,11 +355,8 @@ static int vfio_ccw_mdev_ioctl_get_regio
 		    VFIO_CCW_NUM_REGIONS + private->num_regions)
 			return -EINVAL;
 
-		info->index = array_index_nospec(info->index,
-						 VFIO_CCW_NUM_REGIONS +
-						 private->num_regions);
-
 		i = info->index - VFIO_CCW_NUM_REGIONS;
+		i = array_index_nospec(i, private->num_regions);
 
 		info->offset = VFIO_CCW_INDEX_TO_OFFSET(info->index);
 		info->size = private->region[i].size;


