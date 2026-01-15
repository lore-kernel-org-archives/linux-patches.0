Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25D29B200;
	Thu, 15 Jan 2026 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497324; cv=none; b=sIi41wT5/yKoX1tzedq9pfU7Ebw7BzpR2V+WGsNFUJNQvmWCdQTym6o06sW5+zBRcsC1/KAN1hgs9IC9Rly3aed7giXuiR473D5mliMzXXeQ+o7rlzOwfDubyfbeLWDfQpFGj/cYfuDBWeTL5A/0ubofQUlqfS6J7IAi3hyQyw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497324; c=relaxed/simple;
	bh=L+6a/62sYUFzsiuCRWqJN74/L8CpRO64oPySQWZF9D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpawx4yCOYYYuz2gYmC2xusJF++/9BkqS3fiGkx/9XQ0HFOtY1mT68RCw6ijt5x54UXoEbIx+3/PHBk811ioJKzfkzVwpX/4ngrHuoRXhhv4yQlI1qn5lfml3XpSc00uRSkysU+UN+JaO4dVCENtNIG044Be/bGYU/3hbMCcW8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBQ4p8uH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBQ4p8uH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1483CC116D0;
	Thu, 15 Jan 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497324;
	bh=L+6a/62sYUFzsiuCRWqJN74/L8CpRO64oPySQWZF9D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBQ4p8uHwqEKLTAJn9ICM3nRUPpOR6712gQk8W6ThORBuFGaPhZM8WS3yTvA/+k4O
	 3R3ajUg7r6QQMJFrUNsu9bExxqgKjggnwVjknVuQLtidkY5MMY+9JqNeAdHTsXcrST
	 IIci7xcF+SlEjkXlImAXJbvnk+XunMGH9lS/k38M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com,
	Sidharth Seela <sidharthseela@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/554] ntfs3: Fix uninit buffer allocated by __getname()
Date: Thu, 15 Jan 2026 17:41:48 +0100
Message-ID: <20260115164247.768440387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidharth Seela <sidharthseela@gmail.com>

[ Upstream commit 9948dcb2f7b5a1bf8e8710eafaf6016e00be3ad6 ]

Fix uninit errors caused after buffer allocation given to 'de'; by
initializing the buffer with zeroes. The fix was found by using KMSAN.

Reported-by: syzbot+332bd4e9d148f11a87dc@syzkaller.appspotmail.com
Fixes: 78ab59fee07f2 ("fs/ntfs3: Rework file operations")
Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 019a98e300dcf..7797e35364495 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1696,6 +1696,7 @@ int ntfs_link_inode(struct inode *inode, struct dentry *dentry)
 	de = __getname();
 	if (!de)
 		return -ENOMEM;
+	memset(de, 0, PATH_MAX);
 
 	/* Mark rw ntfs as dirty. It will be cleared at umount. */
 	ntfs_set_state(sbi, NTFS_DIRTY_DIRTY);
-- 
2.51.0



