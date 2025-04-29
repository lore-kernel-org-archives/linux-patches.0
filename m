Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39909248191;
	Tue, 29 Apr 2025 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946250; cv=none; b=nqL6e7Z6SiVEtJbBfTLoOW3vxUY018TCMyB6c31bjXc4F20Chtqjn3u77t1cy+R9qHKjFleigksLbCj9zCoTm3IgBEAX8xZWLkZw5bfZUaxcBVT8vq4r+cMdIFn8bHzDvwYGyDDKldSuk+6VtQSbStUJewCzoB0DQ2VrqD0sfto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946250; c=relaxed/simple;
	bh=UsGgrEonUwl8WQj+4qMU/rZlQEUub3K06SK/KtW74+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhLuCxqzrvZSVHCnzPryAkQxfLiQK8IsPPaggKidK8r3cY431d/lpNgGjVnj3z2mehxbDaJw7ga+6/2wF9i2N9Y1QTUiJa8C2uiakGyLkYdqoosXs9SX41qreF1/8hUzTbWr640GgQMRFutSqxQlqEAPiuEE4+UVLjdTbS/jMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPCKx93j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPCKx93j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F5C4CEE3;
	Tue, 29 Apr 2025 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946249;
	bh=UsGgrEonUwl8WQj+4qMU/rZlQEUub3K06SK/KtW74+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPCKx93jraih3/hdkwMiHBMfVXCjofMKcK/5zhhykpIq5hHGZKkfRnEN9P9KHaVAk
	 yPRmIwF3fVRAVZHxG4TT6FM5gAfn9VRrD4HGUY2GVwT8dcnocvuP6awj2bS3qLBN3A
	 QHB3DP9hzVHROXjDPQQbnF7SJYywgo92E0T91FPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Subject: [PATCH 6.14 204/311] fs/ntfs3: Fix WARNING in ntfs_extend_initialized_size
Date: Tue, 29 Apr 2025 18:40:41 +0200
Message-ID: <20250429161129.366732748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit ff355926445897cc9fdea3b00611e514232c213c ]

Syzbot reported a WARNING in ntfs_extend_initialized_size.
The data type of in->i_valid and to is u64 in ntfs_file_mmap().
If their values are greater than LLONG_MAX, overflow will occur because
the data types of the parameters valid and new_valid corresponding to
the function ntfs_extend_initialized_size() are loff_t.

Before calling ntfs_extend_initialized_size() in the ntfs_file_mmap(),
the "ni->i_valid < to" has been determined, so the same WARN_ON determination
is not required in ntfs_extend_initialized_size().
Just execute the ntfs_extend_initialized_size() in ntfs_extend() to make
a WARN_ON check.

Reported-and-tested-by: syzbot+e37dd1dfc814b10caa55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e37dd1dfc814b10caa55
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index d884facc53166..9b6a3f8d2e7c5 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -430,6 +430,7 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 	}
 
 	if (extend_init && !is_compressed(ni)) {
+		WARN_ON(ni->i_valid >= pos);
 		err = ntfs_extend_initialized_size(file, ni, ni->i_valid, pos);
 		if (err)
 			goto out;
-- 
2.39.5



