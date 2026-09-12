Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72FF279DC3;
	Sat, 12 Sep 2026 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241465; cv=none; b=lEqfcK97UYH3hcEh2XERUWLhV1KG9ijxDQVflm+V5k4n1nojfBuFB6KObhyL/bTKIx5ziFzvXryRIbCss9+dD6UgpfWcJ5GJArmJob8Dk5evzEMUHRAWIdWYBgm4/OUflaA0tlxOh1EqLMH4IdRW1tR5MW0JEYLj36rIeMnJhJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241465; c=relaxed/simple;
	bh=DVKFZT1RTLERjDGitliFkm2BYVGx3PDXJVsFVDIOeo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxuZc/IdJwM5BP731WHNbECvcrrJj7f7ISoSSFSv6123P0KxlH1BYWlmU+bO4ZXwewdeDKzimFsjOjXcwj7OrsssZzM91vsPWyrc3T2Jg4GTWNAEOqs85EWIDHaGc+WWiOCLsTmg6nnmO0UGJPwwSkC9G3ncL2SQocTeXodYtno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9ybiLS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9ybiLS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA4A1F000FF;
	Sat, 12 Sep 2026 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241463;
	bh=lL7GUK0iVBPF7wZ9AwRgMVZhSURT5kxta1uzVbl1c7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9ybiLS+NvCzZXOkKiU1NoJf0FPVdfZyacUSpR2WvQc8b2IoMt24Ik99/tijkV85Z
	 H3HZC7xKkkXM4ag2hOSvY+Q3pp0eag0rm0oI4g8RgDLxQvn6BWdJHVk/iEMbcDx7i2
	 ZBA+1GJ7gtdnxx4HlZrw5l3vGvxF4TBisOMgNXDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 140/798] s390/dasd: Guard sysfs discipline callbacks against unallocated private data
Date: Sat, 12 Sep 2026 08:56:08 +0200
Message-ID: <20260912065520.189475435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1464,6 +1464,8 @@ static void dasd_eckd_reset_path(struct
 	struct dasd_eckd_private *private = device->private;
 	unsigned long flags;
 
+	if (!private)
+		return;
 	if (!private->fcx_max_data)
 		private->fcx_max_data = get_fcx_max_data(device);
 	spin_lock_irqsave(get_ccwdev_lock(device->cdev), flags);
@@ -1619,6 +1621,9 @@ static int dasd_eckd_is_ese(struct dasd_
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.vol_info.ese;
 }
 
@@ -1626,6 +1631,9 @@ static int dasd_eckd_ext_pool_id(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.extent_pool_id;
 }
 
@@ -1639,6 +1647,9 @@ static int dasd_eckd_space_configured(st
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_configured;
@@ -1653,6 +1664,9 @@ static int dasd_eckd_space_allocated(str
 	struct dasd_eckd_private *private = device->private;
 	int rc;
 
+	if (!private)
+		return 0;
+
 	rc = dasd_eckd_read_vol_info(device);
 
 	return rc ? : private->vsq.space_allocated;
@@ -1662,6 +1676,9 @@ static int dasd_eckd_logical_capacity(st
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->vsq.logical_capacity;
 }
 
@@ -1804,7 +1821,11 @@ static int dasd_eckd_read_ext_pool_info(
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
@@ -1820,6 +1841,9 @@ static int dasd_eckd_ext_pool_warn_thrsh
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.warn_thrshld;
 }
 
@@ -1827,6 +1851,9 @@ static int dasd_eckd_ext_pool_cap_at_war
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.capacity_at_warnlevel;
 }
 
@@ -1837,6 +1864,9 @@ static int dasd_eckd_ext_pool_oos(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->eps.flags.pool_oos;
 }
 
@@ -5966,8 +5996,11 @@ static int dasd_eckd_query_host_access(s
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
@@ -6607,6 +6640,9 @@ static int dasd_eckd_hpf_enabled(struct
 {
 	struct dasd_eckd_private *private = device->private;
 
+	if (!private)
+		return 0;
+
 	return private->fcx_max_data ? 1 : 0;
 }
 


