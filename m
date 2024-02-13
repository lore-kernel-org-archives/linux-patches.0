Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23925FF0D;
	Tue, 13 Feb 2024 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845274; cv=none; b=FofTpEwVUvgqLY5SrCvPfdALwU6i6v56ulcRYw1fmd1kqOZYE8AMAgnWFLeRQ4ITgJeh+TpvPwcUrGv61fKQEtSi4qr8tA6kpDPgyq0qF8K5lbyJxUpQ1xRJnB8lHU6wzv7iGi2RwcetXFEYY7guwsizYoqJBrMjeC0uGDpe87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845274; c=relaxed/simple;
	bh=bk088VhOqT59aGjSMM6am5Ua8qx4W+MhbQCZJQv8Sj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcQQPUq0n1q1hYZOsG3DZQ7WtEUbwlIGUf+2iqVakoG5TF+UQn4a1jbJOz+7xGddZ0fsjyNz0BNnK1NTyaeuxZ3SpH0RoGzTXc7mx6aUqTLCaqPLx5OMNsPSBApn1HTVM84XA3Co1apLuNgo8FB++zBweu567x5W/u/AFn2P+So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yh6sfAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yh6sfAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33265C433F1;
	Tue, 13 Feb 2024 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845273;
	bh=bk088VhOqT59aGjSMM6am5Ua8qx4W+MhbQCZJQv8Sj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Yh6sfApCsjLZcTFKWSpgviDsrhs2W7mqbZjaPx7ej9gksWm/RUlHhPDWbuAq/wGt
	 SfBNoKrrKkSS6q2xHgUV00yDP4JX6YG0qO8adhx361+J+Y9AxvC7K4LlrDzAoUfyNj
	 92dHojFlmAfhEJtUOHi2xYw9vFIqvDcXysfQ+MkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/121] xfs: inode recovery does not validate the recovered inode
Date: Tue, 13 Feb 2024 18:20:42 +0100
Message-ID: <20240213171853.956310557@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

commit 038ca189c0d2c1570b4d922f25b524007c85cf94 upstream.

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e6609067ef26..144198a6b270 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -530,8 +531,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.43.0



