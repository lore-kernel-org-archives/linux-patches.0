Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811FE43AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKfMRP2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3083EC433C7;
	Wed, 15 Nov 2023 20:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081182;
	bh=8JVZBlAIfDDgam422cNFAA/nmpNz+nzxDQsr6N5vxts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKfMRP2J+/Idd+iEsxmhX8lF3+qgpDhN0ug1VA9LgftmYD9xbZnevRn5NXz8Zr38Q
	 xQV7QbkhV4jLIBcG9GynBAP+pC4k8KtMx1uu3mzsHfwRiqN8w3hVy3esQZtLcaBr1Q
	 IUstQBbvRes6v0U0t36eoCytbvrV8uXPwW9xRW8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 88/88] btrfs: use u64 for buffer sizes in the tree search ioctls
Date: Wed, 15 Nov 2023 15:36:40 -0500
Message-ID: <20231115191431.338512411@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit dec96fc2dcb59723e041416b8dc53e011b4bfc2e ]

In the tree search v2 ioctl we use the type size_t, which is an unsigned
long, to track the buffer size in the local variable 'buf_size'. An
unsigned long is 32 bits wide on a 32 bits architecture. The buffer size
defined in struct btrfs_ioctl_search_args_v2 is a u64, so when we later
try to copy the local variable 'buf_size' to the argument struct, when
the search returns -EOVERFLOW, we copy only 32 bits which will be a
problem on big endian systems.

Fix this by using a u64 type for the buffer sizes, not only at
btrfs_ioctl_tree_search_v2(), but also everywhere down the call chain
so that we can use the u64 at btrfs_ioctl_tree_search_v2().

Fixes: cc68a8a5a433 ("btrfs: new ioctl TREE_SEARCH_V2")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/linux-btrfs/ce6f4bd6-9453-4ffe-ba00-cee35495e10f@moroto.mountain/
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e3f18edc1afee..23beabb489231 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2045,7 +2045,7 @@ static noinline int key_in_sk(struct btrfs_key *key,
 static noinline int copy_to_sk(struct btrfs_path *path,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
-			       size_t *buf_size,
+			       u64 *buf_size,
 			       char __user *ubuf,
 			       unsigned long *sk_offset,
 			       int *num_found)
@@ -2177,7 +2177,7 @@ static noinline int copy_to_sk(struct btrfs_path *path,
 
 static noinline int search_ioctl(struct inode *inode,
 				 struct btrfs_ioctl_search_key *sk,
-				 size_t *buf_size,
+				 u64 *buf_size,
 				 char __user *ubuf)
 {
 	struct btrfs_fs_info *info = btrfs_sb(inode->i_sb);
@@ -2249,7 +2249,7 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	struct btrfs_ioctl_search_key sk;
 	struct inode *inode;
 	int ret;
-	size_t buf_size;
+	u64 buf_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2283,8 +2283,8 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 	struct btrfs_ioctl_search_args_v2 args;
 	struct inode *inode;
 	int ret;
-	size_t buf_size;
-	const size_t buf_limit = SZ_16M;
+	u64 buf_size;
+	const u64 buf_limit = SZ_16M;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-- 
2.42.0



