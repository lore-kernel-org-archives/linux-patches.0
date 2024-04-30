Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C9D17592;
	Tue, 30 Apr 2024 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476327; cv=none; b=amQS6/m08o+BAB+8MRjI2+ZHze2m92vt/tLp7LnwmeQBitDQkpVumd/NJGLqa3oGcaVZ0f0rgSCosV9o+xllvyRlKQIWw+zT5uh+x4WfX+RplVYyKQ/wJceDTBrCh2TJIBdIezq1WLZWfWMvCBG5M2zx0CxFL3MUlXx/JtIUK3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476327; c=relaxed/simple;
	bh=ghxOQxqgBBREFQj0o1DwNFpGx/4relanajtpITxGlW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjzLdrfpfJGg919xNPvRYnmVMwox5XlkPpi1K6mHafzTEzvH75Vix2vWw27uYR7Ht9LRAO8Dqs6iuxf//zJMKWccr1tFPapYUkh0BuEcpl1q7tChM1Qp2uVbknFvfn9LAyI003D/QrLCRc+6V1gISORU6t/yUAf6jGFG3WOYfk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMAiWDLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMAiWDLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E115C2BBFC;
	Tue, 30 Apr 2024 11:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476326;
	bh=ghxOQxqgBBREFQj0o1DwNFpGx/4relanajtpITxGlW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMAiWDLEbUtbwUoLIuwQ7SaI0aqjuvDDjAcYBZ2m6DrvbgDXM+th/qVneMIlzKpL+
	 N4CsTr8I7RhQMs3PuzERZHWIWOFg93jxWPpE1Og/H/+HULKExFI3t3gm5kOCe302kH
	 xH74HiJBoCcVk1snjaCoNB57IYsJjdy2xH3J5Vuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Srish Srinivasan <srish.srinivasan@broadcom.com>
Subject: [PATCH 5.4 105/107] dm: limit the number of targets and parameter size area
Date: Tue, 30 Apr 2024 12:41:05 +0200
Message-ID: <20240430103047.757379292@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit bd504bcfec41a503b32054da5472904b404341a4 upstream.

The kvmalloc function fails with a warning if the size is larger than
INT_MAX. The warning was triggered by a syscall testing robot.

In order to avoid the warning, this commit limits the number of targets to
1048576 and the size of the parameter area to 1073741824.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
[srish: Apply to stable branch linux-5.4.y]
Signed-off-by: Srish Srinivasan <srish.srinivasan@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h  |    2 ++
 drivers/md/dm-ioctl.c |    3 ++-
 drivers/md/dm-table.c |    9 +++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -18,6 +18,8 @@
 #include "dm.h"
 
 #define DM_RESERVED_MAX_IOS		1024
+#define DM_MAX_TARGETS			1048576
+#define DM_MAX_TARGET_PARAMS		1024
 
 struct dm_kobject_holder {
 	struct kobject kobj;
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1760,7 +1760,8 @@ static int copy_params(struct dm_ioctl _
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
 
-	if (param_kernel->data_size < minimum_data_size)
+	if (unlikely(param_kernel->data_size < minimum_data_size) ||
+	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS))
 		return -EINVAL;
 
 	secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -184,7 +184,12 @@ static int alloc_targets(struct dm_table
 int dm_table_create(struct dm_table **result, fmode_t mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t;
+
+	if (num_targets > DM_MAX_TARGETS)
+		return -EOVERFLOW;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
 
 	if (!t)
 		return -ENOMEM;
@@ -199,7 +204,7 @@ int dm_table_create(struct dm_table **re
 
 	if (!num_targets) {
 		kfree(t);
-		return -ENOMEM;
+		return -EOVERFLOW;
 	}
 
 	if (alloc_targets(t, num_targets)) {


