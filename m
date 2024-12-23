Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEDA1B4126;
	Mon, 23 Dec 2024 16:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970321; cv=none; b=CC03vZZwhpd2OypppJb3819W7AGH053967rkHMY9COS+0RM6ewjfQ05vjK6s+NJ7A76BT3PjwCk0knKZbHNtd2aOCDJVPuiKNdICzSsyTPSTcH0jx4cfwDQTX7Yd2/wDJI9DgfuJCMFDktpwH8GXKfIvuImjx4Zwxu80J6keQKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970321; c=relaxed/simple;
	bh=YgTlhSzWK2J5dhjCjdNJs3YwZxgRPiF4AvsgS0kA5MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7YRFxOr4hCG7sMDw4JVtHQxnCeI+Oz6SahgvskpIUyHX6H/R8J8rwHn9X5w4+6QreaO+4reF0vKD5Iy73dGQr0xEpgqgihf9JhqEpEWWXK556Sn86F/tygDXc7FCtO2JHi7jzlci7IIydiXOneVeH7r/h2g5632Jv7rgeZbp8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/NvLHIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/NvLHIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F875C4CED3;
	Mon, 23 Dec 2024 16:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970321;
	bh=YgTlhSzWK2J5dhjCjdNJs3YwZxgRPiF4AvsgS0kA5MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/NvLHIYOt0ZeTC5LTWpWlXtvc3qN9A1N7gErszsvzgkb62clH+iiq8cOaGdvOOx9
	 Cg44nYAvdSGqgsPU7UhF/I2hGB2N+Vk0N1jAtUqJgDyuhmEuIwZGQcRBtNfat8WaHi
	 az07/0rfYRudlOy5TynTESSvtqTdsgU+NaQveQ1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/116] xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
Date: Mon, 23 Dec 2024 16:58:21 +0100
Message-ID: <20241223155400.790308749@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 8d16762047c627073955b7ed171a36addaf7b1ff upstream.

If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
allow users to change the realtime flag unless the datadev and rtdev
both support fsdax access modes.  Even if there are no extents allocated
to the file, the setattr thread could be racing with another thread
that has already started down the write code paths.

Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index df4bf0d56aad..32e718043e0e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1128,6 +1128,17 @@ xfs_ioctl_setattr_xflags(
 		/* Can't change realtime flag if any extents are allocated. */
 		if (ip->i_df.if_nextents || ip->i_delayed_blks)
 			return -EINVAL;
+
+		/*
+		 * If S_DAX is enabled on this file, we can only switch the
+		 * device if both support fsdax.  We can't update S_DAX because
+		 * there might be other threads walking down the access paths.
+		 */
+		if (IS_DAX(VFS_I(ip)) &&
+		    (mp->m_ddev_targp->bt_daxdev == NULL ||
+		     (mp->m_rtdev_targp &&
+		      mp->m_rtdev_targp->bt_daxdev == NULL)))
+			return -EINVAL;
 	}
 
 	if (rtflag) {
-- 
2.39.5



