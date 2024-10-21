Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03221E630C;
	Mon, 21 Oct 2024 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506890; cv=none; b=Mz/oMW6UXllGX4L8ew7H9K8MAGiwY9Iv2cPeKqNGA82YAZAD+1YlgfOsv1Fu7eeGfmVKEXTkui4Fadz/HSskLCJwT6rvV59z32MZU87ZkXVKxHugSagSA3hUWJkcXbOJYGBNVf4dSxyL+1HLqnVLm4Ns/O+KfGWTqI8HggBCjPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506890; c=relaxed/simple;
	bh=p/5Ou8mxr7HH36yAjLRFsAELMG8c+QBR1Pn5bgR8x4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxk2je74o5NU58/Bjw/Ang9czCoZiSy+V6mzSFa2OSqzdIxFO5VTVao3R4lR3XcDpYe1nqOEqeK34Xniwtk2FotNRpuJzORwH+xL8xNCqrcs2cyKIWnzwYh9MivgKWkm4bguIObmP8bna7TH9RL0zZpbpxuKOXumyPLF+TDsQbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=So/7Hopk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="So/7Hopk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E04C4CEC3;
	Mon, 21 Oct 2024 10:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506890;
	bh=p/5Ou8mxr7HH36yAjLRFsAELMG8c+QBR1Pn5bgR8x4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=So/7HopksKZ49r58NfTwPU4mG/fubfORCgomdIrSbbDHw7nVE1G/h+azrUM+s8nyE
	 qO7j5OkOtuqXxWvaQyG+ieI3CCi30tH5XmhTVFSA/801E+0Dpp7ethc9xRBbV65iKk
	 +8iQjofTQ0WB9V1Ox+PGj6rjG43gXTV0vXVBP46E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Roi Martin <jroi.martin@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 002/124] btrfs: fix uninitialized pointer free on read_alloc_one_name() error
Date: Mon, 21 Oct 2024 12:23:26 +0200
Message-ID: <20241021102256.808229649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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
@@ -1846,7 +1846,7 @@ static noinline int replay_one_name(stru
 				    struct btrfs_dir_item *di,
 				    struct btrfs_key *key)
 {
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct btrfs_dir_item *dir_dst_di;
 	struct btrfs_dir_item *index_dst_di;
 	bool dir_dst_matches = false;
@@ -2126,7 +2126,7 @@ static noinline int check_item_in_log(st
 	struct extent_buffer *eb;
 	int slot;
 	struct btrfs_dir_item *di;
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct inode *inode = NULL;
 	struct btrfs_key location;
 


