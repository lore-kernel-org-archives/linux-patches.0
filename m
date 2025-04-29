Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DC4247291;
	Tue, 29 Apr 2025 16:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945483; cv=none; b=FfHeIeNUAHUMrkYu70KQO4lng4n46lsEWEArj46Cs64Jg7rIWFDiNlpbOSBgIOeEVwEvekcPiYhsuNDum09pLIffamtJ1beBS/dwEBwz3UpxVOAtl2Mf9l8WYh2+jgNgdLZEo9ZWypMgkyeibglTXzA4TIeR6CFmHpbAbT7/x/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945483; c=relaxed/simple;
	bh=MJSOqugjaz9cs2c1XBk4ZG1SqMjx0J6r7yBXz/uyw/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBNA+GRJSDqOiUdsqI2kNs7ngjXdz3VTLQGBtiqmIX464yyu+Ql4t5XK0CF3s+6J9HU/c+OMMOoMiPup26Hhj4zaNkVcObsbuoncttrEGz+yTEonEhNvSlHc/qoUO1EgSF/2JtStMfj/qsAbjJLRVPNIW1cyaAXFkCR0eyEgiKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRukYcxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRukYcxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B0EC4CEE3;
	Tue, 29 Apr 2025 16:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945482;
	bh=MJSOqugjaz9cs2c1XBk4ZG1SqMjx0J6r7yBXz/uyw/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRukYcxQuIZgcnxRIuZZHQjXqoJVrhx3uRvR7w856ypMDMJwugUh15LivDi4u8qwO
	 eP9y4TfYpKKLMb4Vs+L+INsKhTvP5O7s2oEqVaR8sc6zwlrCFrbJBiWLsmk8AabmSM
	 JZEgxB1a8UwvsKeOWRjmvtvltpzKu4F9AFhwz9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coverity <scan-admin@coverity.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/179] ext4: simplify checking quota limits in ext4_statfs()
Date: Tue, 29 Apr 2025 18:41:09 +0200
Message-ID: <20250429161054.571326815@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 46d36880d1c6f9b9a0cbaf90235355ea1f4cab96 ]

Coverity reports that conditions checking quota limits in ext4_statfs()
contain dead code. Indeed it is right and current conditions can be
simplified.

Link: https://lore.kernel.org/r/20200130111148.10766-1-jack@suse.cz
Reported-by: Coverity <scan-admin@coverity.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Stable-dep-of: f87d3af74193 ("ext4: don't over-report free space or inodes in statvfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0d4d50c8038fd..8675b4dcc899d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5680,10 +5680,7 @@ static int ext4_statfs_project(struct super_block *sb,
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_bsoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	limit = dquot->dq_dqb.dqb_bsoftlimit;
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
@@ -5698,10 +5695,7 @@ static int ext4_statfs_project(struct super_block *sb,
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = 0;
-	if (dquot->dq_dqb.dqb_isoftlimit &&
-	    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
-		limit = dquot->dq_dqb.dqb_isoftlimit;
+	limit = dquot->dq_dqb.dqb_isoftlimit;
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
 		limit = dquot->dq_dqb.dqb_ihardlimit;
-- 
2.39.5



