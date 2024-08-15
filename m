Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7C018D630;
	Thu, 15 Aug 2024 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729668; cv=none; b=fp+5u95teffSGFsgfiKrwYIpcw0l7JvRlS9jlN7OUrEDr4z+Zo1f0frugF5mNE6PqWxYFO0JfZ3aGVcuvV+uf2BYmNF6AAsViPNpYVfluStenPwBNYw0k+XVr0yBl/CgBSWGrdmeoad8HVHMt5GXy0MU8BHsKnZojIavCUtl1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729668; c=relaxed/simple;
	bh=zsS3kL5aE2VfrvcEDiDFrmu9ldSc3i00XT0OsXNbab0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiwrML64ZBfZjRUrdz0etuBAE7tR9bTJ39VbBwYf5fYbMBhgf0Ku3u++v3k+7azFHzCPAKYPUG4O0uO1EDCQxRY5pvSQtF7xLQnftBtShOJP6W5U4B+oaoaAb8EPP6NvDWkHI1lmltskbelPRX7JtUhm2ighmwi73FCptrhRpuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KM1tD3Qh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM1tD3Qh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51489C32786;
	Thu, 15 Aug 2024 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729667;
	bh=zsS3kL5aE2VfrvcEDiDFrmu9ldSc3i00XT0OsXNbab0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM1tD3QhjxKo43Ru3Sa7wOizqbo1wjQhVJS7Xh6UUm4HE9u6zW1OFuvbUgkUjREep
	 rOGbpZm2+5H464wnjl2DyOm88u0G9BL061eaUcT7kcBlX8HG1jzgY11to7GpTKN0pP
	 J9onltvJNAtUqhuA/xjzZg73j4/wBm1p8/RRBaHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/484] nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
Date: Thu, 15 Aug 2024 15:20:21 +0200
Message-ID: <20240815131947.706253916@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 0f3819e8c483771a59cf9d3190cd68a7a990083c ]

According to the C standard 3.4.3p3, the result of signed integer overflow
is undefined.  The macro nilfs_cnt32_ge(), which compares two sequence
numbers, uses signed integer subtraction that can overflow, and therefore
the result of the calculation may differ from what is expected due to
undefined behavior in different environments.

Similar to an earlier change to the jiffies-related comparison macros in
commit 5a581b367b5d ("jiffies: Avoid undefined behavior from signed
overflow"), avoid this potential issue by changing the definition of the
macro to perform the subtraction as unsigned integers, then cast the
result to a signed integer for comparison.

Link: https://lkml.kernel.org/r/20130727225828.GA11864@linux.vnet.ibm.com
Link: https://lkml.kernel.org/r/20240702183512.6390-1-konishi.ryusuke@gmail.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 440e628f9d4fc..c90435e8e7489 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -136,7 +136,7 @@ static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(a) - (__s32)(b) >= 0))
+	 ((__s32)((a) - (b)) >= 0))
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
-- 
2.43.0



