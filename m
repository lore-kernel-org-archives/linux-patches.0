Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C501F543C;
	Tue, 17 Dec 2024 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455438; cv=none; b=RRDmKU8sbK95/hf/BAlKvycG1xoSzj7LVaFyxTgF9QAjbxR/54//oHgf6fV7MCrpPqxNSQ9CHv7EweXH1OsjDWCvgCZPJYyVUKUhVYv2jyoMfqSyVoJi6qDnbnMHrMHOp+iIAK7dcZUVEx6yrlEJ/d9/r8YspbidRoU5fPUUbTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455438; c=relaxed/simple;
	bh=JkxWJOOo+MpokwxmZAgS8d54HAENlvoK/sldgrUOnKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNCMPMOq19t3vQnjSCa4DYQv5r2khGUfKbeWQZGiJ7HqQhnJpqv05apR043AdwnBwsnmVteSCowwLB8KF5hZiUXNJu7HiLK0JGzR80nLQfZJoavXgktJ2oX+wOyw0LXq7PriWjVN/Wt4HcZivTZEKcGB3QxsbJ3NSWxvm2h2vDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB4ywmR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB4ywmR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD522C4CED3;
	Tue, 17 Dec 2024 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455438;
	bh=JkxWJOOo+MpokwxmZAgS8d54HAENlvoK/sldgrUOnKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB4ywmR2pFlmfdRjnGpv/3pRAfnqewAmCRr9nXfUQCI8ejMRQJ2zFd/wTWULFUj0B
	 GKL/1sBJpSFzWeoEDjTlJDZPbwlb5Ea0/1/95HrkVE2n3T58XfrXLLU82rx6o0yXHy
	 R1CJh8h1YY0jh6K01wGrXw/O0kZkwkYPKo/SmHOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.10 11/43] exfat: fix potential deadlock on __exfat_get_dentry_set
Date: Tue, 17 Dec 2024 18:07:02 +0100
Message-ID: <20241217170520.913023504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 89fc548767a2155231128cb98726d6d2ea1256c9 upstream.

When accessing a file with more entries than ES_MAX_ENTRY_NUM, the bh-array
is allocated in __exfat_get_entry_set. The problem is that the bh-array is
allocated with GFP_KERNEL. It does not make sense. In the following cases,
a deadlock for sbi->s_lock between the two processes may occur.

       CPU0                CPU1
       ----                ----
  kswapd
   balance_pgdat
    lock(fs_reclaim)
                      exfat_iterate
                       lock(&sbi->s_lock)
                       exfat_readdir
                        exfat_get_uniname_from_ext_entry
                         exfat_get_dentry_set
                          __exfat_get_dentry_set
                           kmalloc_array
                            ...
                            lock(fs_reclaim)
    ...
    evict
     exfat_evict_inode
      lock(&sbi->s_lock)

To fix this, let's allocate bh-array with GFP_NOFS.

Fixes: a3ff29a95fde ("exfat: support dynamic allocate bh for exfat_entry_set_cache")
Cc: stable@vger.kernel.org # v6.2+
Reported-by: syzbot+412a392a2cd4a65e71db@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/000000000000fef47e0618c0327f@google.com
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[Sherry: The problematic commit was backported to 5.15.y and 5.10.y, thus backport this fix]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -873,7 +873,7 @@ struct exfat_entry_set_cache *exfat_get_
 
 	num_bh = EXFAT_B_TO_BLK_ROUND_UP(off + num_entries * DENTRY_SIZE, sb);
 	if (num_bh > ARRAY_SIZE(es->__bh)) {
-		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_KERNEL);
+		es->bh = kmalloc_array(num_bh, sizeof(*es->bh), GFP_NOFS);
 		if (!es->bh) {
 			brelse(bh);
 			kfree(es);


