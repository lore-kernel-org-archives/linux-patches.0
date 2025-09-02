Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8EF2D4B4E;
	Tue,  2 Sep 2025 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820781; cv=none; b=PPbU0089EsIAEmPde6TY+SE/sk5CByFc3V63jyLHESiP+QdrewEq9qOC1PATIgoLP1PX4A5/SEd6TrYE9/+OehbYVqC5fySM+8AiWdecqVITfJSPLF50OiHNxmlxjhqNWCVObIjZvJjjXrLRVY6/bxcot7IwZ+sQCVbPMMpqGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820781; c=relaxed/simple;
	bh=BaAYJOmP3u55KVXVB/RK0/3XmkeeMnuGR0fAEBCUAPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAFfJoSwAZUwvfS7cIoG7XdVjQau1wJYAXcaMeCSxrvIZFjx6qJUGo/KB36fwJb4FrVqkVxS8nwNPkoNjtD7XLfvPZDMMNU+4nTfsq0W1fl+r2C+UuaZcG83QSPAOYw/9kOiXTm7o+QXDQomFP14MnHUtfQWRyG8dA/cpX7iBFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+GL9rBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+GL9rBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E929AC4CEED;
	Tue,  2 Sep 2025 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820781;
	bh=BaAYJOmP3u55KVXVB/RK0/3XmkeeMnuGR0fAEBCUAPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+GL9rBQ/ATR/KMVjr/qx9MUdX4xrvgG5zTcWyV2A7IMqHEkpAC8cby/doVggy7Jn
	 PBSKBltJxMzIYfL0bcQHDB4XATtVSLIxOb5N+Ow/RhWlQeqtjRy/L/46qWOOFX1qYZ
	 rjv4x+7r9dtoerCJZIfbXzlCdOXA4jD+asAgZ83U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Wu Guanghao <wuguanghao3@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/23] efivarfs: Fix slab-out-of-bounds in efivarfs_d_compare
Date: Tue,  2 Sep 2025 15:22:02 +0200
Message-ID: <20250902131925.379537350@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 fs/efivarfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -46,6 +46,10 @@ static int efivarfs_d_compare(const stru
 {
 	int guid = len - EFI_VARIABLE_GUID_LEN;
 
+	/* Parallel lookups may produce a temporary invalid filename */
+	if (guid <= 0)
+		return 1;
+
 	if (name->len != len)
 		return 1;
 


