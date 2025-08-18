Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C447335BBB;
	Mon, 18 Aug 2025 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524975; cv=none; b=MunrTYNIoRDCuZGmimyx88sL2S7aPgI2u16DMImzA1yOALwKfW/7+B3YdxdUOhcGss2NYan2mOWiLmQ+jXo+k7I591iSkRn2vg4t9/Atug9d3iLz79aNkAm4yhQRks4IFlYnWnCayo+DiPuM6kytV9CqcNfuowaLzxBewDIuNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524975; c=relaxed/simple;
	bh=7igTzAr0dbyJOcYt+U9iS3N4XPLpIl79/vCfsl3WZqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlfLdK6urNbWUj9pJ0VjJIFGuvbEtVYdOo6K0K1IZ+L5U3a3yrrxkhdCljkNU9l6n9qFgL9FFU/wo2K1XONGWN9PU7kFve9Xqrdn266/9kMf73ow6a86UJcgP/7kEEsVdprmmiXX0dTUu6osPj4+IqpwAriPCNBLBovU9ee5/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9AHWCZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9AHWCZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76DCC4CEEB;
	Mon, 18 Aug 2025 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524975;
	bh=7igTzAr0dbyJOcYt+U9iS3N4XPLpIl79/vCfsl3WZqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9AHWCZPxDAbm6OUUMEzLKKv2Mi72jv+2YhY+gnWYpcS8oTlQAOTMWswPsoKEKP6N
	 5zVfHPLmOjzG+638RLMKslfj0QLIHoxSror/S1WZAn0Pq4g/wePEfPAFN8/rsmsz94
	 O56ZJLI1dv6QgEAJeJBrLxFqNCp2RWJnky6YoER4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Gao <wegao@suse.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 120/570] ext2: Handle fiemap on empty files to prevent EINVAL
Date: Mon, 18 Aug 2025 14:41:47 +0200
Message-ID: <20250818124510.437856235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 30f8201c155f..177b1f852b63 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -895,9 +895,19 @@ int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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



