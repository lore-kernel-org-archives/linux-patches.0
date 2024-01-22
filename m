Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C6B145B34;
	Tue, 23 Jan 2024 00:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968375; cv=none; b=s4rsOneIwR8G+icfV7Ob0HQO/Zn9DPXkZq0LdGp1b5L3wkGc+RVBfHiBjUkQ5J8PMPXkZQ965f3ryVeFEqFKBhQkkn1Fbk7ptoG4utS313/VmLrTWAQWY8l+wepceVSFRGnJtGlTLqGfp+n88ASJq1eZ50R+8dLNDFbTifTHohY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968375; c=relaxed/simple;
	bh=7wAFtwfLz0ybB6NvZ3tdflln7zmyvvmtf2a3PXgktuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTgbJ5NsiY7rZ1mpFEo1E8IhZY8F7pj3u2GVW+a4FdMRCKx6vsMmVD40lNct4Uu+q1AXBo3xzvmDMe8jrhFgJ2JJKfdffDNlx5cw77cYYhZzAWbVbEHrant8Qw1uJqEtxANTil7TTc6m8jIRqjg5XYI0vHayWVKr0w22Ug5b/BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqKlWu62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqKlWu62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1874C433C7;
	Tue, 23 Jan 2024 00:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968375;
	bh=7wAFtwfLz0ybB6NvZ3tdflln7zmyvvmtf2a3PXgktuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqKlWu62NXwd3gAoo/oDgpr0VTFO56Sf4QQY/BZdscxuRhE17XQZQY7+konJmQNqP
	 436y5GbHR6cTmR1dI4kG1El50HnO8AzWoIZMejzDxEUIsvTXhxorLUsx2tnDcb8Rdc
	 tgxYWi4EghN8kVs+3iiLzzYIeeIkK/LCp2WlJQTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/148] f2fs: fix to avoid dirent corruption
Date: Mon, 22 Jan 2024 15:57:25 -0800
Message-ID: <20240122235715.990003206@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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
index 9e4c38481830..2eb7b0e2b34a 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -979,7 +979,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (old_dir_entry) {
-		if (old_dir != new_dir && !whiteout)
+		if (old_dir != new_dir)
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
 		else
-- 
2.43.0



