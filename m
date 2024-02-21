Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FF738398;
	Wed, 21 Feb 2024 13:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523528; cv=none; b=VHABhv52FW1Hx1xcUGks8nvAaLzm2xVyeb+WVkATu6vIHqDNyFR+mXv/2Q+sI928ttkePDZu3r+KqeKiW9m6gu8i5b7MxNeITf4u2lfcl3fV7ceM7SjfM9hej85nF1No8GKhfac5srRmsBtLJ+rJ2TCcf/7ZNs1ipD8B+RSv/Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523528; c=relaxed/simple;
	bh=8Wp4h5vgo24+XAg14Kop0KbrmYC/eKwvxdCAmfxQB1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiBP31Twh+T9Ircm2d01P4rY7NSM+6mLivoLW5J+3c1CThHy2opPP7Y7Xfi+kRcCoMu3A+pybzQsvuooghtv6f7IwBeEas4C5YURJz1kFwuopvCCSxA2DildAjliA6uf5mcQMxRAxpdaTO1unxXULbDU7TKB0ZjWrqDx8xBc95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPspnlDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPspnlDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157F5C43394;
	Wed, 21 Feb 2024 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523528;
	bh=8Wp4h5vgo24+XAg14Kop0KbrmYC/eKwvxdCAmfxQB1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPspnlDuHTk94Jdjyk/Yh7vZE5z2hrzAJKqmjv0TfT2Ct5BHVhn1T/Wds4zUrNKzJ
	 E5yONK3Vr+Zh8jvsHoIkV3bEVYXAN0seDty7gwGEw+16qx03R2usBTJUj7xzk7dHnH
	 /QVaKs236xF8fJlospE/cTE4aLAMF3A9BfpjXN8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	He Gao <hegao@google.com>
Subject: [PATCH 5.15 464/476] dm: limit the number of targets and parameter size area
Date: Wed, 21 Feb 2024 14:08:35 +0100
Message-ID: <20240221130025.188437292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21,6 +21,8 @@
 #include "dm-ima.h"
 
 #define DM_RESERVED_MAX_IOS		1024
+#define DM_MAX_TARGETS			1048576
+#define DM_MAX_TARGET_PARAMS		1024
 
 struct dm_kobject_holder {
 	struct kobject kobj;
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1859,7 +1859,8 @@ static int copy_params(struct dm_ioctl _
 	if (copy_from_user(param_kernel, user, minimum_data_size))
 		return -EFAULT;
 
-	if (param_kernel->data_size < minimum_data_size)
+	if (unlikely(param_kernel->data_size < minimum_data_size) ||
+	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS))
 		return -EINVAL;
 
 	secure_data = param_kernel->flags & DM_SECURE_DATA_FLAG;
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -126,7 +126,12 @@ static int alloc_targets(struct dm_table
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
@@ -140,7 +145,7 @@ int dm_table_create(struct dm_table **re
 
 	if (!num_targets) {
 		kfree(t);
-		return -ENOMEM;
+		return -EOVERFLOW;
 	}
 
 	if (alloc_targets(t, num_targets)) {


