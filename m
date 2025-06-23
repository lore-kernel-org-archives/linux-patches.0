Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FC74315A;
	Mon, 23 Jun 2025 21:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715007; cv=none; b=E2mxmXyr+w2jt90Qt2f0+hb7bOVmH7ukgtMpGmRv7u/+NHPNtWz/0b3ZsBw4r5q3fUKSoNX11lpJqdgUvHad3L3MHlOJHgCQ8tpqQkeK7yOoajcRb/ltht1vSWyELvjDI0qJ7WJty1h//TZtMvYNmJFTPNr4RfJSfsIGARH9qYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715007; c=relaxed/simple;
	bh=XdMCK9X8NjuxgMhwBH9DpDUwPnX476PG8XPPlllqmOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zj6EBz3YhqAz8exO+nZ6cKd134AHCYLzNIabHgJEZ9XqXBJBv5rBBP6YT+q1Wsu6tH2SrXl5t6/Q/KLL0yx/aERA1b3HzUVS9q9kqvu6SnXqxCVKt6AwFrcpIIKj/epnZZ2PO8JKM0z+h2+C+zTVm8kAPcSRTqkPoVWn8FQgx2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfXZda6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfXZda6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B9AC4CEEA;
	Mon, 23 Jun 2025 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715006;
	bh=XdMCK9X8NjuxgMhwBH9DpDUwPnX476PG8XPPlllqmOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfXZda6wAXzvLKN3Z32EsuACiLh9Zbw8WmuoyXT6GOAqagVKiiADyzC/oMAaPrdwe
	 bLB7rixFoM+rX33rJtzabf6KZ1FKkQRVHuQLjUl1wjnEok6aQmaKQQTu+0D8/vtHWO
	 0yYkooyn2wCiwUWRm2tusxrwnJY35X/0+Ni40fd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/508] xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set
Date: Mon, 23 Jun 2025 15:04:14 +0200
Message-ID: <20250623130650.407767767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 8d16762047c627073955b7ed171a36addaf7b1ff ]

If a file has the S_DAX flag (aka fsdax access mode) set, we cannot
allow users to change the realtime flag unless the datadev and rtdev
both support fsdax access modes.  Even if there are no extents allocated
to the file, the setattr thread could be racing with another thread
that has already started down the write code paths.

Fixes: ba23cba9b3bdc ("fs: allow per-device dax status checking for filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1afb1b1b831ea..ef3dc07785669 100644
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



