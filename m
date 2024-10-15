Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61741D90CD;
	Tue, 15 Oct 2024 11:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992101; cv=none; b=nuH+5UlecuyBRZS65uOXWQl3PmL4K4z/NGsjvjhKmF66aYmmnDxFSye5iFAR/qgCYu7aj/yz1Ca6GHW6HELb4B2oWHpL1/0pIcOFksNFf7m8q07uAfL+UHhvEbOt2qP7EYZoRoNOfK914rz+wPdnqKV6qvXAhjQTI1X+Cd8yd3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992101; c=relaxed/simple;
	bh=tVDoqwEvHFwRIIBsk+EXRrKCHmsipiBUkE+EBzlE25o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHigd8UCkPrvha0KRlb2Ns7Sm8vDIlPHkVrR5BmuqMiNadfPRVs3aPTTYNvXtWVrKO3/zsS3yVxHEPb+pykj3fhd7u3YYPYrtB8GPLytZfmVxLuP51ytjeYTiGy12WfhFXYyIbZ3Bv3DQjQWQXP/V71ApPu4YIyA6caUdASZA/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6ZNOtuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6ZNOtuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E420C4CECE;
	Tue, 15 Oct 2024 11:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992101;
	bh=tVDoqwEvHFwRIIBsk+EXRrKCHmsipiBUkE+EBzlE25o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6ZNOtuC/03UfVoa1oLYtklKmR9jdKFSzE6Tnes5Dd64+7zmDbyvuMoUDzyXCzlXn
	 peJsS0/r0Ce0N5UKEgSxM9wLFwVHfmamGRS6jFIFDsAVot6JeP4KL9vqi9FUDnvqW0
	 aVPmikkLgioHqXhuQ9M3d4DkCnR6RLi6Jef6vHbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/691] btrfs: update target inodes ctime on unlink
Date: Tue, 15 Oct 2024 13:19:27 +0200
Message-ID: <20241015112441.096990789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f7807f36c8e3..eb12ba64ac7a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4199,6 +4199,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - name_len * 2);
 	inode_inc_iversion(&inode->vfs_inode);
+	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
 	inode->vfs_inode.i_ctime = dir->vfs_inode.i_mtime =
 		dir->vfs_inode.i_ctime = current_time(&inode->vfs_inode);
-- 
2.43.0



