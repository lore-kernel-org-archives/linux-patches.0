Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12561E4106;
	Mon, 21 Oct 2024 10:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507264; cv=none; b=sdD1iv+3XBj++AXnZlsypwSNJkpxbVWyBEzNo9fiQcoD9yRK4+eV4jDewsxRo6XFoJfYFVYSZK7HWA5JTVHsdt+0hwIZRrorX4L/SvlY47tsJUCFzb+r+isjD4xXA4RjDu+ha4RF1wCYKwyC9x6HkupATaByD/18zXiBXgCQ2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507264; c=relaxed/simple;
	bh=lfYPXmg0D90K81EFXGLdCHI7g20szxr7eZqwPzmTSsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKhvQE3IKQISf0zgdmYak/Qthc+ttflsb0EKPIf4/aAWrwY9w1VzfPz95NDLiWbBiDtXG0MI++VFwvUQt5ShIjNcuL2DX9ZHJ6uM+t105OYhsYtu0PHq60LuvDuLj3v3z7V/QnVOrvw8YdaiuB6DD/aFORTtgOgJc6cxw+MTaJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX28PJam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX28PJam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD9AC4CEE5;
	Mon, 21 Oct 2024 10:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507264;
	bh=lfYPXmg0D90K81EFXGLdCHI7g20szxr7eZqwPzmTSsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX28PJamt6fqtaZwPQZHOKooVT77eN3Dc3IeqtZDngO4zush7f5jfzFCoxDNyeKg9
	 Iw7YS+vZHxBk5jwyGi7i1kA8zB+b6r5vUbm1FfE5mBdEdC/klcvUVnNbcLAzYHEpaG
	 wwOVMe7cMP38vM/bbsQkeZNO/iuQIur22zpilOQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	Roi Martin <jroi.martin@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 02/91] btrfs: fix uninitialized pointer free on read_alloc_one_name() error
Date: Mon, 21 Oct 2024 12:24:16 +0200
Message-ID: <20241021102249.891905555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1844,7 +1844,7 @@ static noinline int replay_one_name(stru
 				    struct btrfs_dir_item *di,
 				    struct btrfs_key *key)
 {
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct btrfs_dir_item *dir_dst_di;
 	struct btrfs_dir_item *index_dst_di;
 	bool dir_dst_matches = false;
@@ -2124,7 +2124,7 @@ static noinline int check_item_in_log(st
 	struct extent_buffer *eb;
 	int slot;
 	struct btrfs_dir_item *di;
-	struct fscrypt_str name;
+	struct fscrypt_str name = { 0 };
 	struct inode *inode = NULL;
 	struct btrfs_key location;
 


