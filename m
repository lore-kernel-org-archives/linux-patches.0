Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300582673B7;
	Tue,  8 Apr 2025 11:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110743; cv=none; b=M+ltW86WWUBEX72QBLt7+M7OUVO8i+puHhqWUQNl2lJ5DBCkm6Z3l8tIfnQdJlGAdKlhTl6o7aFOh0rgQX32UzFosZJZ4aVwnShOeFHPkLizQxFxvhNjW7/D78vb0TcP2mUJtctbVzaebW30gncIkk9OsbECbO5hfn0iZMCFdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110743; c=relaxed/simple;
	bh=7nDtTwYwoeQDiT8d7BMfLzkapuOrXe/SFTpA+mQVG78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tn63GpMvev36MIyKvvXKguUAhTgOcRoWI/yHVeo1wZRKFSDb6eG79bIMI0XacoJocPI3MxDE71UWAo4bSN+i07/CqGvCUBmN12AohOeZTAdmZBL9YYy/r8c3NltIv3X1InoNF/kJfJ8xhq7BFCY3b+KkxgUGlgCcqNjx8pW0m4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOryfbPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOryfbPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B108DC4CEE5;
	Tue,  8 Apr 2025 11:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110743;
	bh=7nDtTwYwoeQDiT8d7BMfLzkapuOrXe/SFTpA+mQVG78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOryfbPI8FHRLtM+T4RIf1n/geSy3GmfhqcyVIdwPVSx4Emho/FmpHmDgZ14GMZJO
	 m/2wvn6w8Y/fp2oWdO8CX/kzr5XVFvivgIUrU4HbUDysfFZZi9ljFj4qnPL+9UL+Ql
	 cIB/tmcyJxPxY2/hZCzAwXkzoAumUa1oWs7Rp7TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 178/731] ext4: fix potential null dereference in ext4 kunit test
Date: Tue,  8 Apr 2025 12:41:15 +0200
Message-ID: <20250408104918.417477782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 57e7239ce0ed14e81e414c99d57f516f6220a995 ]

kunit_kzalloc() may return a NULL pointer, dereferencing it
without NULL check may lead to NULL dereference.
Add a NULL check for grp.

Fixes: ac96b56a2fbd ("ext4: Add unit test for mb_mark_used")
Fixes: b7098e1fa7bc ("ext4: Add unit test for mb_free_blocks")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20250110092421.35619-1-hanchunchao@inspur.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index bb2a223b207c1..d634c12f19847 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -796,6 +796,7 @@ static void test_mb_mark_used(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buddy);
 	grp = kunit_kzalloc(test, offsetof(struct ext4_group_info,
 				bb_counters[MB_NUM_ORDERS(sb)]), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, grp);
 
 	ret = ext4_mb_load_buddy(sb, TEST_GOAL_GROUP, &e4b);
 	KUNIT_ASSERT_EQ(test, ret, 0);
@@ -860,6 +861,7 @@ static void test_mb_free_blocks(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buddy);
 	grp = kunit_kzalloc(test, offsetof(struct ext4_group_info,
 				bb_counters[MB_NUM_ORDERS(sb)]), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, grp);
 
 	ret = ext4_mb_load_buddy(sb, TEST_GOAL_GROUP, &e4b);
 	KUNIT_ASSERT_EQ(test, ret, 0);
-- 
2.39.5



