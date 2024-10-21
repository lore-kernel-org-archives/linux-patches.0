Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E821E5020;
	Mon, 21 Oct 2024 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506452; cv=none; b=MKIItSXGfjBAmLVjUjMbs03DSLR+RGgBSG5BertQtQZGvhTIuq7H0Ov8iR8DUcU5xmLJNUaEIjDC3+GcWAJMS9iuQxiX9BtMSh6nv1q2Pa/umM9fxOnVIw1njS6fbYy7NgxKnxNc9gNyj1jglPqi1r8e50uAyaTcqpWXqklO+K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506452; c=relaxed/simple;
	bh=o87Tmyti0HxQbtyAzluPK0kdYL+uI0YxUvGePAfJF0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ/PlQVe/Ni5oSEi08nhnhMKMVoqAW727c4gMt8A1EYP14kXObqEwj+t2+CgAH8VrM2tpggpOaMIaZfAbFlM/r/guDVWjiTE+hQv2buVHSNh7Uxz49p9LbmRnpEbP5R9twIaV/QNrFjfgHzPflFVwOpUGQsJnTcBh1aqVYIfTC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRn+VA2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRn+VA2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86576C4CEC3;
	Mon, 21 Oct 2024 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506451;
	bh=o87Tmyti0HxQbtyAzluPK0kdYL+uI0YxUvGePAfJF0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRn+VA2GuqQ9csUFSkRX/oLYN2qkVeoNMbFf8V/vSAv8zIsUg6KJ5TEsxcuer/Yr5
	 ud44bsD7Q75cjybe3bHEJkWfjG4cVc/IGSvWKIpcZcShEllsW48bzArsc00qu/gxqm
	 +gWbLTW8jnxmL5xu9hq2HD7D+UpUEW4WUiFLm/4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Roi Martin <jroi.martin@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 002/135] btrfs: fix uninitialized pointer free on read_alloc_one_name() error
Date: Mon, 21 Oct 2024 12:22:38 +0200
Message-ID: <20241021102259.425712451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roi Martin <jroi.martin@gmail.com>

commit 2ab5e243c2266c841e0f6904fad1514b18eaf510 upstream.

The function read_alloc_one_name() does not initialize the name field of
the passed fscrypt_str struct if kmalloc fails to allocate the
corresponding buffer.  Thus, it is not guaranteed that
fscrypt_str.name is initialized when freeing it.

This is a follow-up to the linked patch that fixes the remaining
instances of the bug introduced by commit e43eec81c516 ("btrfs: use
struct qstr instead of name and namelen pairs").

Link: https://lore.kernel.org/linux-btrfs/20241009080833.1355894-1-jroi.martin@gmail.com/
Fixes: e43eec81c516 ("btrfs: use struct qstr instead of name and namelen pairs")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Roi Martin <jroi.martin@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1845,7 +1845,7 @@ static noinline int replay_one_name(stru
 				    struct btrfs_dir_item *di,
 				    struct btrfs_key *key)
 {
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct btrfs_dir_item *dir_dst_di;
 	struct btrfs_dir_item *index_dst_di;
 	bool dir_dst_matches = false;
@@ -2125,7 +2125,7 @@ static noinline int check_item_in_log(st
 	struct extent_buffer *eb;
 	int slot;
 	struct btrfs_dir_item *di;
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct inode *inode = NULL;
 	struct btrfs_key location;
 


