Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2C33CC2;
	Fri, 24 Nov 2023 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFo8ZWc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43E6C433C9;
	Fri, 24 Nov 2023 19:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853343;
	bh=rYh5XjtaZ0UqcnJ5Ad2ab5kUqn3WjeOo6MBWiZVamU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFo8ZWc3l9nwgzX7MPJSxMsb2Idpkz5Xvs0E4ixtST2UYBFwlZbGl/Wm0Ehy/aOMa
	 57/SMBPESpMAdHo7JBqDFCJTeCQKtNl/bagnXgIz0U4wXEjG9fiOqUYjRnnoGJdjpq
	 fyYy8xE/UkFBQegqxaYvUVATPSzkOM4UrTyDE+E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hexiaole <hexiaole@kylinos.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/297] xfs: fix inode reservation space for removing transaction
Date: Fri, 24 Nov 2023 17:53:12 +0000
Message-ID: <20231124172005.512215069@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hexiaole <hexiaole@kylinos.cn>

[ Upstream commit 031d166f968efba6e4f091ff75d0bb5206bb3918 ]

In 'fs/xfs/libxfs/xfs_trans_resv.c', the comment for transaction of removing a
directory entry writes:

/* fs/xfs/libxfs/xfs_trans_resv.c begin */
/*
 * For removing a directory entry we can modify:
 *    the parent directory inode: inode size
 *    the removed inode: inode size
...
xfs_calc_remove_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                xfs_calc_iunlink_add_reservation(mp) +
                max((xfs_calc_inode_res(mp, 1) +
...
/* fs/xfs/libxfs/xfs_trans_resv.c end */

There has 2 inode size of space to be reserverd, but the actual code
for inode reservation space writes.

There only count for 1 inode size to be reserved in
'xfs_calc_inode_res(mp, 1)', rather than 2.

Signed-off-by: hexiaole <hexiaole@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: remove redundant code citations]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa25593..2db9d9d123444 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -423,7 +423,7 @@ xfs_calc_remove_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
+		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-- 
2.42.0



