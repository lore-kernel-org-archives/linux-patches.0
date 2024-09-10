Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E29193418;
	Tue, 10 Sep 2024 10:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964123; cv=none; b=LQAbQDtx7WiJi6+4poLz7JIa18urO4hAegchX8LG4tQr44QxhqmUM2nS6NKni+J+7f5gb9eUUmoZbt4G/YRM9IRjiUo6H4duuGfKzAqfOeu/CDUCZigv/HNUqxRxR/QQKGHzpoul5pxL19/jqkISdu8biCYwUBvykWbdVxr5tT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964123; c=relaxed/simple;
	bh=UTMfh45jex3eBPH3jYzkMYNzl3c6t8cUgaUyrgDMHFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcwQi2QwM7sj8WHfDnAKzfJVx7/NLja4snkKDFyjcZvszIyeCtuNZf5Uw5EAPM5eR5FsLVeHXG5KAU+2vsrByUObEiK5we4UJQMwpvkMhvlD1X4fhnyuTKsU8zRkDk2S4mBVcT/xp+gx/qFn4XQvBQ1z02bAS/l4NR+WsORy7XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDMNCA26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDMNCA26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006CEC4CEC6;
	Tue, 10 Sep 2024 10:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964123;
	bh=UTMfh45jex3eBPH3jYzkMYNzl3c6t8cUgaUyrgDMHFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDMNCA263ZQ9CPD3X465UKS1FXKx80q2gBtPeCZpkr/8QMmKyvbTfa6pD2d1z9Vea
	 tPYisWfjRdDkUDl+MbvPrn5o4qXnZetCKDyd6JYy/qUrDOvgYnABJ0yKneWIn83sX2
	 cD4S2PTQfScsmwO7eZcrjXAJ1C9mtoLgjgQfYapM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 058/269] nilfs2: protect references to superblock parameters exposed in sysfs
Date: Tue, 10 Sep 2024 11:30:45 +0200
Message-ID: <20240910092610.280913605@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 683408258917541bdb294cd717c210a04381931e upstream.

The superblock buffers of nilfs2 can not only be overwritten at runtime
for modifications/repairs, but they are also regularly swapped, replaced
during resizing, and even abandoned when degrading to one side due to
backing device issues.  So, accessing them requires mutual exclusion using
the reader/writer semaphore "nilfs->ns_sem".

Some sysfs attribute show methods read this superblock buffer without the
necessary mutual exclusion, which can cause problems with pointer
dereferencing and memory access, so fix it.

Link: https://lkml.kernel.org/r/20240811100320.9913-1-konishi.ryusuke@gmail.com
Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/sysfs.c |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -836,9 +836,15 @@ ssize_t nilfs_dev_revision_show(struct n
 				struct the_nilfs *nilfs,
 				char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u32 major = le32_to_cpu(sbp[0]->s_rev_level);
-	u16 minor = le16_to_cpu(sbp[0]->s_minor_rev_level);
+	struct nilfs_super_block *raw_sb;
+	u32 major;
+	u16 minor;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	major = le32_to_cpu(raw_sb->s_rev_level);
+	minor = le16_to_cpu(raw_sb->s_minor_rev_level);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%d.%d\n", major, minor);
 }
@@ -856,8 +862,13 @@ ssize_t nilfs_dev_device_size_show(struc
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
-	u64 dev_size = le64_to_cpu(sbp[0]->s_dev_size);
+	struct nilfs_super_block *raw_sb;
+	u64 dev_size;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	dev_size = le64_to_cpu(raw_sb->s_dev_size);
+	up_read(&nilfs->ns_sem);
 
 	return sysfs_emit(buf, "%llu\n", dev_size);
 }
@@ -879,9 +890,15 @@ ssize_t nilfs_dev_uuid_show(struct nilfs
 			    struct the_nilfs *nilfs,
 			    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = sysfs_emit(buf, "%pUb\n", raw_sb->s_uuid);
+	up_read(&nilfs->ns_sem);
 
-	return sysfs_emit(buf, "%pUb\n", sbp[0]->s_uuid);
+	return len;
 }
 
 static
@@ -889,10 +906,16 @@ ssize_t nilfs_dev_volume_name_show(struc
 				    struct the_nilfs *nilfs,
 				    char *buf)
 {
-	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	struct nilfs_super_block *raw_sb;
+	ssize_t len;
+
+	down_read(&nilfs->ns_sem);
+	raw_sb = nilfs->ns_sbp[0];
+	len = scnprintf(buf, sizeof(raw_sb->s_volume_name), "%s\n",
+			raw_sb->s_volume_name);
+	up_read(&nilfs->ns_sem);
 
-	return scnprintf(buf, sizeof(sbp[0]->s_volume_name), "%s\n",
-			 sbp[0]->s_volume_name);
+	return len;
 }
 
 static const char dev_readme_str[] =


