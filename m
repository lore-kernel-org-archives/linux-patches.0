Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA2357D14;
	Tue, 16 Jun 2026 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624150; cv=none; b=A83S6AqnQRiHQmzUpwqXzj/AnfpHBxo3Y76pT9IWry0RdKqGIQPRgY5M/PuVxm077omZu70/GH2JO3qegCqKGRDzrgUBtAPpZE7yc1KakgtUQ50YbW6+n6rTm5z9c73ctQsfu9IisSw7Aza63+VQO0F7auVjclbkZxdxWPjAsX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624150; c=relaxed/simple;
	bh=LdXpNx0r59w3ORUlRDxKkGXnGASJ6B56i+x8hWiP/Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSwqu5UiNhTflz/irGOUrcTxzfWu2SwtNGNekxr0YwhXQwjGkSO/E3EgmRjRC8vJ5n14K2mgtEZNjpZsDHw+ZyZCGOqz3Xi68z0iT+uC4IftmgYMBlRZdLltlU0H8weHSJVMTg/OG3tsmerubctz2oE5zqZFs/ika9ZrJC/WOo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFjLtyZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFjLtyZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643E41F000E9;
	Tue, 16 Jun 2026 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624148;
	bh=ryKkHSL6PDMycnxx7jr82vG4xIap+tKOSeuazt7oXOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFjLtyZRadZYVelBTzsN1ZnQRf/J+lvcaCXTS+m8s6rOxr/BEdcLNwZM5O2ZahXdH
	 fjnP21ZuyO50kfDGVSNsSWUZlrhdvYmMrAMGf8V2hprN5J7maIV6tEqf5SB/aJFa/2
	 taCVp65IA6km+35LHNrgR2kZ2JnZJfXffSJcksNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arpith Kalaginanavoor <arpithk@nvidia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.0 265/378] fs/qnx6: fix pointer arithmetic in directory iteration
Date: Tue, 16 Jun 2026 20:28:16 +0530
Message-ID: <20260616145124.041486752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Arpith Kalaginanavoor <arpithk@nvidia.com>

commit 89c4a1167f3a0a0efd2ec3e1801036d2eb65ae1a upstream.

The conversion to qnx6_get_folio() in commit b2aa61556fcf
("qnx6: Convert qnx6_get_page() to qnx6_get_folio()")
introduced a regression in directory iteration. The pointer 'de'
and the 'limit' address were calculated using byte offsets from
a char pointer without scaling by the size of a QNX6 directory
entry.

This causes the driver to read from incorrect memory offsets,
leading to "invalid direntry size" errors and premature
termination of directory scans.

Fix this by casting 'kaddr' to 'struct qnx6_dir_entry *' before
applying the offset and last_entry(...) increments. This allows the
compiler to correctly scale the pointer arithmetic by the 32-byte
stride of the directory entry structure.

Fixes: b2aa61556fcf ("qnx6: Convert qnx6_get_page() to qnx6_get_folio()")
Cc: stable@vger.kernel.org
Signed-off-by: Arpith Kalaginanavoor <arpithk@nvidia.com>
Link: https://patch.msgid.link/20260526123858.1683035-1-arpithk@nvidia.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/qnx6/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -132,16 +132,16 @@ static int qnx6_readdir(struct file *fil
 		struct qnx6_dir_entry *de;
 		struct folio *folio;
 		char *kaddr = qnx6_get_folio(inode, n, &folio);
-		char *limit;
+		struct qnx6_dir_entry *limit;
 
 		if (IS_ERR(kaddr)) {
 			pr_err("%s(): read failed\n", __func__);
 			ctx->pos = (n + 1) << PAGE_SHIFT;
 			return PTR_ERR(kaddr);
 		}
-		de = (struct qnx6_dir_entry *)(kaddr + offset);
-		limit = kaddr + last_entry(inode, n);
-		for (; (char *)de < limit; de++, ctx->pos += QNX6_DIR_ENTRY_SIZE) {
+		de = (struct qnx6_dir_entry *)kaddr + offset;
+		limit = (struct qnx6_dir_entry *)kaddr + last_entry(inode, n);
+		for (; de < limit; de++, ctx->pos += QNX6_DIR_ENTRY_SIZE) {
 			int size = de->de_size;
 			u32 no_inode = fs32_to_cpu(sbi, de->de_inode);
 


