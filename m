Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E626B2CD;
	Tue,  8 Apr 2025 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117171; cv=none; b=XiPZf22jTD8/X5do15MlNHzrO9klV2saSss6IFsctn1VlkWzC7iKufvBjDoGIUyM6XwNw8O9Y3jKLHz1O3i+1fAMYjCfj6uHwlmaQ6qhh3HmjGVy8mukvOmI5mOJ96+AijCq4E/ZDSolLcPEI4K6hkaBDmWaRb5aJKk82DScMPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117171; c=relaxed/simple;
	bh=JWPcw8Yw+yvOh4D4oc3F1W1oGEvudM+ABPPMmsdlTwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnqtOQS3vl2CevWPOjY8wqjQ/KgA29PZd2upJIdSP7Gf2ejWPhA9v162pf5ePu7MEoLcoWtIwwP9XKPVXowkHLL/ShmujhYbQ6gzO8ilLzCjds6R/P8Wh1zvp5kMs0YTlFEbLaq1EN+Jkd0PnokANBu5tGKKfDwMq66NTRQlTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdX8Tili; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdX8Tili"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE8FC4CEE5;
	Tue,  8 Apr 2025 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117171;
	bh=JWPcw8Yw+yvOh4D4oc3F1W1oGEvudM+ABPPMmsdlTwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdX8Tilijm6Xi1iwGeaoE3OaxzFB3O2IpmP0ppxshNOr93EjFJyTJLIO4QxkZagWD
	 X//+qkIftqw2MDc1Coo+VdtKqUJp0YkSkpzal9hiM1PZ0J2An9J0zoDWTFE8mvNKeU
	 b6ubQMfM8K5yehfnAEC49Vv1rZEWn5SwjTZhQlUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.12 410/423] ext4: dont over-report free space or inodes in statvfs
Date: Tue,  8 Apr 2025 12:52:16 +0200
Message-ID: <20250408104855.465683840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6781,22 +6781,29 @@ static int ext4_statfs_project(struct su
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


