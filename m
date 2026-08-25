Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BE9481648;
	Tue, 25 Aug 2026 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666320; cv=none; b=ZaJVKTAXxawNpXEBXd/hAuF5r7YTmjMbcxl7d78AupXifaE2UidXAeZGR/6EqooUv7y8/zWn3qYmHu+po1BbdwO/Eu9kN8A7BdQlv5cw2CQVLqiFRxgfwTOON5lUBXBbnOp2tVR2LYX99edEGxooshwWQYaf+0o6qknKDYTujWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666320; c=relaxed/simple;
	bh=s/oq7jrHEmHxWaa/rUepvbZ/p5F5NBpSQbN4uoI8Aio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRyPwEb8fxZ+G1eAvBhIiNMSCnQ0EQylo/QhafVXN9cIzdLQx/AvDNtUJb5l76cq++iJTBu+Jirvzr+gNPLVvt041DMapg7yM0XIWANj5jv3OVKScoo1lMSf7eOGpYan45auCtNermZ1y7P/gYM29Ng8iA1awrO0sbrVqzmhmYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAFSw4/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAFSw4/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C3D1F00A3A;
	Tue, 25 Aug 2026 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666319;
	bh=I9Za2eefmF/RVcFCq/J2KDCgPI05T4LxIdm5LgY6Ddc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAFSw4/+mprKz9a15Xj46pCv7L2NpZxzXbgWsN5y6NrGT/pp7EQpPRYQqMpFD8PkH
	 aaHDAwpRwAhBhdYTVCgMpTOMVKHcrqWu6xQROw1hu1doRIXddPzuq8UjvD8NHJdy8h
	 LrjyBGHVJc+TffbNItv6sVgMdUjeNTh/TQ5/N+7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cornelia Huck <cohuck@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/76] s390/vfio_ccw: Ensure index for read/write regions are within range
Date: Tue, 25 Aug 2026 15:26:39 +0200
Message-ID: <20260825132543.376053962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 9f5f9a78fedc45bc29d6a0a64e3a3472361afae5 ]

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
Stable-dep-of: 16b0798024c0 ("s390/vfio_ccw: Implement a crw lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 #include <linux/mdev.h>
 
 #include "vfio_ccw_private.h"
@@ -25,11 +26,20 @@ static ssize_t vfio_ccw_async_region_rea
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
@@ -49,6 +59,12 @@ static ssize_t vfio_ccw_async_region_wri
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
 
@@ -25,6 +26,13 @@ static ssize_t vfio_ccw_schib_region_rea
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
 
 	if (cio_update_schib(private->sch)) {
@@ -96,6 +104,12 @@ static ssize_t vfio_ccw_crw_region_read(
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
@@ -108,6 +122,7 @@ static ssize_t vfio_ccw_crw_region_read(
 
 	region->crw = 0;
 
+out:
 	mutex_unlock(&private->io_mutex);
 
 	kfree(crw);
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -259,6 +259,7 @@ static ssize_t vfio_ccw_mdev_read(struct
 		return vfio_ccw_mdev_read_io_region(private, buf, count, ppos);
 	default:
 		index -= VFIO_CCW_NUM_REGIONS;
+		index = array_index_nospec(index, private->num_regions);
 		return private->region[index].ops->read(private, buf, count,
 							ppos);
 	}
@@ -312,6 +313,7 @@ static ssize_t vfio_ccw_mdev_write(struc
 		return vfio_ccw_mdev_write_io_region(private, buf, count, ppos);
 	default:
 		index -= VFIO_CCW_NUM_REGIONS;
+		index = array_index_nospec(index, private->num_regions);
 		return private->region[index].ops->write(private, buf, count,
 							 ppos);
 	}
@@ -359,11 +361,8 @@ static int vfio_ccw_mdev_get_region_info
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


