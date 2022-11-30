Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E8979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C6C433D7;
	Wed, 30 Nov 2022 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834487;
	bh=fZLI1CPH88FenommfFpLbeK1+E6fqz51/ETnB9VyKKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puu+eVsn/5SjnafGqGquZMeSV5nOVLiDdBMkSO71UwzbE2xN1A4/iTOfMRpczd0tK
	 r2U6+JNPsNYMZyWXV/f2ROkZjwfyp3kRVHuGCLUiOv6qdzo1UYaF2h0Ojm6N+R7pnP
	 NKLqK3dQkE4YVRmT7OwT9elEk2lg825nX+fAfCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.0 272/289] btrfs: free btrfs_path before copying inodes to userspace
Date: Wed, 30 Nov 2022 19:24:17 +0100
Message-Id: <20221130180550.264083403@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anand Jain <anand.jain@oracle.com>

commit 418ffb9e3cf6c4e2574d3a732b724916684bd133 upstream.

btrfs_ioctl_logical_to_ino() frees the search path after the userspace
copy from the temp buffer @inodes. Which potentially can lead to a lock
splat.

Fix this by freeing the path before we copy @inodes to userspace.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4282,21 +4282,20 @@ static long btrfs_ioctl_logical_to_ino(s
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
 					  inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -4308,7 +4307,6 @@ static long btrfs_ioctl_logical_to_ino(s
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);


