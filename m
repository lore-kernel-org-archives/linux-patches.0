Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FBA34EF05;
	Wed, 20 May 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296040; cv=none; b=exa/6FI5PxDla3eCQt+S6DJp80gLgNBaH+BvTH9pV/AIXUvBDgutbiqOQCSWfI+CLLOslXldBZBPPPgMWXD+yTS975xeqRLMu1gU/S1KowhfWCSAkePFhsmBggstf12IgubRRaAuc7ocXhcChNt2IgkfB/aWQN9F9z5wuXj2eBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296040; c=relaxed/simple;
	bh=34eSHC/IuNfmRxmI2JkZW+YLKVX6RqI+3+VTnu2rjBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osi/sRslYG3xwWozXYKBK6YYPw29gksiN/NfWRnUnE61QcUKo6kHUEW+mifDQmRSTke9LnNsylOp+4Adm2C5o5OSkpdeodZeP4eXEusyr/oYNx84/U3uOPnWYJraz32IVG5KY0W/PCYMpTneCK0o4HNXXP+Tf6TOnamJBv/WnHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMHCxnX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMHCxnX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDE41F000E9;
	Wed, 20 May 2026 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296039;
	bh=TZBINoxmHAh2cPCADfs9vy+jb9eGzTJOWZdF5jEPglc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMHCxnX/lSQcwRg94BGA4YNzfZttCkB8msqGz967Nt8FiFO/w3Lq6XbKW/kUnvZxa
	 BI+qY9lT91IHGL2CZ6CGAGMcRk2/6XrxXDkxRhfdCD+kSd5RWpowQck0t5xMSH5v0W
	 6ZcNBLWKDnRtURwgxTPTgHtN807j8D7eF72LgBX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0607/1146] ext4: fix possible null-ptr-deref in extents_kunit_exit()
Date: Wed, 20 May 2026 18:14:17 +0200
Message-ID: <20260520162201.917760489@linuxfoundation.org>
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

[ Upstream commit ca78c31af467ffe94b15f6a2e4e1cc1c164db19b ]

There's issue as follows:
KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
RIP: 0010:extents_kunit_exit+0x2e/0xc0 [ext4_test]
Call Trace:
 <TASK>
 kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
 kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
 kthread+0x408/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

Above issue happens as extents_kunit_init() init testcase failed.
So test if testcase is inited success.

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20260330133035.287842-5-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents-test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 4042bc8a95e2f..6b53a3f39fcd6 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -142,9 +142,12 @@ static struct file_system_type ext_fs_type = {
 
 static void extents_kunit_exit(struct kunit *test)
 {
-	struct super_block *sb = k_ctx.k_ei->vfs_inode.i_sb;
-	struct ext4_sb_info *sbi = sb->s_fs_info;
+	struct ext4_sb_info *sbi;
 
+	if (!k_ctx.k_ei)
+		return;
+
+	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
 	ext4_es_unregister_shrinker(sbi);
 	deactivate_super(sbi->s_sb);
 	kfree(sbi);
-- 
2.53.0



