Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E439D14B967;
	Mon, 16 Sep 2024 12:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488038; cv=none; b=sKj/pv2V9jgcmpvDfdgKcy5WE0bvx0xj7hGVSunIkGmpRvQqZouw+Mkm8HSJZQIpvatDqjUTW1tvBMjrg0yk3YAmSJ7uTkTPBejdarlrbOWqr8Pj7481Umdh3S7UghqOX4TXG8afaJe7OxrQRPAKbvVb1ScnscGQcUHxnCel3nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488038; c=relaxed/simple;
	bh=0zqz7jUdP+kOOer6NX025mgQzu17b5V8ZTF+A/DGVFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFPiEBaBBA3I3EyAB+dF9Dy8JXTTtEa9MS7qmFSs2CpSynk+uY7BqAAiIvYKd3QraH4dobNJl/N71ygY3oRsX0jafjSUdzrnJr7i35eXq8g3WY2+uo/K8emSn/x3lp4z96O1vE0Az2ocGMOtE5JkJzGdDNdxzKOjdd+Wsaq7r3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRvIn+iN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRvIn+iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056EFC4CEC4;
	Mon, 16 Sep 2024 12:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488037;
	bh=0zqz7jUdP+kOOer6NX025mgQzu17b5V8ZTF+A/DGVFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRvIn+iNHvknjsbtbm8ArO0WTtI7Hm7J65nFkUVxPLk+wtVCNj/FXfVprx7RF/H5H
	 bEaFVZfW5atQQ/UKpKhWKwv/1bJGv2S4A2zMihfzNJXYjRd3ww5HxuzvXAT+w3nzFg
	 v1ZKIiHuhN5jJDFP/1tn4pRW+wzpK9Ijd16vthLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/63] btrfs: update target inodes ctime on unlink
Date: Mon, 16 Sep 2024 13:43:48 +0200
Message-ID: <20240916114221.369542460@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 3bc2ac2f8f0b78a13140fc72022771efe0c9b778 ]

Unlink changes the link count on the target inode. POSIX mandates that
the ctime must also change when this occurs.

According to https://pubs.opengroup.org/onlinepubs/9699919799/functions/unlink.html:

"Upon successful completion, unlink() shall mark for update the last data
 modification and last file status change timestamps of the parent
 directory. Also, if the file's link count is not 0, the last file status
 change timestamp of the file shall be marked for update."

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add link to the opengroup docs ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e5017b2ade57..894887640c43 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4379,6 +4379,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
 	dir->vfs_inode.i_mtime = inode->vfs_inode.i_ctime;
-- 
2.43.0



