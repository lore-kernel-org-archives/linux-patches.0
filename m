Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65032D739C;
	Sat, 12 Sep 2026 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220644; cv=none; b=oLSWpws1HOmIY7a5pOvZfhPIgC+22ymwkWTGSXJLY+fEr6abthuSPd5GnqxuliScxTrBkRCIu4gKUX8OiaV2D88dUr7vISOgDxX8ibd8ADvOtKvaitqU0350n+xp6CqzOgdlVIV354DFqnfuqmhFCSI7nnJMve358ofGTam4inA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220644; c=relaxed/simple;
	bh=/5gGNefdNBiZ38SFZDrg5sk59rPtJIqDJ304j/50lPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zkcvaar7zP3FQ32V2saNxzzwfe/PrAGsTSYAUkbHas83T8+ZbaekPOK1QJkrKFB4ggzeuwjT23/CWUgEdcrznjW6uhOpicbYlR7CM/BpgbWD2Ji+FgaTcV+D3OiqZ9ZudI6YOZaYi5pcI2V7d3drb9Xlhx0/Zv04IFDt+X4smLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1fOOeSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1fOOeSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FE21F000FF;
	Sat, 12 Sep 2026 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220642;
	bh=HyZASx6qSHu8lyinlV6BVMi9QI7NqQImojaSJpfqBws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1fOOeSj5U6Hqpeo26oXf9G2xFSq2sybjv5sJG4meW1iI3PqZ/KXa5M9eLOyD9J7t
	 xDtWWjS5UoSfTnGT+SfQEdsPoFF7jYchEJVM+iuO6oqc2r0lEQ7ogQXeiAQgtpTtH8
	 XFjpfNqDPEQod5eHZNnhYcun9tBzvC+RumNo063w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0220/1424] s390/dasd: Guard sysfs discipline callbacks against unallocated private data
Date: Sat, 12 Sep 2026 08:44:12 +0200
Message-ID: <20260912065612.213602688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 2a1780f9fc2493bd34c418a0be6fc58943afcecf upstream.

Several sysfs show/store handlers call a discipline callback that
dereferences device->private, either directly or through the
DASD_DEFINE_ATTR() macro. During dasd_generic_set_online() the discipline
is assigned before check_device() allocates device->private, so an
unprivileged read of one of these world-readable attributes in that window
dereferences a NULL pointer and panics.

Guard the dereference inside each callback that actually touches
device->private.

Fixes: c729696bcf8b ("s390/dasd: Recognise data for ESE volumes")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260805111612.1285190-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1506,6 +1506,8 @@ static void dasd_eckd_reset_path(struct
 	struct dasd_eckd_private *private = device->private;
 	unsigned long flags;
 
+	if (!private)
+		return;
 	if (!private->fcx_max_data)
 		private->fcx_max_data = get_fcx_max_data(device);
 	spin_lock_irqsave(get_ccwdev_lock(device->cdev), flags);
@@ -1661,6 +1663,9 @@ static int dasd_eckd_is_ese(struct dasd_
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.vol_info.ese;
 }
 
@@ -1668,6 +1673,9 @@ static int dasd_eckd_ext_pool_id(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.extent_pool_id;
 }
 
@@ -1681,6 +1689,9 @@ static int dasd_eckd_space_configured(st
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_configured;
@@ -1695,6 +1706,9 @@ static int dasd_eckd_space_allocated(str
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_allocated;
@@ -1704,6 +1718,9 @@ static int dasd_eckd_logical_capacity(st
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.logical_capacity;
 }
 
@@ -1846,7 +1863,11 @@ static int dasd_eckd_read_ext_pool_info(
 static int dasd_eckd_ext_size(struct dasd_device *device)
 {
 	struct dasd_eckd_private *private = device->private;
-	struct dasd_ext_pool_sum eps = private->eps;
+	struct dasd_ext_pool_sum eps;
+
+	if (!private)
+		return 0;
+	eps = private->eps;
 
 	if (!eps.flags.extent_size_valid)
 		return 0;
@@ -1862,6 +1883,9 @@ static int dasd_eckd_ext_pool_warn_thrsh
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.warn_thrshld;
 }
 
@@ -1869,6 +1893,9 @@ static int dasd_eckd_ext_pool_cap_at_war
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.capacity_at_warnlevel;
 }
 
@@ -1879,6 +1906,9 @@ static int dasd_eckd_ext_pool_oos(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.pool_oos;
 }
 
@@ -5988,8 +6018,11 @@ static int dasd_eckd_query_host_access(s
 	struct ccw1 *ccw;
 	int rc;
 
+	if (!private)
+		return -ENODEV;
+
 	/* not available for HYPER PAV alias devices */
-	if (!device->block && private->lcu->pav == HYPER_PAV)
+	if (!device->block && private->lcu && private->lcu->pav == HYPER_PAV)
 		return -EOPNOTSUPP;
 
 	/* may not be supported by the storage server */
@@ -6854,6 +6887,9 @@ static int dasd_eckd_hpf_enabled(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->fcx_max_data ? 1 : 0;
 }
 


