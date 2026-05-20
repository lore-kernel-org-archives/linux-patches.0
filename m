Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488AC317160;
	Wed, 20 May 2026 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296027; cv=none; b=OFPb7oRma4q3kD6ksmQCtNcyFwKVDk9AZZlIoxyzRIWR9l+CuzKzGuTUV8vHeCoYmoSh1u8bH/5nb4UZjCoZo5funYD/IfwGU/XcecmvwcFWCiFFwWrxoFl+MdsQNZg9HXoSTJF5WGaOQ6E+827Z1hunf/Uw118/Tckjxiq9aXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296027; c=relaxed/simple;
	bh=WgCgJrnqWquAnd7EjvFd//MGWa+7Q+B6te5Y3wiOGAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntpi5orBRyDiFJkor+UA9HU3Ilgpcq9cNiw0Fgkya2lDALj0p3U4925VFiIF2bttTikfkKZ2QxbsGz/94BEbcyNpfLcs2wU2f3fEBFECzUhAOaPvydtiqcZrZTNmDASLkkgPWNx2/FOC4Bsxv2hjQutZRpl5A1M7deZbPDaliwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcUobdJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcUobdJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF9D1F000E9;
	Wed, 20 May 2026 16:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296026;
	bh=1Zr+jpgjXMxN5lMPi4F20vea2+LeC6kXqtSU28FGW9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcUobdJSfha/AIDJki4+zJWhVamimQCDg/1C13vGZjJNWy9GYB20ewicNw0qg40xP
	 iEKON9xa3n8buq2KZldkTJAsYtUteIQJqp0BPEGRMWAttmSmYubOb2HQ85pFffav/P
	 U0y+/W5czzIT7byAKEKJbE+FLcSSmQ9lDlkqQVDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0606/1146] ext4: fix the error handling process in extents_kunit_init).
Date: Wed, 20 May 2026 18:14:16 +0200
Message-ID: <20260520162201.894102779@linuxfoundation.org>
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

[ Upstream commit 17f73c95d47325000ee68492be3ad76ae09f6f19 ]

The error processing in extents_kunit_init() is improper, causing
resource leakage.
Reconstruct the error handling process to prevent potential resource
leaks

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20260330133035.287842-4-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents-test.c | 50 +++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 3d4663d99eb13..4042bc8a95e2f 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -225,34 +225,38 @@ static int extents_kunit_init(struct kunit *test)
 		(struct kunit_ext_test_param *)(test->param_value);
 	int err;
 
-	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
-	if (IS_ERR(sb))
-		return PTR_ERR(sb);
-
-	sb->s_blocksize = 4096;
-	sb->s_blocksize_bits = 12;
-
 	sbi = kzalloc_obj(struct ext4_sb_info);
 	if (sbi == NULL)
 		return -ENOMEM;
 
+	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
+	if (IS_ERR(sb)) {
+		kfree(sbi);
+		return PTR_ERR(sb);
+	}
+
 	sbi->s_sb = sb;
 	sb->s_fs_info = sbi;
 
+	sb->s_blocksize = 4096;
+	sb->s_blocksize_bits = 12;
+
 	if (!param || !param->disable_zeroout)
 		sbi->s_extent_max_zeroout_kb = 32;
 
+	err = ext4_es_register_shrinker(sbi);
+	if (err)
+		goto out_deactivate;
+
 	/* setup the mock inode */
 	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
-	if (k_ctx.k_ei == NULL)
-		return -ENOMEM;
+	if (k_ctx.k_ei == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 	ei = k_ctx.k_ei;
 	inode = &ei->vfs_inode;
 
-	err = ext4_es_register_shrinker(sbi);
-	if (err)
-		return err;
-
 	ext4_es_init_tree(&ei->i_es_tree);
 	rwlock_init(&ei->i_es_lock);
 	INIT_LIST_HEAD(&ei->i_es_list);
@@ -267,8 +271,10 @@ static int extents_kunit_init(struct kunit *test)
 	inode->i_sb = sb;
 
 	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
-	if (k_ctx.k_data == NULL)
-		return -ENOMEM;
+	if (k_ctx.k_data == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/*
 	 * set the data area to a junk value
@@ -313,6 +319,20 @@ static int extents_kunit_init(struct kunit *test)
 	up_write(&sb->s_umount);
 
 	return 0;
+
+out:
+	kfree(k_ctx.k_ei);
+	k_ctx.k_ei = NULL;
+
+	kfree(k_ctx.k_data);
+	k_ctx.k_data = NULL;
+
+	ext4_es_unregister_shrinker(sbi);
+out_deactivate:
+	deactivate_locked_super(sb);
+	kfree(sbi);
+
+	return err;
 }
 
 /*
-- 
2.53.0



