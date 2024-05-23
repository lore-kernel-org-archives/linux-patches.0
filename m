Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700D14A4EB;
	Thu, 23 May 2024 13:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470085; cv=none; b=n4XiS/ddUJWoic3q17Y2nw6htJWj+Gzc6e3+QT1jv2X2UE46rnp6yOzysPkrsb7dyHeKUN1RQCn8IOaPsyblGGalj+5ycaYJFWzv630JBqXnvHXmKN5dnQD2r8XXlQmOMJNJ/b0EqyA7P7Oevumz9MnmV2Fd8vonW0oTjRluiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470085; c=relaxed/simple;
	bh=Q0c8k/1Uos3BKpqzPBM9BIAHcJ/je8E+QZ0EoAZaqjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1FXr+Bt3Py08Ka/qs3DAHNiBOzDoojafKYaywDcHFq+LD5TAfXkbf+Av+yTfpUd6Ps9PtxjIrk7/pPFxstp55Zri+5sXbjxBG/28cm7b8YylZ98/TeF+YD9yrBE5lPCJTNTjiKXr0NRZ2zrQaPRjOeCr1wUeV55nqc9vuns8rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRnkRaa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRnkRaa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EDAC4AF0A;
	Thu, 23 May 2024 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470085;
	bh=Q0c8k/1Uos3BKpqzPBM9BIAHcJ/je8E+QZ0EoAZaqjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRnkRaa2SMzd5QFwjv9Eyfy7U+4r1b6Cumm7h6gQ6qxSbKABb7RKtJi5OOxnPFipS
	 gdckrwEBcE6/7k8e3UHfkqaI0gMl3ACZp5xd1/7UhJejveOJW+shgr9gdKlXyS8/DZ
	 PTWMtCm5EVojwi1RSrzGrXP+TdbfTuNmeQU7bdXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Srish Srinivasan <srish.srinivasan@broadcom.com>
Subject: [PATCH 4.19 02/18] dm: limit the number of targets and parameter size area
Date: Thu, 23 May 2024 15:12:25 +0200
Message-ID: <20240523130325.824711860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit bd504bcfec41a503b32054da5472904b404341a4 upstream.

The kvmalloc function fails with a warning if the size is larger than
INT_MAX. The warning was triggered by a syscall testing robot.

In order to avoid the warning, this commit limits the number of targets to
1048576 and the size of the parameter area to 1073741824.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
[srish: Apply to stable branch linux-4.19.y]
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
@@ -1734,7 +1734,8 @@ static int copy_params(struct dm_ioctl _
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
 
-	if (param_kernel->data_size < minimum_data_size)
+	if (unlikely(param_kernel->data_size < minimum_data_size) ||
+	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS))
 		return -EINVAL;
 
 	secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -187,7 +187,12 @@ static int alloc_targets(struct dm_table
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
@@ -202,7 +207,7 @@ int dm_table_create(struct dm_table **re
 
 	if (!num_targets) {
 		kfree(t);
-		return -ENOMEM;
+		return -EOVERFLOW;
 	}
 
 	if (alloc_targets(t, num_targets)) {


