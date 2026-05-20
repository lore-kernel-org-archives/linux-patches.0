Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A50356762;
	Wed, 20 May 2026 16:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296043; cv=none; b=kaJBSkVW5pcRQLIsNwfRe3S6a3khJLS1sXGdWB3QPOZTxj3MNYyfnv6SgjsCiHDHP71wSkdIuLePc7Occ3ZWnT6HDm5rjTEutXBL9iu/rPYzJ/2ZU4vwr2cF6ZnSWhrObNucxFSh9Sh2o1zpUsOIs1ShZUv74DbU5QSCx/BmHMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296043; c=relaxed/simple;
	bh=jqlxzx6ovpsWvRQ2HnKe6mnB84nKNda6ilrNGZPhSfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=makRn8leH5uNByoDXE4e6uCkj22tE3cP2YlvodPvW/3lW+gyZlGAY8tfdCVPhTnAIeG1nd2dd/ipntGH+8E7Exz/rmifX993ePm5Qi2IeuZRyejNnJoJ+sw308FTbcXeRYFy6FzK+MYxGKLeTr74iaoXtxdrlf0KVerwaE/z3vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5Q3bG7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5Q3bG7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA9C1F000E9;
	Wed, 20 May 2026 16:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296041;
	bh=PYrHJrIsDBP3vxayc39/GCm5bvklEmAtZAzddTRtI68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5Q3bG7ajsc/vrPul0AL855WEgah2CM/UYIlr5sdyIdDDRht4lGendsUFepYOKDy8
	 9TvZsgY56ioukl5JwzgVq/7W8Z2d6TFohfsXijtXMfirNpgy8DDs3xV7yOXpLPTfYB
	 sguhBGEMggbBbq9Wa5S4jv7fjHocaA3I2xigzNKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0608/1146] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
Date: Wed, 20 May 2026 18:14:18 +0200
Message-ID: <20260520162201.940377556@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 22f53f08d9eb837ce69b1a07641d414aac8d045f ]

There's issue as follows:
    # test_new_blocks_simple: failed to initialize: -12
KASAN: null-ptr-deref in range [0x0000000000000638-0x000000000000063f]
Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
RIP: 0010:mbt_kunit_exit+0x5e/0x3e0 [ext4_test]
Call Trace:
 <TASK>
 kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
 kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
 kthread+0x408/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

If mbt_kunit_init() init testcase failed will lead to null-ptr-deref.
So add test if 'sb' is inited success in mbt_kunit_exit().

Fixes: 7c9fa399a369 ("ext4: add first unit test for ext4_mb_new_blocks_simple in mballoc")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20260330133035.287842-6-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc-test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index 6f5bfbb0e8a42..95cb644cd32fa 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -362,7 +362,6 @@ static int mbt_kunit_init(struct kunit *test)
 		return ret;
 	}
 
-	test->priv = sb;
 	kunit_activate_static_stub(test,
 				   ext4_read_block_bitmap_nowait,
 				   ext4_read_block_bitmap_nowait_stub);
@@ -383,6 +382,8 @@ static int mbt_kunit_init(struct kunit *test)
 		return -ENOMEM;
 	}
 
+	test->priv = sb;
+
 	return 0;
 }
 
@@ -390,6 +391,9 @@ static void mbt_kunit_exit(struct kunit *test)
 {
 	struct super_block *sb = (struct super_block *)test->priv;
 
+	if (!sb)
+		return;
+
 	mbt_mb_release(sb);
 	mbt_ctx_release(sb);
 	mbt_ext4_free_super_block(sb);
-- 
2.53.0



