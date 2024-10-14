Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F9A3BBF2;
	Mon, 14 Oct 2024 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917906; cv=none; b=FoO23ZkGpxpuQLisdNyL2QwsGvMzZpNlX7NzW8coH+yypAmQM6Vgin5B36YfBkfAsMcYAXFM+LoAcJ+KgnajhtzoK1TZnDQuBB3a+0L2NyTxuCXxDMsy8icfTmpW+jzLcb/HCdTcDvc5dCy5CNHJcxy2AcfyW+yFYuPTjhF3bfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917906; c=relaxed/simple;
	bh=tZc5gHCd97Mgbz32wUTLSL7w0qre2dEWA5uu1KN19YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzokKi5PnD7sagwONf4dZ1scCe5uBFWOcPS5IysHbzXIsudWAXp8GB4D9eI10UdL83TpQ/srrm8DvTjz/JAEAut3Jf4+enAufrgkhORbbeOEWNQH3BPF5IS3cLxFlQJLRNYewyu0JYZCPdsq0voVtVwtNfr2SgyDH1iOZjtALBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBW1k9Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBW1k9Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6B9C4CEC3;
	Mon, 14 Oct 2024 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917906;
	bh=tZc5gHCd97Mgbz32wUTLSL7w0qre2dEWA5uu1KN19YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBW1k9Fv5HWKI3RvRqpn+k2K5h0+GXZn3VGOMw5oYUHok/kbWMMjS7x5qIE+YBJVc
	 KPOGJCOI5yHRhiMaJPmsPrwN2Ennib/VYEoiSAdKmelHz532UsWHBpfZWFeHH08t0I
	 W3kidWs9e1rpFgwjbXCv9XQjmWfTv3zuaTl3T/SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/798] ext4: return error on ext4_find_inline_entry
Date: Mon, 14 Oct 2024 16:12:03 +0200
Message-ID: <20241014141224.566443754@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 4d231b91a944f3cab355fce65af5871fb5d7735b ]

In case of errors when reading an inode from disk or traversing inline
directory entries, return an error-encoded ERR_PTR instead of returning
NULL. ext4_find_inline_entry only caller, __ext4_find_entry already returns
such encoded errors.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20240821152324.3621860-3-cascardo@igalia.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c6b72f5d82b1 ("ext4: avoid OOB when system.data xattr changes underneath the filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ee9d2faa5218f..e6c2650335a9f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1698,8 +1698,9 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	void *inline_start;
 	int inline_size;
 
-	if (ext4_get_inode_loc(dir, &iloc))
-		return NULL;
+	ret = ext4_get_inode_loc(dir, &iloc);
+	if (ret)
+		return ERR_PTR(ret);
 
 	down_read(&EXT4_I(dir)->xattr_sem);
 	if (!ext4_has_inline_data(dir)) {
@@ -1730,7 +1731,10 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 
 out:
 	brelse(iloc.bh);
-	iloc.bh = NULL;
+	if (ret < 0)
+		iloc.bh = ERR_PTR(ret);
+	else
+		iloc.bh = NULL;
 out_find:
 	up_read(&EXT4_I(dir)->xattr_sem);
 	return iloc.bh;
-- 
2.43.0



