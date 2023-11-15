Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD7F3DB95
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEULLzrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5F8C433C7;
	Wed, 15 Nov 2023 20:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078644;
	bh=g7WzhDQRe8po7tmvYrYcPTsnq5tDGk33fmJSzK/sBcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEULLzrTyQK5bNLWiBMslm2zcOj8hHL9kFJRwMZVton5BqkmVWiGvbLLfvqjAcqvp
	 DcxSnqOtP+Rz+aMu/6n6F96PaFUI6nbwIe8oZW61hEAWbBQxMrbfttKoG1+Gd0HhFO
	 RHMwWKFf0m1DYHpK/UvCyu/1Zw4SOB57kMLezkLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/45] ext4: move ix sanity check to corrent position
Date: Wed, 15 Nov 2023 14:32:57 -0500
Message-ID: <20231115191420.815390773@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit af90a8f4a09ec4a3de20142e37f37205d4687f28 ]

Check 'ix' before it is used.

Fixes: 80e675f906db ("ext4: optimize memmmove lengths in extent/index insertions")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Link: https://lore.kernel.org/r/20230906013341.7199-1-gouhao@uniontech.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 652d16f90beb7..c8cce6bb02765 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1002,6 +1002,11 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		ix = curp->p_idx;
 	}
 
+	if (unlikely(ix > EXT_MAX_INDEX(curp->p_hdr))) {
+		EXT4_ERROR_INODE(inode, "ix > EXT_MAX_INDEX!");
+		return -EFSCORRUPTED;
+	}
+
 	len = EXT_LAST_INDEX(curp->p_hdr) - ix + 1;
 	BUG_ON(len < 0);
 	if (len > 0) {
@@ -1011,11 +1016,6 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 		memmove(ix + 1, ix, len * sizeof(struct ext4_extent_idx));
 	}
 
-	if (unlikely(ix > EXT_MAX_INDEX(curp->p_hdr))) {
-		EXT4_ERROR_INODE(inode, "ix > EXT_MAX_INDEX!");
-		return -EFSCORRUPTED;
-	}
-
 	ix->ei_block = cpu_to_le32(logical);
 	ext4_idx_store_pblock(ix, ptr);
 	le16_add_cpu(&curp->p_hdr->eh_entries, 1);
-- 
2.42.0



