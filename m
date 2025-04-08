Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456B435973;
	Tue,  8 Apr 2025 11:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112211; cv=none; b=JaXMwhFGAWYcDSQVOoriXqx9DYLZrKRNQJgJ2m6rRYLUsCUw5Dp9pxfRqGEXXx+WtGHZgkOQ0u5Sj0wfgfGoAl64FlHoRMcEjLOUNc+fsv17uODHy4Ic65B2/sr4MVGsRpRus6Kx9b4wOuwN+g32RWpW3cpwWUzhQQHl/qOrbJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112211; c=relaxed/simple;
	bh=c+Zrp0rd4MhXPotdmKULmQaEoYQCGGSosIzFEYYung4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puzF7tZhm0IBs2kVfwJMUN3zfBCypXO4d0jObtrUVPjZ/kCVHA7gG437zBJVop01D6xXGIBfIfr3Sgi5/q0FEVbksV95MsUpvbx8Q29iKjsgwarTvT2P8HF9SVA6mP2718Vnb2VP+j8OiiFcXsJaRJGU4IOjVwaA8sUUDgJZwxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p9ZOTmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p9ZOTmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE8C4CEE5;
	Tue,  8 Apr 2025 11:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112210;
	bh=c+Zrp0rd4MhXPotdmKULmQaEoYQCGGSosIzFEYYung4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1p9ZOTmOr625PZ/Mz2H3mW/zXtBtGCl+1Aqp0K1mIoN23Uk7tU4ylfDXW7nM7Gu8r
	 Xtqe272XTgKCbpIfNpzb+qDgqPdGl4CFChe5ns+STexv9pvbE9QAdHOJnLpvkoIE00
	 fkgJo7jcxisp9iqQRM/87Dx7R6KzSglAKf59FNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.14 715/731] ext4: dont over-report free space or inodes in statvfs
Date: Tue,  8 Apr 2025 12:50:12 +0200
Message-ID: <20250408104930.905831488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6813,22 +6813,29 @@ static int ext4_statfs_project(struct su
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


