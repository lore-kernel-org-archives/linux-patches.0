Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794DB2931FB;
	Sat, 12 Sep 2026 08:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200135; cv=none; b=N/oIBha2DPX7LsKpqYXM6A6DK+KOEIm0VudD7+JGEYivPnfufITVXdlCDJO9fwLMtixxBE+bcA7Ec1yZ6iXu0UPAhuwDGhvkzOoDq7/197CCs2sIpk+EPFKh61P//l9FPpFz5z6Bozp9bvDYOZKNDZbDp0UklNOiY2AtH2nMazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200135; c=relaxed/simple;
	bh=wiqB825ITWZEP7LzE8/7TzORbJIZkPALmb1GmQqTteA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXI+6rLoUxHJN7iLEGp66gHSgGpbIlNX3xVEWt5zNLI63v8z5Iggc5c2WvyY6Ot1ZuPDzvkCl+2IPs4C0gx+SA2iStnEGa6Ak4BZyagfgb+zKuoA99JJ3lSajXCZu0t8RTYVFcWH7lqGMryaH2RZMloZY6GqDm1d39/5iuUn9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2RLm0c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2RLm0c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AF61F000FF;
	Sat, 12 Sep 2026 08:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200134;
	bh=BtipoxNBy4WVMYtWujOgQty44dCp7lmb4KtqBhdZxcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2RLm0c+e0eeA7xkdhpnL5WKJuJwpEG/8NG2Gof2G3tJ5U6YdYLJD9knxHInilhGy
	 FLIHVwaYTqRncVcGr61GkmXBP43BRlNC6QcwDRPs2KNACXEEeC41eby3ZlvHiUZm/3
	 4eOJlxIj0H7FndBg/Kkk0qG7bzwVXkErRgg4Zd+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0726/1815] nilfs2: prevent out-of-bounds read in super root block parsing
Date: Sat, 12 Sep 2026 08:41:16 +0200
Message-ID: <20260912065705.944140185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit 7cb2f76a6a2ba2130b577cb8ac13e1e46c4fc689 ]

super-root inode metadata size is trusted before nilfs_read_inode_common().

Reject super-root inode sizes whose computed on-disk footprint exceeds the
filesystem block size. This prevents malformed filesystem images from
making nilfs_read_inode_common() read past the end of the super-root block.

[ryusuke: clarify the commit title]

Fixes: 8a9d2191e9f4 ("nilfs2: operations for the_nilfs core object")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7b23e373a106e..f3805e7aabeb5 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -461,6 +461,12 @@ static int nilfs_store_disk_layout(struct the_nilfs *nilfs,
 			  nilfs->ns_inode_size);
 		return -EINVAL;
 	}
+	if (NILFS_SR_BYTES(nilfs->ns_inode_size) > nilfs->ns_blocksize) {
+		nilfs_err(nilfs->ns_sb,
+			  "too large inode size for super root: %d bytes",
+			  nilfs->ns_inode_size);
+		return -EINVAL;
+	}
 
 	nilfs->ns_first_ino = le32_to_cpu(sbp->s_first_ino);
 	if (nilfs->ns_first_ino < NILFS_USER_INO) {
-- 
2.53.0



