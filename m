Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BBF2FD1B0;
	Tue, 30 Sep 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243867; cv=none; b=a41bZO7pBeHCqDHLWfUrrpbtbp5cMyKlhjWeYf/5J5iD/nVuCQifVptbGSQlpQbGPI6jnMNJpz6pwvqkGHCnbkxp1eAydoWlfc3OifzFUq9WAXPB1PJXC/N3/4YINhqGZRY4zzCp/hzDQhXiCMJiMJ+FbvShBrPy+g7XJTfAo9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243867; c=relaxed/simple;
	bh=oQ3a8M+S/iOe3dIemdOLZ4/IIyYVfYanChzbvBF7RN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFaqpktmlavD4LIkCYS9emoCVqG4AtslMB+CLe2bdLmPlbYxnWuwlWn+3KIR4F2nGZyC1yjRrkElywQnFK3GyJ4Q1Mm+Uwlu1mrUEay7d+suSqAUww1ZoYmc9HMcBg5D176FqdDBpEKj6gPqOaY1g2dkjcxt/ursmUyMpxrXhOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip04CH4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip04CH4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E98C4CEF0;
	Tue, 30 Sep 2025 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243867;
	bh=oQ3a8M+S/iOe3dIemdOLZ4/IIyYVfYanChzbvBF7RN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ip04CH4dq+zcIJUi4o+jiWSgXEP/EFREhvOiajii1R8TroVV9gDvyKmM0BwKiKo+T
	 oPqfmWEuC/IGoZ6wB3fT7mExVLao3nLv9B0gB0RF/1mm205nOijZE0EzbiTDGEnNyV
	 HUd8yUE5yYJOWXHilNLZdemihL2qIlxcwhjijMg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	kernel test robot <oliver.sang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 41/81] nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*
Date: Tue, 30 Sep 2025 16:46:43 +0200
Message-ID: <20250930143821.391551791@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 025e87f8ea2ae3a28bf1fe2b052bfa412c27ed4a upstream.

When accessing one of the files under /sys/fs/nilfs2/features when
CONFIG_CFI_CLANG is enabled, there is a CFI violation:

  CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision_show+0x0/0x30; expected type: 0xfc392c4d)
  ...
  Call Trace:
   <TASK>
   sysfs_kf_seq_show+0x2a6/0x390
   ? __cfi_kobj_attr_show+0x10/0x10
   kernfs_seq_show+0x104/0x15b
   seq_read_iter+0x580/0xe2b
  ...

When the kobject of the kset for /sys/fs/nilfs2 is initialized, its ktype
is set to kset_ktype, which has a ->sysfs_ops of kobj_sysfs_ops.  When
nilfs_feature_attr_group is added to that kobject via
sysfs_create_group(), the kernfs_ops of each files is sysfs_file_kfops_rw,
which will call sysfs_kf_seq_show() when ->seq_show() is called.
sysfs_kf_seq_show() in turn calls kobj_attr_show() through
->sysfs_ops->show().  kobj_attr_show() casts the provided attribute out to
a 'struct kobj_attribute' via container_of() and calls ->show(), resulting
in the CFI violation since neither nilfs_feature_revision_show() nor
nilfs_feature_README_show() match the prototype of ->show() in 'struct
kobj_attribute'.

Resolve the CFI violation by adjusting the second parameter in
nilfs_feature_{revision,README}_show() from 'struct attribute' to 'struct
kobj_attribute' to match the expected prototype.

Link: https://lkml.kernel.org/r/20250906144410.22511-1-konishi.ryusuke@gmail.com
Fixes: aebe17f68444 ("nilfs2: add /sys/fs/nilfs2/features group")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202509021646.bc78d9ef-lkp@intel.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/sysfs.c |    4 ++--
 fs/nilfs2/sysfs.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1081,7 +1081,7 @@ void nilfs_sysfs_delete_device_group(str
  ************************************************************************/
 
 static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
-					    struct attribute *attr, char *buf)
+					    struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%d.%d\n",
 			NILFS_CURRENT_REV, NILFS_MINOR_REV);
@@ -1093,7 +1093,7 @@ static const char features_readme_str[]
 	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
 
 static ssize_t nilfs_feature_README_show(struct kobject *kobj,
-					 struct attribute *attr,
+					 struct kobj_attribute *attr,
 					 char *buf)
 {
 	return sysfs_emit(buf, features_readme_str);
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -50,16 +50,16 @@ struct nilfs_sysfs_dev_subgroups {
 	struct completion sg_segments_kobj_unregister;
 };
 
-#define NILFS_COMMON_ATTR_STRUCT(name) \
+#define NILFS_KOBJ_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
 	struct attribute attr; \
-	ssize_t (*show)(struct kobject *, struct attribute *, \
+	ssize_t (*show)(struct kobject *, struct kobj_attribute *, \
 			char *); \
-	ssize_t (*store)(struct kobject *, struct attribute *, \
+	ssize_t (*store)(struct kobject *, struct kobj_attribute *, \
 			 const char *, size_t); \
 }
 
-NILFS_COMMON_ATTR_STRUCT(feature);
+NILFS_KOBJ_ATTR_STRUCT(feature);
 
 #define NILFS_DEV_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \


