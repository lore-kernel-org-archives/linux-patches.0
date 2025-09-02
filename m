Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832152DAFA1;
	Tue,  2 Sep 2025 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820110; cv=none; b=plhc3w9UUmdkScbATusXD0jP8DNHuSUMaOCUQq+sm40tyjrjhyWBeDQAGSkvdSgrrAsrXn6mrxPd63wL9G4IjoWXVZ34nNC0gT9qEcZwuSPhGI9rbCTB5Yui7EjwRqcG7HYRkUEGN7bKceJCWcpx7yG526SV9yfQJukld7WwuTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820110; c=relaxed/simple;
	bh=/uGD7mo0+6bikeircO7M+gbtoS3TEfqIO10wKEkolcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjyMkYtB8mGkQEHGVtYZ22tfjzWwnrUU9ZVAOlr5uc+cyXtK29ibNcpfPYg0D8zlMe96seaOblXgXWtGkCLyvPZ7CsRbHRwtiGU7/74wwknSbJGXcOEP3UTH8HNDFxKdgVVAZBDxOJC8Y3mPiNw01F5X4JmVdjegoyC0wYQoD2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLmW1zmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLmW1zmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C451C4CEED;
	Tue,  2 Sep 2025 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820110;
	bh=/uGD7mo0+6bikeircO7M+gbtoS3TEfqIO10wKEkolcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLmW1zmVs7Z0egcl2Ob7Y8y/cAckNWog/8N8WBRynO6H8EygoJGYLbGUe9Vb1fj1j
	 EEAwJy2Y/nBwxWNcHma0y8J8ZHYLF5hxIULjE+A3K86wJNUd1rCgMvQRNKQSW0RK9s
	 k5eT2+UmAA3SWnXOvN5apg9Vef1qvOa5/UWc/Kvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Wu Guanghao <wuguanghao3@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 65/95] efivarfs: Fix slab-out-of-bounds in efivarfs_d_compare
Date: Tue,  2 Sep 2025 15:20:41 +0200
Message-ID: <20250902131942.097867416@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit a6358f8cf64850f3f27857b8ed8c1b08cfc4685c ]

Observed on kernel 6.6 (present on master as well):

  BUG: KASAN: slab-out-of-bounds in memcmp+0x98/0xd0
  Call trace:
   kasan_check_range+0xe8/0x190
   __asan_loadN+0x1c/0x28
   memcmp+0x98/0xd0
   efivarfs_d_compare+0x68/0xd8
   __d_lookup_rcu_op_compare+0x178/0x218
   __d_lookup_rcu+0x1f8/0x228
   d_alloc_parallel+0x150/0x648
   lookup_open.isra.0+0x5f0/0x8d0
   open_last_lookups+0x264/0x828
   path_openat+0x130/0x3f8
   do_filp_open+0x114/0x248
   do_sys_openat2+0x340/0x3c0
   __arm64_sys_openat+0x120/0x1a0

If dentry->d_name.len < EFI_VARIABLE_GUID_LEN , 'guid' can become
negative, leadings to oob. The issue can be triggered by parallel
lookups using invalid filename:

  T1			T2
  lookup_open
   ->lookup
    simple_lookup
     d_add
     // invalid dentry is added to hash list

			lookup_open
			 d_alloc_parallel
			  __d_lookup_rcu
			   __d_lookup_rcu_op_compare
			    hlist_bl_for_each_entry_rcu
			    // invalid dentry can be retrieved
			     ->d_compare
			      efivarfs_d_compare
			      // oob

Fix it by checking 'guid' before cmp.

Fixes: da27a24383b2 ("efivarfs: guid part of filenames are case-insensitive")
Signed-off-by: Li Nan <linan122@huawei.com>
Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 11ebddc57bc73..1831e015b2f26 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -127,6 +127,10 @@ static int efivarfs_d_compare(const struct dentry *dentry,
 {
 	int guid = len - EFI_VARIABLE_GUID_LEN;
 
+	/* Parallel lookups may produce a temporary invalid filename */
+	if (guid <= 0)
+		return 1;
+
 	if (name->len != len)
 		return 1;
 
-- 
2.50.1



