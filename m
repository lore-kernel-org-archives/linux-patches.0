Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2052031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC4GJB5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3C1C433C7;
	Tue, 31 Oct 2023 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771797;
	bh=hU76tPOwe4WJeVzf8y2IhacloJFkDIvS3u/tHueZtBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HC4GJB5VQPkCJzoWbY3TxU5W7CKw1MJLfq7X9I5j582+0chUQ/9JK6aN4hVEfQO63
	 J0GmbqEBmfxGb2cia6XmGbeVUN9wY+/cwPpHOwjfbSvFy7/c2mv1ULFpJy3hWsHXTO
	 tbkLQFpnC6b1gOMxmspGK1kZ19hWG7TV5FxK1zsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gregory.price@memverge.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 23/86] mm/migrate: fix do_pages_move for compat pointers
Date: Tue, 31 Oct 2023 18:00:48 +0100
Message-ID: <20231031165919.334748103@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry.memverge@gmail.com>

commit 229e2253766c7cdfe024f1fe280020cc4711087c upstream.

do_pages_move does not handle compat pointers for the page list.
correctly.  Add in_compat_syscall check and appropriate get_user fetch
when iterating the page list.

It makes the syscall in compat mode (32-bit userspace, 64-bit kernel)
work the same way as the native 32-bit syscall again, restoring the
behavior before my broken commit 5b1b561ba73c ("mm: simplify
compat_sys_move_pages").

More specifically, my patch moved the parsing of the 'pages' array from
the main entry point into do_pages_stat(), which left the syscall
working correctly for the 'stat' operation (nodes = NULL), while the
'move' operation (nodes != NULL) is now missing the conversion and
interprets 'pages' as an array of 64-bit pointers instead of the
intended 32-bit userspace pointers.

It is possible that nobody noticed this bug because the few
applications that actually call move_pages are unlikely to run in
compat mode because of their large memory requirements, but this
clearly fixes a user-visible regression and should have been caught by
ltp.

Link: https://lkml.kernel.org/r/20231003144857.752952-1-gregory.price@memverge.com
Fixes: 5b1b561ba73c ("mm: simplify compat_sys_move_pages")
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1787,6 +1787,7 @@ static int do_pages_move(struct mm_struc
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
+	compat_uptr_t __user *compat_pages = (void __user *)pages;
 	int current_node = NUMA_NO_NODE;
 	LIST_HEAD(pagelist);
 	int start, i;
@@ -1800,8 +1801,17 @@ static int do_pages_move(struct mm_struc
 		int node;
 
 		err = -EFAULT;
-		if (get_user(p, pages + i))
-			goto out_flush;
+		if (in_compat_syscall()) {
+			compat_uptr_t cp;
+
+			if (get_user(cp, compat_pages + i))
+				goto out_flush;
+
+			p = compat_ptr(cp);
+		} else {
+			if (get_user(p, pages + i))
+				goto out_flush;
+		}
 		if (get_user(node, nodes + i))
 			goto out_flush;
 		addr = (unsigned long)untagged_addr(p);


