Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F2826C3A4;
	Tue, 26 Aug 2025 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208982; cv=none; b=pUfUJeWTF9HaWGAmVD3DhbC6e3i7kjpx5+IoNgA1qMPfomjXnmh22JfjDDk1yTJvasQwcaSc0qO59OKZTXF0luehJGJ+pkVa/m3lT9nj1PIb4OGUi3r8jINLzOvOATKT+Sm7tI17oxQoo4VoIA77WLwGeGfaBgNxzWYTGct162Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208982; c=relaxed/simple;
	bh=2h3Lu6P7j0zd8WzCSnpp1pgZVxMeHz1JGJFUQ6QGsIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0cwl1hU7xUBCUREeUV0UK3hPT1JPgSKo0B9Rykhk4a1E5bs069gIOH32TWg1YgZJweKvhAyA9PvoJgWR+HmO0V+2DU4H801xSfJutEu65qhkzOxqTqidhz6HNDFWqcJ8W1u756FEMow10ZldQoOPrpBqo6d5NxNzxrQV2L/+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdPZUizH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdPZUizH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF26C4CEF1;
	Tue, 26 Aug 2025 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208982;
	bh=2h3Lu6P7j0zd8WzCSnpp1pgZVxMeHz1JGJFUQ6QGsIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdPZUizHdGdKt6ClnLUKsknFwlDk62UEK7qD4ZAbJbWgQIu5YXRhK8ggX7GDBesFZ
	 lbHDigI4IVEKujIYYra7964o+pEtnCT1EnK528vNpoksTrtf7qkqOLJwQ6+370p6/W
	 D8N5Q6YipkiWH+jZgRXwsRQjHQy2tO1FvRap6Y4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/322] s390/hypfs: Enable limited access during lockdown
Date: Tue, 26 Aug 2025 13:12:15 +0200
Message-ID: <20250826110923.788504994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



