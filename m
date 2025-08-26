Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3B72E6106;
	Tue, 26 Aug 2025 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215354; cv=none; b=U9UNkb2snLxjjwQHgcNogi8fMh0GKFcAZWV3GZXJ7NU52VnJZJvsOokfAmEGWTduH2FpGbnXQlLuEm/dlDH4uwjcYR3agDH+rGPIYjADby1FKOaDF52DNrTH1nLjzeGZZUs018G6lEejTVCWnXe6nnXbGWJyTdz3qvfOtAqnbjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215354; c=relaxed/simple;
	bh=nx7KeatHjlE6TRF4FqHBmasg7rjUjaLxmMUwJ4AMDwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR1rgqfd+HZ5Qxu7xBX05z9V3Qf8YebFL8SHStOHSZVJLz3agj1+F37mle2hiwT0m3tQrMbbQKiJA9tiQ1u60hyuD0rzQyaIf7K+++GAEZPK1RhsjfKeoQX5D31jGw8yyONA6/BgqHb1RKBt16xAeUgf5Y3H+KI0+7YloEBDNYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jL2if5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jL2if5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C7C4CEF1;
	Tue, 26 Aug 2025 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215354;
	bh=nx7KeatHjlE6TRF4FqHBmasg7rjUjaLxmMUwJ4AMDwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jL2if5SvzSW/QZIvX+ZZyS8Q6ojqD9qywy0a6GrOtuR3mKeKl1aInbY2Gh39YPds
	 euB6c1QQbDARk94BmwT8/YstHJSWwa6rxj3iWPHd4gDO7K654iPqXlmr6QgSWBrAI2
	 0e3aRqtCb4l18/kibKrjkjkxcpRF8dxAaZI6Axz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 481/482] s390/hypfs: Enable limited access during lockdown
Date: Tue, 26 Aug 2025 13:12:14 +0200
Message-ID: <20250826110942.698105972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5f53dc3dbbc..5848f2e374a6 100644
--- a/arch/s390/hypfs/hypfs_dbfs.c
+++ b/arch/s390/hypfs/hypfs_dbfs.c
@@ -6,6 +6,7 @@
  * Author(s): Michael Holzheu <holzheu@linux.vnet.ibm.com>
  */
 
+#include <linux/security.h>
 #include <linux/slab.h>
 #include "hypfs.h"
 
@@ -83,7 +84,7 @@ void hypfs_dbfs_create_file(struct hypfs_dbfs_file *df)
 {
 	const struct file_operations *fops = &dbfs_ops;
 
-	if (df->unlocked_ioctl)
+	if (df->unlocked_ioctl && !security_locked_down(LOCKDOWN_DEBUGFS))
 		fops = &dbfs_ops_ioctl;
 	df->dentry = debugfs_create_file(df->name, 0400, dbfs_dir, df, fops);
 	mutex_init(&df->lock);
-- 
2.50.1



