Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C691F09B6;
	Wed, 17 Sep 2025 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112937; cv=none; b=r7bhHKthIJpOtl2pxOZkc7XJrsm1xd4YWRkkAUr1ulMVmRPAnbmYtT+D4tXYjSZLPK2nKlAVyytdoB97Of+V/Py6aGs08ho2RMiyFc1OLCgVjfwZLgywlGEKWr6CSIrW1ZdRsZICuFat/+Wc2Z8rM6ZpC61g47xWD/uHFYBXhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112937; c=relaxed/simple;
	bh=0BL/g2Bq+dUO0aKqZFyb7f3V925BTw/zxWQm98r8U78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOo5gATpfGXF5UXeQd2641bU/UpJkHkxhe6klaJ/WlIFtiQdsc+0B90FRTKt2pr222CNtlL8nH8TMfcvBvjCBeFHrrkOYxiXy94MSotleaEuzBb8knNuS7oXKOvidotRzUtmxH6FYvGvWKyct/JaSM+JK5DDlmtYHY4gQBmAeWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrGJCG1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrGJCG1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220ECC4CEF0;
	Wed, 17 Sep 2025 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112937;
	bh=0BL/g2Bq+dUO0aKqZFyb7f3V925BTw/zxWQm98r8U78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrGJCG1I9uLMPGIkv+sAh5PvRaD/eV7OoH1aaYNm10fzov0QVaIyvjiTXLDFZmROA
	 6+7UYB1ekOa9p5EOUT03anwNCw9tu53NyviXhRJC0xupApCVk6mBhXwNmYBoMtkDLh
	 OV5uJD96vRc4top8S6HMJyaOTjXzSkxjNAcsSX3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.16 104/189] ceph: fix crash after fscrypt_encrypt_pagecache_blocks() error
Date: Wed, 17 Sep 2025 14:33:34 +0200
Message-ID: <20250917123354.405538447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit 249e0a47cdb46bb9eae65511c569044bd8698d7d upstream.

The function move_dirty_folio_in_page_array() was created by commit
ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method") by
moving code from ceph_writepages_start() to this function.

This new function is supposed to return an error code which is checked
by the caller (now ceph_process_folio_batch()), and on error, the
caller invokes redirty_page_for_writepage() and then breaks from the
loop.

However, the refactoring commit has gone wrong, and it by accident, it
always returns 0 (= success) because it first NULLs the pointer and
then returns PTR_ERR(NULL) which is always 0.  This means errors are
silently ignored, leaving NULL entries in the page array, which may
later crash the kernel.

The simple solution is to call PTR_ERR() before clearing the pointer.

Cc: stable@vger.kernel.org
Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8bc66b45dade..322ed268f14a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1264,7 +1264,9 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 								0,
 								gfp_flags);
 		if (IS_ERR(pages[index])) {
-			if (PTR_ERR(pages[index]) == -EINVAL) {
+			int err = PTR_ERR(pages[index]);
+
+			if (err == -EINVAL) {
 				pr_err_client(cl, "inode->i_blkbits=%hhu\n",
 						inode->i_blkbits);
 			}
@@ -1273,7 +1275,7 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 			BUG_ON(ceph_wbc->locked_pages == 0);
 
 			pages[index] = NULL;
-			return PTR_ERR(pages[index]);
+			return err;
 		}
 	} else {
 		pages[index] = &folio->page;
-- 
2.51.0



