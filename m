Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E4D2DAFBA;
	Wed, 28 Jan 2026 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598838; cv=none; b=sN3aypm5PDqRG8IgxyzPFr9DSe5VgXzbxFwH1EhzK+mmD2eJp/BrJk2OEwStf8DF+gYRmA65vhih6S5IHzj6rUew9iEC9Yn5tMVLd291UwaWy660V6g/QZgvIIufgunN96nKZgFz7VeyRe9OV2zjnxmmfGNNg8kCw1wknWasT0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598838; c=relaxed/simple;
	bh=kidMzPn869avulF3jUa7Mpx56aILkBVsRjJQb3fbczk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=RDwT8XbBeVAoC9I2jpR8mzRE0j2lSjefXNJ19ZplllbV90D5jHohP193wKtXddnm4FyRo7pHhyihussOWgkMLn/baV4r9SzgXrC8VuIb1w8SJUZswzF6UOV7bH9G/L4d9noy1r6FStjgvOI5u1vpBeVuS6QDWjsbBWELnMBhfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hs9W/jXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hs9W/jXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC09C4CEF1;
	Wed, 28 Jan 2026 11:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769598837;
	bh=kidMzPn869avulF3jUa7Mpx56aILkBVsRjJQb3fbczk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Hs9W/jXLs5LE/QAk4LtBhp5gt68fVggnzWjSnY+7iSy8yIHJU7mwQrhqhZC3QnCPO
	 8Rw31RFWZ494ixVXo/4qjFZel4x0gwdhwOxCYHytwz68xoq2V3iI3RiDPpqutN4qo0
	 /2+iuAJ4alTJUuSWIUW3OEUhrSyA0PDBKnTtFI6E=
Subject: Patch "exfat: fix refcount leak in exfat_find" has been added to the 6.12-stable tree
To: 1468888505@139.com,Yuezhang.Mo@sony.com,gregkh@linuxfoundation.org,jimmyxyz010315@gmail.com,kkamagui@gmail.com,linkinjeon@kernel.org,p22gone@gmail.com,patches@lists.linux.dev,sfual@cse.ust.hk,sj1557.seo@samsung.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 28 Jan 2026 12:13:10 +0100
In-Reply-To: <20260123023721.3779125-1-1468888505@139.com>
Message-ID: <2026012810-shrink-handful-397f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    exfat: fix refcount leak in exfat_find

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     exfat-fix-refcount-leak-in-exfat_find.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Fri Jan 23 03:37:25 2026
From: Li hongliang <1468888505@139.com>
Date: Fri, 23 Jan 2026 10:37:21 +0800
Subject: exfat: fix refcount leak in exfat_find
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, sfual@cse.ust.hk
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, Yuezhang.Mo@sony.com, linkinjeon@kernel.org, sj1557.seo@samsung.com, p22gone@gmail.com, kkamagui@gmail.com, jimmyxyz010315@gmail.com, linux-fsdevel@vger.kernel.org
Message-ID: <20260123023721.3779125-1-1468888505@139.com>

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit 9aee8de970f18c2aaaa348e3de86c38e2d956c1d ]

Fix refcount leaks in `exfat_find` related to `exfat_get_dentry_set`.

Function `exfat_get_dentry_set` would increase the reference counter of
`es->bh` on success. Therefore, `exfat_put_dentry_set` must be called
after `exfat_get_dentry_set` to ensure refcount consistency. This patch
relocate two checks to avoid possible leaks.

Fixes: 82ebecdc74ff ("exfat: fix improper check of dentry.stream.valid_size")
Fixes: 13940cef9549 ("exfat: add a check for invalid data size")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -638,16 +638,6 @@ static int exfat_find(struct inode *dir,
 	info->valid_size = le64_to_cpu(ep2->dentry.stream.valid_size);
 	info->size = le64_to_cpu(ep2->dentry.stream.size);
 
-	if (info->valid_size < 0) {
-		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
-		return -EIO;
-	}
-
-	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
-		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
-		return -EIO;
-	}
-
 	info->start_clu = le32_to_cpu(ep2->dentry.stream.start_clu);
 	if (!is_valid_cluster(sbi, info->start_clu) && info->size) {
 		exfat_warn(sb, "start_clu is invalid cluster(0x%x)",
@@ -685,6 +675,16 @@ static int exfat_find(struct inode *dir,
 			     0);
 	exfat_put_dentry_set(&es, false);
 
+	if (info->valid_size < 0) {
+		exfat_fs_error(sb, "data valid size is invalid(%lld)", info->valid_size);
+		return -EIO;
+	}
+
+	if (unlikely(EXFAT_B_TO_CLU_ROUND_UP(info->size, sbi) > sbi->used_clusters)) {
+		exfat_fs_error(sb, "data size is invalid(%lld)", info->size);
+		return -EIO;
+	}
+
 	if (ei->start_clu == EXFAT_FREE_CLUSTER) {
 		exfat_fs_error(sb,
 			       "non-zero size file starts with zero cluster (size : %llu, p_dir : %u, entry : 0x%08x)",


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.12/exfat-fix-refcount-leak-in-exfat_find.patch
queue-6.12/fs-ntfs3-initialize-allocated-memory-before-use.patch
queue-6.12/wifi-ath11k-fix-rcu-stall-while-reaping-monitor-destination-ring.patch
