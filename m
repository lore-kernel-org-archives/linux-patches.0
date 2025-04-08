Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8B226981C;
	Tue,  8 Apr 2025 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110239; cv=none; b=edhOW/eOuloK0s9pvFecvsI8VH04r6A62j6YwASB1coBKAiuVbioRHyOU4SsSVsHSInxp0l/uz31ASogZIYi6sg/ILwG3YSdRtEzG2Ctz2IusuFKyt/6ILaY9iF5izNEAuYJlHdJKlp6x6UBmA5g7E0bO4DctBxkf0LPIjL+s/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110239; c=relaxed/simple;
	bh=zgxisE+tVmSZQO1OLi4hWYGEtu12LhswwCX8za7kxlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRTqWtG39YNtqNGxbW7Fc6cg3WtXTx8YsOf+HHXB9fHcYscMYzKoYnEMPt4fr6ujoX0MMlZiNjDcwH4F+J+yNuvjViI1Dx4eMaWkcCUbBlG8lMKEAYp01np6QLmSeblfxTJF8HiDV9J0yBXRD8CN8vSrAxOZKZrFRRa7YfKY2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIpAHSGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIpAHSGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEC7C4CEE7;
	Tue,  8 Apr 2025 11:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110239;
	bh=zgxisE+tVmSZQO1OLi4hWYGEtu12LhswwCX8za7kxlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIpAHSGYKztx0Qg5jRCuXHCgFSIpDj7ipxFTxgiSglFo2m45lWLS1+DpnMtPsdgf/
	 JFh4hcfuj95CfKvUlFuTE5c65qp3oz2jt1wGJlCBfwt7LTYmdkJOg5Re1t1WfInH1B
	 bohaqHDQrJa+O6gv987AHCz5qN9ZM4iyzQvSRAME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.10 220/227] ext4: dont over-report free space or inodes in statvfs
Date: Tue,  8 Apr 2025 12:49:58 +0200
Message-ID: <20250408104826.897756721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f87d3af7419307ae26e705a2b2db36140db367a2 upstream.

This fixes an analogus bug that was fixed in xfs in commit
4b8d867ca6e2 ("xfs: don't over-report free space or inodes in
statvfs") where statfs can report misleading / incorrect information
where project quota is enabled, and the free space is less than the
remaining quota.

This commit will resolve a test failure in generic/762 which tests for
this bug.

Cc: stable@kernel.org
Fixes: 689c958cbe6b ("ext4: add project quota support")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6123,22 +6123,29 @@ static int ext4_statfs_project(struct su
 			     dquot->dq_dqb.dqb_bhardlimit);
 	limit >>= sb->s_blocksize_bits;
 
-	if (limit && buf->f_blocks > limit) {
+	if (limit) {
+		uint64_t	remaining = 0;
+
 		curblock = (dquot->dq_dqb.dqb_curspace +
 			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
-		buf->f_blocks = limit;
-		buf->f_bfree = buf->f_bavail =
-			(buf->f_blocks > curblock) ?
-			 (buf->f_blocks - curblock) : 0;
+		if (limit > curblock)
+			remaining = limit - curblock;
+
+		buf->f_blocks = min(buf->f_blocks, limit);
+		buf->f_bfree = min(buf->f_bfree, remaining);
+		buf->f_bavail = min(buf->f_bavail, remaining);
 	}
 
 	limit = min_not_zero(dquot->dq_dqb.dqb_isoftlimit,
 			     dquot->dq_dqb.dqb_ihardlimit);
-	if (limit && buf->f_files > limit) {
-		buf->f_files = limit;
-		buf->f_ffree =
-			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
-			 (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dquot->dq_dqb.dqb_curinodes)
+			remaining = limit - dquot->dq_dqb.dqb_curinodes;
+
+		buf->f_files = min(buf->f_files, limit);
+		buf->f_ffree = min(buf->f_ffree, remaining);
 	}
 
 	spin_unlock(&dquot->dq_dqb_lock);


