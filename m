Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B463C3C09;
	Sat, 17 Oct 2026 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255681; cv=none; b=kUyLuVRzuKSOz1hKqjbDPu5pJqdmGWd7dVs2xfpQ4xfgMNdzY8vwMrmP2YrWI6QXcqc4fgN9uP7skkbTflVjRg4eRGlMTlNNvTXxKr0BYAfxC7kCyR/pJ4nTzuXNb22KZA2MJI1fKZgDjK3882jAq9ET5pSTac90wF/yp7PUNMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255681; c=relaxed/simple;
	bh=UN1lOcSJ5xwMRNLAjd3/rwSDoQY+kJsA8ScRuhHFH6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT3ggDVbIqgv2gzeLZaVHvNfaGVEoAO7EphoK2c2VdJgH6mahOka4+Kgsp0izrtBVASE+2gHkAmTjo7jBloOsKvuKaT6BVHTCG1saaudTZyR4NUDFf7S5/7n7+5DwimfR6YSY4WBIwis5KfWinLtpthFkw1m1GrTfvH29ax8iIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkMwvfTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkMwvfTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDA01F000C4;
	Sat, 17 Oct 2026 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255680;
	bh=es/2LV206RIuWd2bA+B0HXjTI8Sm04d9rDc91UmeNL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkMwvfTEkt+7/iinbTXPm5qc9oFQREUa2i/a1Q11iGa86Es7bjqzzgTveu37S88eq
	 lq2eWrv+nmCdMsUYB06vaNDPbVj0Z+2DFv4eTpgvQRx2E2YvWl8tuuzbx9uhC3089t
	 cJyJgFKvlkIvJ+3lHNg3iozbb0oAJP2vwbU0Sy4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 839/869] ceph: fix crash after fscrypt_encrypt_pagecache_blocks() error
Date: Sat, 17 Oct 2026 18:01:20 +0200
Message-ID: <20261017160058.383140253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 249e0a47cdb46bb9eae65511c569044bd8698d7d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c20ef77bb6f0c..7d24bb943b1ee 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1259,7 +1259,9 @@ int ceph_move_dirty_page_in_page_array(struct address_space *mapping,
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
@@ -1268,7 +1270,7 @@ int ceph_move_dirty_page_in_page_array(struct address_space *mapping,
 			BUG_ON(ceph_wbc->locked_pages == 0);
 
 			pages[index] = NULL;
-			return PTR_ERR(pages[index]);
+			return err;
 		}
 	} else {
 		pages[index] = page;
-- 
2.53.0



