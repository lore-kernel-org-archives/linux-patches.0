Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F82E1078F;
	Tue, 30 Jul 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358281; cv=none; b=FoqCfCqQUfJchm8woj0DTBjd3zI1Nl4jyJ81PIuHtNaKqDo4y+J0bhy6Wgy9FG9wul5y4sGZfg2dhJYXDFulADMELryrFWxWhKKCDeWguQcq2tofEjlRg463zd6fjl6kT58PG5RazpZR8wPTIqUHNv0BW+9+8Tu2vjZtjDmGpvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358281; c=relaxed/simple;
	bh=0gv660sC7xLkzvVhcIr/x86XIVzGEqZ6SoAeeu2kWko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akLlz/Mq98WMYCQBFdfzVKBLtSOgigKbzcIIELF7RW1ycz0YXT3q62NH9FgFe/++cnytafk6TdNpmkCvyq5YYrp7MM1bqxIseWl4WUxOR04o+Er088GQJLmFNQ2QzkIVszHnBXuxNQRJ3ECp/VV/vnFqiwVkmSl6PL7l/I4kHyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBl3DgLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBl3DgLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846F4C4AF0E;
	Tue, 30 Jul 2024 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358281;
	bh=0gv660sC7xLkzvVhcIr/x86XIVzGEqZ6SoAeeu2kWko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBl3DgLhJRAA00hCc4RIuLAbdnVDkUZspqTIKj6DX6zpUWmYFfZo7t1dmJXRJVcF8
	 wG5K3c5GkRGS4JLXeLv20aDfnM4h4bdtNuHzBadzPvLFJ1bk6OFlsgKsUDNn5K7wsV
	 ouTTKSZciu0k+hQnlPZfKvFe7U70tcIN/ejnFPhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 347/568] nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
Date: Tue, 30 Jul 2024 17:47:34 +0200
Message-ID: <20240730151653.432793750@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 5783efafbabda..e10f8a777ab06 100644
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



