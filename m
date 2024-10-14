Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2E4A24;
	Mon, 14 Oct 2024 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916721; cv=none; b=LOiGFwSav7cFy1lBE/VzOfNb+IfEf8mzt3U4yn2VwAeckISiXJRuSzTrbDgVW7nqi1a62XoyH8+CRGmsrjfffGRLhSArwRrorLLU9/ylg1vCCakprP79zNSt4Oh4tgPVJLHLBbTbK2b58Hk9LuWNyYURNobCouEJdA1uILRsjro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916721; c=relaxed/simple;
	bh=f+cCkPcYqhMQw6dPkm8DeISKdW5w9mFpQDGoetA2S18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUEDHScbsVpduwLBmd9MzP7cR1RNf+wp5DlZ/U2njUKYoE1mJMKROK89DM0HP015YmL/2a2hzV5Vwq+yMWsN//wAUZ5oSLFzgS/d9HdQZCG9wQXaWmCwMe14fB7GBtlhAhviSeQsOkPdIs07EnsZWq9RMe6mjk+ovf75p1Tktn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJuVfVIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJuVfVIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300D6C4CEC3;
	Mon, 14 Oct 2024 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916721;
	bh=f+cCkPcYqhMQw6dPkm8DeISKdW5w9mFpQDGoetA2S18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJuVfVIA6cSkb99qV47VSu9TY8Q/F8MpkIzFE3OQK1TV/cTO2zecorPBZzbGb2Ptx
	 ycHuQUO48DyjD2LFr5DOUB4bu7prke63YlnB94txcAsFvG2zTeAvhd82A2fjO+CVOf
	 rjy2cuVyurhmPuOzz5pJn7nV5z6TOuvOkcg6AZuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/213] fs/ntfs3: Do not call file_modified if collapse range failed
Date: Mon, 14 Oct 2024 16:19:14 +0200
Message-ID: <20241014141044.865866027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2db86f7995fe6b62a4d6fee9f3cdeba3c6d27606 ]

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index cd69cbd0aaae7..f14d21b6c6d39 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -418,7 +418,7 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 }
 
 /*
- * ntfs_fallocate
+ * ntfs_fallocate - file_operations::ntfs_fallocate
  *
  * Preallocate space for a file. This implements ntfs's fallocate file
  * operation, which gets called from sys_fallocate system call. User
@@ -553,6 +553,8 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		ni_lock(ni);
 		err = attr_collapse_range(ni, vbo, len);
 		ni_unlock(ni);
+		if (err)
+			goto out;
 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
 		/* Check new size. */
 		err = inode_newsize_ok(inode, new_size);
-- 
2.43.0



