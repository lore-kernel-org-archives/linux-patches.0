Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38F23D75C7;
	Wed, 20 May 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298676; cv=none; b=pQvz0FgNe4KdaWeYlDlg4GpPEDUkr3kzixtEpN30tHKFp35RMVbZJ5Ia6JiJHnb/MTQH4pNGOqn1KcFwxYmrMOVxju0ADTpOPNfAedgeVmZ7S9AnZG8Qcsobl9hA7JhgHSJglO4ASEUzyzLxyXOi67IuMtbdisokdxnCvhfHs20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298676; c=relaxed/simple;
	bh=kC/05GeiEpv/P03t/gswNTn0MjgC9Kxluxt1MDkLGj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhRd6JxOCmxyem3xheGjQ1pWvKxB3V/w59aHt0gTmNVZBR5MX1lsK3KGOiexV59KsgTwRZho0sf7Wyh35hQCizmdIOPCqprnh3Ql6AlUoYjYJG4QlbD+IyKeAogB/0qVVDdV/CbFulzy9ZxVeVY7KBj/VkXZveIeTLJIs0DF+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbOY3QOe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbOY3QOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649151F000E9;
	Wed, 20 May 2026 17:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298674;
	bh=sy0thtYoTeFBh10N3ay9GH+AtBkqtLFA34Xww4JFJJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbOY3QOeZNshpnM/wTObQnORJVHdw0dbW947ZdGyB/M1jStOQexzcsx9cKo/z47aM
	 IXfCGrIVtzDOL/Z9nKJqLl1kdekJd3puExADRCGhmagC0Ou56Gmldz4JTBcTeu3SQM
	 TIbtmBGCxIK5fdeqUuOTOXZGdWdYq4PC1kh7fZYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 484/957] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
Date: Wed, 20 May 2026 18:16:07 +0200
Message-ID: <20260520162145.020608032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4abb40d4561ce..68aab8e45bc37 100644
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



