Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8FD34DCD4;
	Tue, 26 Aug 2025 13:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214234; cv=none; b=TlYpNpdt9mB7CuZbdJOmba4S+LGNrTD4VWxtWYDBV7pA5Z+PvhJ3k54fI2WjeEcPuFzHprvENdnmHrzvw8vCtDCQC5OmEDhUV6sH6TY6bZ0VXWVWmtptJ0dazP5yUryG/cpIfY1MjYBdVe0I6MzCX66p81aEwhuCgVjdpG2ofQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214234; c=relaxed/simple;
	bh=dKqDjZ48mcFrA7A5AAFYdLUqq0pWeRHxkVc3VIu/uD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOL1d9GIEEDjWOi4d0EWStoZGuOwSMCtAnPKyCW4Vgj7GdMNB3uGrquW0xd/7HzwpMTloBL1mvAAf80d+lga8aHfgKTQw0Tj32SqdLX+X+XA5UWyFN6Z8vcPELFKiOrneVWU2+YgqMLvJZ60VRQ9YQEiuiIgncIr77ihu4mj5EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsbzQ0Wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsbzQ0Wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB28C4CEF1;
	Tue, 26 Aug 2025 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214234;
	bh=dKqDjZ48mcFrA7A5AAFYdLUqq0pWeRHxkVc3VIu/uD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsbzQ0WmJxZgFHmiR0dNKZm/BtA7KKUckTc1SK8n2OJ9lQWb3qYFL4djISlOLGxnm
	 eS0w8WNvW7DuJ1jw310K6tCawJWavWFdV1UUZB8zQFDM1iE6T5yhoBcLyWjbWJubL2
	 9ZmGPif3ZdkJuwl1Bg7FtYDWMeQwuLXY7YOEIFFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Gao <wegao@suse.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/482] ext2: Handle fiemap on empty files to prevent EINVAL
Date: Tue, 26 Aug 2025 13:05:15 +0200
Message-ID: <20250826110932.356380152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a32fcd55183..430ccd983491 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,9 +860,19 @@ int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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



