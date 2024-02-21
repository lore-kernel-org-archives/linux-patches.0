Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4190A78B7C;
	Wed, 21 Feb 2024 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524895; cv=none; b=VSuvpNi6u0YG+naijd9EfG95Qz24xGjonu++1GfZTq396iTrO637EReY7NgeG6tFd9vYJwdD+TvQMl1UI8tFTCNywjemN++i9i0BlMLKr39hNl7vnSyGsPpnXzzgRdlomkuTwb3VjwvnstU9brWWkdjTMk5R9c9nPbAHsUCbFBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524895; c=relaxed/simple;
	bh=wjxiL/xM9gISPe9huV+/6UAbQMpjjtdij7Ai/HEOiOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFhIfcy+KUtXQ0sHoJlCK+mI2919aiLyFQZEDb5FcdOYcWbgskcSZdTTR2jVoygF6NBxIgbFVcW/MpV42H8mYciSjXKuE3jcQCrRyytNtX6AYt0t5JKqpIiNNhPbW2do8Ffg7BlwOVvIVVWTJgL/T0Bx718rQD2llf3JCw9UOvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdDckFx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdDckFx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32BDC433C7;
	Wed, 21 Feb 2024 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524895;
	bh=wjxiL/xM9gISPe9huV+/6UAbQMpjjtdij7Ai/HEOiOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdDckFx2eZKkE+AsTJYxn1QQJlDg7d1MUqiui3Xoxr6187mZCCM1COgc8FOn1YbHf
	 Ot5URD2qnnAgfRmvDmtWBFAnlvi9vMM9eF1FOby3FrsHsaxCaGIV3o10lUEBt15jCF
	 AGTHPEnyFOMzMNbN/NQ57eODrN87c9kd8tS8Xxgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	He Gao <hegao@google.com>
Subject: [PATCH 5.10 373/379] dm: limit the number of targets and parameter size area
Date: Wed, 21 Feb 2024 14:09:12 +0100
Message-ID: <20240221130006.097771511@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit bd504bcfec41a503b32054da5472904b404341a4 upstream.

The kvmalloc function fails with a warning if the size is larger than
INT_MAX. The warning was triggered by a syscall testing robot.

In order to avoid the warning, this commit limits the number of targets to
1048576 and the size of the parameter area to 1073741824.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: He Gao <hegao@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-core.h  |    2 ++
 drivers/md/dm-ioctl.c |    3 ++-
 drivers/md/dm-table.c |    9 +++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -19,6 +19,8 @@
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
@@ -144,7 +144,12 @@ static int alloc_targets(struct dm_table
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
@@ -158,7 +163,7 @@ int dm_table_create(struct dm_table **re
 
 	if (!num_targets) {
 		kfree(t);
-		return -ENOMEM;
+		return -EOVERFLOW;
 	}
 
 	if (alloc_targets(t, num_targets)) {


