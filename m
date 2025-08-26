Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FF319858;
	Tue, 26 Aug 2025 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208166; cv=none; b=S0b04did30E7UKQkChOX25mZSak9xRYw7mKbcHNbWkt+UcpTruYE1MF9hkU/fUj9F7uSmO65CpHl9Hlj1LJNkG+gcqVxy2k7QZERqteEeE2r9KcE8pgCDCWjcQUYLNjaBChe407RjzuNcsvTh59UTDEkoi9HGpgbhnm3wfbLc5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208166; c=relaxed/simple;
	bh=sLiRwiX391gp6Rs4MiKTfav/bzs0AvEzz2Fqd66vED0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5Shj8d18tiIRCRaIU8275FkYlx+qex4cJ+FUzfCEzv+KqmhYy6DU43lvt5P8bVensxPkdiBWqoaipHDSSxJ3zDA5z04AULVO4ybZFie57Pdlv+Rb2HbL/st7x4DZ616+4y3ynbF+xd/0cYunGc0VaazXnhdeMeiv4fl1v+9VJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEZzhSI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEZzhSI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82115C4CEF1;
	Tue, 26 Aug 2025 11:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208165;
	bh=sLiRwiX391gp6Rs4MiKTfav/bzs0AvEzz2Fqd66vED0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEZzhSI8AMKnna0x6w/5/GCWXhcwYvmWSZ/coXgsnxJm8ZRSiEIiZm9h8ivbZ3vMb
	 XZsfY7GVwbMm4GmR/rCEpvBkKhb/v3ls5XfLGKCoxDIQVIpcGULS8uitcxjnyDN3bR
	 u+jgMuyroGH5I6TbaOgyX57She6Cgr3W4+ocJAKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 454/457] s390/hypfs: Enable limited access during lockdown
Date: Tue, 26 Aug 2025 13:12:18 +0200
Message-ID: <20250826110948.505069927@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 3868f910440c47cd5d158776be4ba4e2186beda7 ]

When kernel lockdown is active, debugfs_locked_down() blocks access to
hypfs files that register ioctl callbacks, even if the ioctl interface
is not required for a function. This unnecessarily breaks userspace
tools that only rely on read operations.

Resolve this by registering a minimal set of file operations during
lockdown, avoiding ioctl registration and preserving access for affected
tooling.

Note that this change restores hypfs functionality when lockdown is
active from early boot (e.g. via lockdown=integrity kernel parameter),
but does not apply to scenarios where lockdown is enabled dynamically
while Linux is running.

Tested-by: Mete Durlu <meted@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Fixes: 5496197f9b08 ("debugfs: Restrict debugfs when the kernel is locked down")
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/hypfs/hypfs_dbfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/hypfs/hypfs_dbfs.c b/arch/s390/hypfs/hypfs_dbfs.c
index e74eb8f9b23a..41a0d2066fa0 100644
--- a/arch/s390/hypfs/hypfs_dbfs.c
+++ b/arch/s390/hypfs/hypfs_dbfs.c
@@ -6,6 +6,7 @@
  * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
  */
 
+#include <linux/security.h>
 #include <linux/slab.h>
 #include "hypfs.h"
 
@@ -84,7 +85,7 @@ void hypfs_dbfs_create_file(struct hypfs_dbfs_file *df)
 {
 	const struct file_operations *fops = &dbfs_ops;
 
-	if (df->unlocked_ioctl)
+	if (df->unlocked_ioctl && !security_locked_down(LOCKDOWN_DEBUGFS))
 		fops = &dbfs_ops_ioctl;
 	df->dentry = debugfs_create_file(df->name, 0400, dbfs_dir, df, fops);
 	mutex_init(&df->lock);
-- 
2.50.1



