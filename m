Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47013BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E908C433A1;
	Tue,  7 Mar 2023 19:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216254;
	bh=2Cs8n4GlC8ZkUv8O46GWeopKxSFSv0kjhLOw2IejYMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1aA3OfZ3QOGAq19CvaKwXJ1aG3x9fTnsITKytHCxvfogEoepCu5i6aY8eyWUa2eB
	 uHqlTrJiU7AAjgnEKTfuJ4WpnmXb0uEDBwWGXpp/BUq4kpnvm/advhSoOLjnGLj980
	 FVLM5a3Sc9FhkRZkOAG6U6AQMLSjfD5OkxYUBc10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 524/567] ceph: update the time stamps and try to drop the suid/sgid
Date: Tue,  7 Mar 2023 18:04:20 +0100
Message-Id: <20230307165928.661750255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit e027253c4b77d395798600a90b6a96fe4adf4d5e upstream.

The fallocate will try to clear the suid/sgid if a unprevileged user
changed the file.

There is no POSIX item requires that we should clear the suid/sgid
in fallocate code path but this is the default behaviour for most of
the filesystems and the VFS layer. And also the same for the write
code path, which have already support it.

And also we need to update the time stamps since the fallocate will
change the file contents.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/58054
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2084,6 +2084,9 @@ static long ceph_fallocate(struct file *
 	loff_t endoff = 0;
 	loff_t size;
 
+	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
+	     inode, ceph_vinop(inode), mode, offset, length);
+
 	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
@@ -2124,6 +2127,10 @@ static long ceph_fallocate(struct file *
 	if (ret < 0)
 		goto unlock;
 
+	ret = file_modified(file);
+	if (ret)
+		goto put_caps;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	ceph_zero_pagecache_range(inode, offset, length);
 	ret = ceph_zero_objects(inode, offset, length);
@@ -2139,6 +2146,7 @@ static long ceph_fallocate(struct file *
 	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
+put_caps:
 	ceph_put_cap_refs(ci, got);
 unlock:
 	inode_unlock(inode);


