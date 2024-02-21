Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68FB7BB11;
	Wed, 21 Feb 2024 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524063; cv=none; b=bQSZRrC5pkhBhs1flcN/YjCimg+1BO+buhCVKIwulCnmWKUxQlzirvMfia+JkFIJSKTew95ZyoWvAAaeb/p05FHSN5OtIdqiqaxV35f7MUBS4tHk+CmbRZ3bm2AIlUszVi5eswrh78JQmYhFK9C8TLRhq5SOLk3P1P/rE61apU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524063; c=relaxed/simple;
	bh=m4PgwttbP2EcaqAC7g0h+XAggC85EKCdXin4antPkLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jirpR13XfSZSBm3Q0ul/Qdtkz5v+Cncr9T7MGhOzJTxKuymSHzPs55gTHg8DY9upredkOnpgfNxQqSqnj1x/n3q12ALo3Un9HDxGgy55wkourOygRcPaan6xg4IayS8eXxb40sKd7ZpopudW1S0FFG07Dtu9oXGX++Ki+gJcH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU8EuASC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU8EuASC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8A8C433F1;
	Wed, 21 Feb 2024 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524063;
	bh=m4PgwttbP2EcaqAC7g0h+XAggC85EKCdXin4antPkLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU8EuASCb8t7GsJqGelN2Y6+N8RY1BtCvTy5NoJhq8w7AV3ug1BM5D7hvq2y00Gi2
	 FDKaJ45a8+mBn7HikwhtmEeaScI7axfAah48CUdQTfNabe/BQmQ5FH9htFGrru8y3J
	 YJR4zByPeJCz50IdJMorjO4ERzm/S6P7E9Sp4nUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/379] ext4: remove unnecessary check from alloc_flex_gd()
Date: Wed, 21 Feb 2024 14:05:14 +0100
Message-ID: <20240221125958.924199082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit b099eb87de105cf07cad731ded6fb40b2675108b ]

In commit 967ac8af4475 ("ext4: fix potential integer overflow in
alloc_flex_gd()"), an overflow check is added to alloc_flex_gd() to
prevent the allocated memory from being smaller than expected due to
the overflow. However, after kmalloc() is replaced with kmalloc_array()
in commit 6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()"), the
kmalloc_array() function has an overflow check, so the above problem
will not occur. Therefore, the extra check is removed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231023013057.2117948-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 96d278688fd7..66ce3d118203 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -245,10 +245,7 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned int flexbg_size)
 	if (flex_gd == NULL)
 		goto out3;
 
-	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_group_data))
-		goto out2;
 	flex_gd->count = flexbg_size;
-
 	flex_gd->groups = kmalloc_array(flexbg_size,
 					sizeof(struct ext4_new_group_data),
 					GFP_NOFS);
-- 
2.43.0



