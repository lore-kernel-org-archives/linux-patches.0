Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BFF23FC7D;
	Tue, 29 Apr 2025 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945488; cv=none; b=ogMTwOC4UwWeuIKM2WVUo2X0qfmFqcKYVI2CWqJZ43/CNvsrvfhrHfjpmkAreCRj7JTWxzmiLOyCP/Dtcc1J6v1yNSyEPyWXFZcaonu7vC3FpL669pOvcMdcdvJsKQXdQk5eiLKGBTiKKJ43jrmxrF3f9e8rn7r5ahqDBU2kYf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945488; c=relaxed/simple;
	bh=JoaXOcNKoUeTAMiLrJ6PsVrpd5EXhLZfVxmXi7NYNsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoGdZ9JZ95yz9d0/UI3augNpRXbI8GtDxydwO5uPqJS+AzbTU25NHZ7W2xyBKIXEwbAspWq25OqDHNjNSqxraWhm5UIcte1nO/MD56yyHrihx7Iu5rui+nOFO498XL7glcU0IwqJHAikfmEc9wLW2D1s1OUDl/Xn3Yddxuhyr8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJLDCepY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJLDCepY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4124C4CEE3;
	Tue, 29 Apr 2025 16:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945488;
	bh=JoaXOcNKoUeTAMiLrJ6PsVrpd5EXhLZfVxmXi7NYNsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJLDCepYUIAwSeIWpjherTB2TtICoQL5TSNnUu8F11bZAReO7+r7ldKe0THATpdvU
	 gIuk+8RgwB827pIu/aEN3mQoBAiDLCV/rv6Y1Cx7ZLS2Etv9d7zq8Cf+LiZQ4Fhec9
	 R5G7MYxAOj6Vpz5m9o3bLCiwbtvitv7uU+5vBYS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/179] ext4: dont over-report free space or inodes in statvfs
Date: Tue, 29 Apr 2025 18:41:11 +0200
Message-ID: <20250429161054.653423835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit f87d3af7419307ae26e705a2b2db36140db367a2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 332849e17b2bd..ff681888a123f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5684,22 +5684,29 @@ static int ext4_statfs_project(struct super_block *sb,
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
-- 
2.39.5



