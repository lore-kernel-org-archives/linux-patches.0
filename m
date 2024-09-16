Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDBF14D2B3;
	Mon, 16 Sep 2024 12:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488164; cv=none; b=GHSwZ33OK1aOrVQ/4qFbkh1QjPJQ6S3TUKDSLxmVYMKAEnoZewkI8mgOARG5Wf2Q0Od+sqfV+TOM2ArtVbx3Tv5csVfYmHRswk/eIzpL7d3QgePQJt6vLnjU+ChB3RZBCbi/H4ttjq3V1I0Qt5Qbid3BjrfBMwM1yCUvlVxjpu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488164; c=relaxed/simple;
	bh=Ph/Mjof0bXYeeDtrudUz7WoTBwptYMWlflrB5d12CJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZynA5uSci41wQ6+UCDmQogTwN6ggY+tOxfGH+rkH7vbcmMal4frmoA9d+ECr94h9y5XXu3EuNAG0Y2kTwv22sqSb35jN3B4X8gP8UH8ME4wZgbH9nW2loqSjGCgv3J6jKpRw+oG4dAXhAJ6Vqx7KHCywHKGpaYJIUlZQddIUq3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUDxoTIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUDxoTIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631DFC4CEC7;
	Mon, 16 Sep 2024 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488164;
	bh=Ph/Mjof0bXYeeDtrudUz7WoTBwptYMWlflrB5d12CJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUDxoTIaPa+R5d9qd4PF+X5m6PW7/VLy1rPo2FfhV7rseZkzvl67Mu4ylYdMpoogN
	 odTCitd435EEoeJkJqhlRjsH62prVNLfsDaiuhlyFRb62j3GYWiyB/XA8+qNJwoTo3
	 khzmB1CzldCSuHe1XWZ4ShFNTVyjxw6P/pih3q6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 018/121] btrfs: update target inodes ctime on unlink
Date: Mon, 16 Sep 2024 13:43:12 +0200
Message-ID: <20240916114229.528114260@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2951aa0039fc..5d23421b6243 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4213,6 +4213,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name->len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
  	inode_set_mtime_to_ts(&dir->vfs_inode, inode_set_ctime_current(&dir->vfs_inode));
 	ret = btrfs_update_inode(trans, dir);
-- 
2.43.0



