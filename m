Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0075466B4E;
	Tue, 16 Jun 2026 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627436; cv=none; b=AlNj0lgu485W89EoOhx+K8BNjxGjp+5FjUxbi3CClXAw7xR+UPuc2gB9kxPdt7Q53CyEwnUhIzCsljZIYJ7od5b41KLmFS9/qE5YTMVAfqzMrMMZ492dCatG4oqz8Ef8gFeintfw8L9oMg5Q6AGhThmtfYceSPWaqpBy4EP7AKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627436; c=relaxed/simple;
	bh=9GB6SEprNiFBYEiHriUs2J8kw4/LnSifnicL+HQchgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idAaNA1AiysQNrdq2N5zVSO3tLSGsT1vjzogqQ7h34dVBzTzAfqujpGp1aACoCSEw+PWynZ2c71lD5IB3znHWm2DE66Y4Xw2eagZI+X177/VXwbRM6bYq0qyC3LovWEJw02TTwnesAUrJzSN7YIacFM7Lq9NAYVHWom4gTZ8zQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLEwC6Bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLEwC6Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A42C1F000E9;
	Tue, 16 Jun 2026 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627435;
	bh=MwrKsmsUo1fGODvWJfxjr5pJvui1OqYtqIJcnvMzqno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLEwC6Bv6kJPYxe6ufrGIpKyCEPQAqrlF8uUmIZPY0lvGolvmVkZsizvMZBfSoQL4
	 o1GGwlq4T2kJuBw1u7HhpZpSuOu1hYKM/I9n2GrBJIwvIcRt6eq8JIshl+L3+1yX4r
	 dkrO8kQ0IpY0vy178TDS7wpIPnr+g2DnzK4vphFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arpith Kalaginanavoor <arpithk@nvidia.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 170/261] fs/qnx6: fix pointer arithmetic in directory iteration
Date: Tue, 16 Jun 2026 20:30:08 +0530
Message-ID: <20260616145052.947445753@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
 


