Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314DF664A6;
	Tue, 23 Jan 2024 01:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975105; cv=none; b=Sc/cwLiy+3+nqNlJbSf9O1GWFrLW4kUgfN1kkIjAfgLZTHRxsoILR3XgP8CMf2auZiWvu67BmFSyaQtYmeNXUfGXceTkUkGPzsFWMQXdCwRGIPMqggtPl1wpEkujauRSDPRgPW8pYvuASSPEGYOuluuRkfoK6Jca7r2gT2/qtwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975105; c=relaxed/simple;
	bh=t/w17yUKIbwoUFo5iyripnqEI4Xw5LMIyDlihZAgtqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBX0n6x8870VnPnqc+E1mkd8TppDQsUba2IxREajDwEaS6+qDuQYfAt/iriwN6nYS3Ydo248NYZgP5RI9hyBIRqPA/Ljk4wASmvaNBCuirUQPxtVU9LSjr4z5+p1657VJHe2X6u/yuGmFpO2U0uoQ+sAYdLjsCBWR4uVuM5FpzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWKGwzys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWKGwzys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B80C433C7;
	Tue, 23 Jan 2024 01:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975105;
	bh=t/w17yUKIbwoUFo5iyripnqEI4Xw5LMIyDlihZAgtqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWKGwzysVAMOJGlvmvyWMfgg4OIjkWArVjbxOaAUnZfpY9e0766XwsJv/Ou8woQuj
	 lPOqKDIutujYEi+v0k3BVVubN83jC2DzYiXI1iutK/HIPu/rXfW/v1RpmMAhvDGjYB
	 XRjKP/qENhquxcIKnww1Ik982Kqn6afHzExnT5SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/583] f2fs: fix to avoid dirent corruption
Date: Mon, 22 Jan 2024 15:54:51 -0800
Message-ID: <20240122235819.344227992@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 53edb549565f55ccd0bdf43be3d66ce4c2d48b28 ]

As Al reported in link[1]:

f2fs_rename()
...
	if (old_dir != new_dir && !whiteout)
		f2fs_set_link(old_inode, old_dir_entry,
					old_dir_page, new_dir);
	else
		f2fs_put_page(old_dir_page, 0);

You want correct inumber in the ".." link.  And cross-directory
rename does move the source to new parent, even if you'd been asked
to leave a whiteout in the old place.

[1] https://lore.kernel.org/all/20231017055040.GN800259@ZenIV/

With below testcase, it may cause dirent corruption, due to it missed
to call f2fs_set_link() to update ".." link to new directory.
- mkdir -p dir/foo
- renameat2 -w dir/foo bar

[ASSERT] (__chk_dots_dentries:1421)  --> Bad inode number[0x4] for '..', parent parent ino is [0x3]
[FSCK] other corrupted bugs                           [Fail]

Fixes: 7e01e7ad746b ("f2fs: support RENAME_WHITEOUT")
Cc: Jan Kara <jack@suse.cz>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 193b22a2d6bf..02d9c47797be 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1106,7 +1106,7 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	}
 
 	if (old_dir_entry) {
-		if (old_dir != new_dir && !whiteout)
+		if (old_dir != new_dir)
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
 		else
-- 
2.43.0



