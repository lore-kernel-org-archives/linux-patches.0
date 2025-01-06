Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691151487F4;
	Mon,  6 Jan 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177214; cv=none; b=jNpUzjbks/l0GEEm+UhANQCpcn9NAMlWLcofvS8/cy5Mxg4oMh3NIfWbawbNMC62wX3E6XBGhCrl5m0pICvXo/A88r3Y4yn4KxeMjdVJUdr9+7s0OdQS2tfsQChxIGiFyX4mVLEfeBQ9dxjCFuRTJ/spDpcYpHn7ktZPguizeEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177214; c=relaxed/simple;
	bh=qupVPogIcl8ZSrzzIGfsZRLpKbjPQb8IukVi5PF0BGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqWH0UJAGvWF6p6oj7bNgJVI1JGzAx/4C54wyytOmdMpkN4bIZhBh2l22eywRTSrGfo1wXbzQs906nBgfxymAk6h/TQX0ijpTWmtuay5cjoMM1U5eNlFDo8RVh2atch5i7EFCd319TP2fsRCNcNPwISbVws+cg+VIDjOPN4hQ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGen+7T7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGen+7T7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE69C4CED2;
	Mon,  6 Jan 2025 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177214;
	bh=qupVPogIcl8ZSrzzIGfsZRLpKbjPQb8IukVi5PF0BGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGen+7T7H3iyh6DdzC9U97yafBcEWR65YNo+F0256o4UhLVljgs4N7D9ypoVdLXEj
	 rejUpEJqtC0LYZwckQ7c6urJD+8ynWGY8VxRuZvAIwF46WxaoCklHB6S0+lnI+bHMs
	 p2M1Ug5nSg1ZL/dS4Rfm3wBvDOvVGliPTGqOAXIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ff7365dc04a6bcafa66@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/222] udf: Verify inode link counts before performing rename
Date: Mon,  6 Jan 2025 16:14:52 +0100
Message-ID: <20250106151153.929512540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 6756af923e06aa33ad8894aaecbf9060953ba00f ]

During rename, we are updating link counts of various inodes either when
rename deletes target or when moving directory across directories.
Verify involved link counts are sane so that we don't trip warnings in
VFS.

Reported-by: syzbot+3ff7365dc04a6bcafa66@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 0461a7b1e9b4..8ac73f41d6eb 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -792,8 +792,18 @@ static int udf_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			retval = -ENOTEMPTY;
 			if (!empty_dir(new_inode))
 				goto out_oiter;
+			retval = -EFSCORRUPTED;
+			if (new_inode->i_nlink != 2)
+				goto out_oiter;
 		}
+		retval = -EFSCORRUPTED;
+		if (old_dir->i_nlink < 3)
+			goto out_oiter;
 		is_dir = true;
+	} else if (new_inode) {
+		retval = -EFSCORRUPTED;
+		if (new_inode->i_nlink < 1)
+			goto out_oiter;
 	}
 	if (is_dir && old_dir != new_dir) {
 		retval = udf_fiiter_find_entry(old_inode, &dotdot_name,
-- 
2.39.5



