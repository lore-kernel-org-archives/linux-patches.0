Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447832DCF57;
	Fri,  4 Sep 2026 05:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499724; cv=none; b=OtfF2+2JE6vaDXkHUED+GUbFqDU2/BmQV5Ojv1Y3YjlC/3zrjvc4MS163UNCULu3K7DX/q7EslKZUjz64lxiTGd9KF8+wk9vTr0mfvKnuAqrt/RuckOwiZ79F2U7zQghKGQPqI2lir12RNuphasW9KV6phKQlfCUg605/4z+bgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499724; c=relaxed/simple;
	bh=lFtoGp/YVgL70WjJL3nod/4IOazbsG0Nbj5/2lFSoC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ofUnjRNwdZrbi9zzzfD7Km17uq0VNqZhWQGN0vv8tcGu4AcTEuepsAnNXwRUVr1tz7IqtSdQPK1AuKAfUJnH8f8kbGwaW9ZFcf3kK6V1OFS0XKolzzgeQ1O+mNBcdyQszgUgqaPBQV8XWIsfP5Bi0z8m5KLDufuGyZr4koJ4DOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPQS3UaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPQS3UaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9F31F00A3D;
	Fri,  4 Sep 2026 05:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499723;
	bh=dILjZysDqunsKa1jbCU3hg8yuSTSpasQBNV69o1db4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPQS3UaK3bRnmFwL1ahhp2Fe+jE6xujBLhzWjYZ6QDOinQ3n2NdvAEuSSqsJWIDfO
	 a5BwU9yb96Beh4Bbm9FHMblZEPCmmvaVeuovc/2PxEk/U2+BOlO0gBqKudY2nXEVgp
	 c/Np6PT81hUHCZ2Ny6a4xiOp7uli9aK8jkPLResQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 518/713] s390/dasd: Guard sysfs discipline callbacks against unallocated private data
Date: Fri,  4 Sep 2026 06:58:06 +0200
Message-ID: <20260904045815.428897075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1492,6 +1492,8 @@ static void dasd_eckd_reset_path(struct
 	struct dasd_eckd_private *private = device->private;
 	unsigned long flags;
 
+	if (!private)
+		return;
 	if (!private->fcx_max_data)
 		private->fcx_max_data = get_fcx_max_data(device);
 	spin_lock_irqsave(get_ccwdev_lock(device->cdev), flags);
@@ -1647,6 +1649,9 @@ static int dasd_eckd_is_ese(struct dasd_
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.vol_info.ese;
 }
 
@@ -1654,6 +1659,9 @@ static int dasd_eckd_ext_pool_id(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.extent_pool_id;
 }
 
@@ -1667,6 +1675,9 @@ static int dasd_eckd_space_configured(st
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_configured;
@@ -1681,6 +1692,9 @@ static int dasd_eckd_space_allocated(str
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_allocated;
@@ -1690,6 +1704,9 @@ static int dasd_eckd_logical_capacity(st
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.logical_capacity;
 }
 
@@ -1832,7 +1849,11 @@ static int dasd_eckd_read_ext_pool_info(
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
@@ -1848,6 +1869,9 @@ static int dasd_eckd_ext_pool_warn_thrsh
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.warn_thrshld;
 }
 
@@ -1855,6 +1879,9 @@ static int dasd_eckd_ext_pool_cap_at_war
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.capacity_at_warnlevel;
 }
 
@@ -1865,6 +1892,9 @@ static int dasd_eckd_ext_pool_oos(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.pool_oos;
 }
 
@@ -5938,8 +5968,11 @@ static int dasd_eckd_query_host_access(s
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
@@ -6804,6 +6837,9 @@ static int dasd_eckd_hpf_enabled(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->fcx_max_data ? 1 : 0;
 }
 


