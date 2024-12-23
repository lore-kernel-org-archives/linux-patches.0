Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3921188006;
	Mon, 23 Dec 2024 16:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970238; cv=none; b=sFypHlOYYJ++sr3vrxAXoTtzfO+3ZgyJl9zcf/26+pE34FSLrvqVGg8YyR6ZcrYVzQ2kkImlTWgvSfsoE6VkTMGCx/R+W/libZW7Lurp/0WqPLa2P9ocOexmPkW2qTcL8BpQRYUT0rRwU//NQLqwAJ3uFNFmYKiF0Rm2cOhMjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970238; c=relaxed/simple;
	bh=szUa9R2jW5zOZhbhckcHeefvR8/PINSEp4PG+EGiUf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqnDaITlcx42tdo6kjLKTavXDC5vWUU0AVXBfP1jbTMCIddfHXj/XKzgxeXw7JxmU+FsARdqHOxPfs5GxWvonuul4umC+7SPXqN/7GwcAlUdBpxTX+gFzAMUVuJ6OQokscRN8RhSmq6jTH7JmRAugoZjG0PMvoCqxCCC+Q9rQZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+Etl6gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+Etl6gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D8AC4CED3;
	Mon, 23 Dec 2024 16:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970238;
	bh=szUa9R2jW5zOZhbhckcHeefvR8/PINSEp4PG+EGiUf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+Etl6gdQqdsenu5nV56PXE9R/nal6eMF1BU5PD1RgULHnDAh02ovRfQqcoKSLx3v
	 pfYOQaSFxH+I1lgLVzX55nTEOGVQTsB9Cee8e0SV9Y8Wf4GHfDChHFNP9vOh4WyIny
	 ubOjsw/DVaA+S2pKtL9nL6owOsZNpr4Q+LmsiSmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.6 024/116] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Mon, 23 Dec 2024 16:58:14 +0100
Message-ID: <20241223155400.501641177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

commit d3b689d7c711a9f36d3e48db9eaa75784a892f4c upstream.

Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
which we also want to ensure is clean and idle.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>4
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f9d72d8e3c35..7336402f1efa 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -963,14 +963,18 @@ xfs_flush_unmap_range(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
-	start = round_down(offset, rounding);
-	end = round_up(offset + len, rounding) - 1;
+	/*
+	 * Make sure we extend the flush out to extent alignment
+	 * boundaries so any extent range overlapping the start/end
+	 * of the modification we are about to do is clean and idle.
+	 */
+	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	start = rounddown_64(offset, rounding);
+	end = roundup_64(offset + len, rounding) - 1;
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-- 
2.39.5



