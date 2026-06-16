Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CB245349C;
	Tue, 16 Jun 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626011; cv=none; b=oVKuTFKQMDZxtBGXO/JqhJjiJeXtBpagGl4zXBMiKWuxhuVaG8bHZgFilpWQguKmCi+VsbVXjVhHFVSVXaRCKHNuelYnyd9Z9RMtuTBNKyPLffbJ0SwzS/RHDi7aI2Wg3kNwetTK0EaX1dhBtskm0xKuXzCbfjcNXi7mm6iZ5j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626011; c=relaxed/simple;
	bh=zfRPIsFnak2uaAS0aNza/aN8bAEu+64fERY/3C8S+d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueAa+AoqN/QrkErrl3O/B4zMMm0d5poA93N5Ccz3BbrfOtz8msRdJNWNKfc39Jx++e5FRhjm/O+dSHz3hYwFqs4/GvsfN4D8we3POohAX6YrhRlLO8ru5SmJvR1ZBxjvFJYJ3WLmLwlYneB7I1q849SZtHHMDRnEOcaZvLSwMiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUGfEW74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUGfEW74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9EE1F000E9;
	Tue, 16 Jun 2026 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626009;
	bh=8oFjORXxv0IKKLiRd43nSBwz6dQqZ8hM6voPJ4H6gW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUGfEW74oOZC3K5+36sbGbD99/Vq1T/sq15WC6ifj2MknhWGy08FkSsM0QVBRbMKg
	 0hWCBeXzYaWYQC7osjs4k/N0g5XG7xX1sG6ExqtbJoDCzUgXyqvnkcNkiOhUzG44it
	 CLKqZatZt39Ri97ZiM+Mwv30AufDkA690rwkG9tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arpith Kalaginanavoor <arpithk@nvidia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 216/325] fs/qnx6: fix pointer arithmetic in directory iteration
Date: Tue, 16 Jun 2026 20:30:12 +0530
Message-ID: <20260616145108.924747964@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,16 +131,16 @@ static int qnx6_readdir(struct file *fil
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
 


