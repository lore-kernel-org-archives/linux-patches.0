Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C6724B34;
	Tue, 25 Jun 2024 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309201; cv=none; b=A3htV9Az9aju07JU5B4Xjq+wGYFcSqoktjGjUOUtmQkhC3IiXhXcL6VYSpG+4NIJvpR4x9NlsXvSWw41lR8tEbLdyqj/TpX/tYXS3pI9g9g09a7loz5Jc0nhxFsKs6maFbCgLE8EmKTpnMCOPgJcYG4HjY9smzAJPzKtufnjCag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309201; c=relaxed/simple;
	bh=DPxxxi/dmkQ1YlbLkIZHVFmtEwPQPEOOXjcysaB1eq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX8kEqunls3c0og7ZvSgBj9PDkeOfhXNP5+e6VFmyfNYtpMWzWnJcE7nhf9RGZsdY43/LRnD4KbPnGND0M2LZzhlvLyuE/pLJ+gWnQiXV30LJnYz6C5PZSQbspysnfVoF0gViBEJS5B/s36JH/jDXuhsFjxYtNWdpCVtQnNh3OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo22SQxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo22SQxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF03C32789;
	Tue, 25 Jun 2024 09:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309200;
	bh=DPxxxi/dmkQ1YlbLkIZHVFmtEwPQPEOOXjcysaB1eq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo22SQxNL2/rh5Pc6GgCSl3bb6HUQPIlheXPbJidTsAdkC58ooghRKXm+Bd0ZqVth
	 MWDELm74vQh+YR/dQBqSX4pxjLwz/7BnZaKjsclVXV3TvXsqQS2lH2ZRkpraVEyklE
	 kGzWoUSIWAz5PfHG/W0AqrBWWbItJsjY+8HTdQh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 130/192] ext4: avoid overflow when setting values via sysfs
Date: Tue, 25 Jun 2024 11:33:22 +0200
Message-ID: <20240625085542.151013173@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 9e8e819f8f272c4e5dcd0bd6c7450e36481ed139 upstream.

When setting values of type unsigned int through sysfs, we use kstrtoul()
to parse it and then truncate part of it as the final set value, when the
set value is greater than UINT_MAX, the set value will not match what we
see because of the truncation. As follows:

  $ echo 4294967296 > /sys/fs/ext4/sda/mb_max_linear_groups
  $ cat /sys/fs/ext4/sda/mb_max_linear_groups
    0

So we use kstrtouint() to parse the attr_pointer_ui type to avoid the
inconsistency described above. In addition, a judgment is added to avoid
setting s_resv_clusters less than 0.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240319113325.3110393-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/sysfs.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -104,7 +104,7 @@ static ssize_t reserved_clusters_store(s
 	int ret;
 
 	ret = kstrtoull(skip_spaces(buf), 0, &val);
-	if (ret || val >= clusters)
+	if (ret || val >= clusters || (s64)val < 0)
 		return -EINVAL;
 
 	atomic64_set(&sbi->s_resv_clusters, val);
@@ -451,7 +451,8 @@ static ssize_t ext4_attr_store(struct ko
 						s_kobj);
 	struct ext4_attr *a = container_of(attr, struct ext4_attr, attr);
 	void *ptr = calc_ptr(a, sbi);
-	unsigned long t;
+	unsigned int t;
+	unsigned long lt;
 	int ret;
 
 	switch (a->attr_id) {
@@ -460,7 +461,7 @@ static ssize_t ext4_attr_store(struct ko
 	case attr_pointer_ui:
 		if (!ptr)
 			return 0;
-		ret = kstrtoul(skip_spaces(buf), 0, &t);
+		ret = kstrtouint(skip_spaces(buf), 0, &t);
 		if (ret)
 			return ret;
 		if (a->attr_ptr == ptr_ext4_super_block_offset)
@@ -471,10 +472,10 @@ static ssize_t ext4_attr_store(struct ko
 	case attr_pointer_ul:
 		if (!ptr)
 			return 0;
-		ret = kstrtoul(skip_spaces(buf), 0, &t);
+		ret = kstrtoul(skip_spaces(buf), 0, &lt);
 		if (ret)
 			return ret;
-		*((unsigned long *) ptr) = t;
+		*((unsigned long *) ptr) = lt;
 		return len;
 	case attr_inode_readahead:
 		return inode_readahead_blks_store(sbi, buf, len);


