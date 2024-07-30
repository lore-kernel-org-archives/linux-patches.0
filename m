Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F614831F;
	Tue, 30 Jul 2024 16:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357314; cv=none; b=pttYDC+McZdpClNiMICXsffzPXy0A+v3KREVdJFAu7KXjCcHvuiyami6Q23VilqMx2UqiAbF0Z2mbjrd10CM8WfYM8swgwdmhnyMMnFNG/wNQnOQYDKAOl2N6iynCnji675OqePJsXFtSAtSpKrfVikQLvGSWSLBm9IaRymADlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357314; c=relaxed/simple;
	bh=Q8FAIPYxtRJFWH4eYCy1zlfiirqs8tgu2DgFS/TnE9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gM/8Q/HjpKl1K1KbItqcF2eXFEGwwgfHmaC/6sjQCN0oAioK/eu4J4LTex9Dm8dVHNuOUdRZg7TpEgEp7COpfnw8yeA8+FtToIYvGRi9pgn3T6EZWF4lz0WP8aeEg0UykcI7HswMqhuYf+Kan82hkHiaCEgEHkOZBA2vBnWuz1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoJ62hb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoJ62hb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C9CC32782;
	Tue, 30 Jul 2024 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357314;
	bh=Q8FAIPYxtRJFWH4eYCy1zlfiirqs8tgu2DgFS/TnE9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoJ62hb9SBsn+q3dTi9ZIsW0b4tDu7lHandNZFNGDO2DHGxkFuPDYlRVwVkmbvaHj
	 bW/LTKS1mFMNXrBL0IjG8B2mCk2c9okpf3cpjcVvPQ/Mq+GqoudNJAEu0oyyQ+BQ1J
	 FGYImwJNrzg2kRlMj0e27WsKNqtNVXFFENXgtjjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/440] nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro
Date: Tue, 30 Jul 2024 17:48:14 +0200
Message-ID: <20240730151626.036550429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 04943ab40a011..5110c50be2918 100644
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



