Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098134DCD2;
	Tue, 26 Aug 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216126; cv=none; b=GIaAnLkbL/l9d5dOlwLGW3lvPtEpk7t/sGQqD5MeRWz0SYEnOLd4yDxmCpZ9AFT5h5Jmiyn3QpMqvmKGEKM+vRgKcZTttb9WUr2osQaOHdWFCE9BYlYdvtHMXqZXplqqpNtB8l93gHs/45OyuI9XAXlcp7PMHdYyWEQnD4I+2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216126; c=relaxed/simple;
	bh=thAw4G5zxeJWY6eIdnQyacWHS9CC6gSydX0i+eGzOus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I47kfhxESx12/L7iMSAVwPo3wEtHPm88655Hroh+6DQ7v1vtpj7Vnj9kaaNNA2uYPCU4LtoWhiOmGPzeuzHZESjlphB+65bQvNPaZuFHkUwdOPv3WE2zYkbdua3ipe6t2UW1F2UqkanCxt2SAdb9htjMuxnhwQ0ThR8qvTzLy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Na32kBnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Na32kBnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD2AC4CEF1;
	Tue, 26 Aug 2025 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216126;
	bh=thAw4G5zxeJWY6eIdnQyacWHS9CC6gSydX0i+eGzOus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Na32kBnpf/nBLzERlutknO8anntk+QvNZFDyFv5P2ThlwWJYhiBZfvQH7MtTSWWAy
	 UH3j1Odv83jCXnhIkw4SOQs2wXi9P6I80rlJ1ZnXqsTfDzVhYix5I4rPJiEW4WX5Cd
	 JnRBNqW4061RfYOj62ZITgzHkWm9Co+ve/205pJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Gao <wegao@suse.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/644] ext2: Handle fiemap on empty files to prevent EINVAL
Date: Tue, 26 Aug 2025 13:06:24 +0200
Message-ID: <20250826110953.643499249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Gao <wegao@suse.com>

[ Upstream commit a099b09a3342a0b28ea330e405501b5b4d0424b4 ]

Previously, ext2_fiemap would unconditionally apply "len = min_t(u64, len,
i_size_read(inode));", When inode->i_size was 0 (for an empty file), this
would reduce the requested len to 0. Passing len = 0 to iomap_fiemap could
then result in an -EINVAL error, even for valid queries on empty files.

Link: https://github.com/linux-test-project/ltp/issues/1246
Signed-off-by: Wei Gao <wegao@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250613152402.3432135-1-wegao@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/inode.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 333fa62661d5..85b6a76378ee 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -856,9 +856,19 @@ int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
 {
 	int ret;
+	loff_t i_size;
 
 	inode_lock(inode);
-	len = min_t(u64, len, i_size_read(inode));
+	i_size = i_size_read(inode);
+	/*
+	 * iomap_fiemap() returns EINVAL for 0 length. Make sure we don't trim
+	 * length to 0 but still trim the range as much as possible since
+	 * ext2_get_blocks() iterates unmapped space block by block which is
+	 * slow.
+	 */
+	if (i_size == 0)
+		i_size = 1;
+	len = min_t(u64, len, i_size);
 	ret = iomap_fiemap(inode, fieinfo, start, len, &ext2_iomap_ops);
 	inode_unlock(inode);
 
-- 
2.39.5



