Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B031C345741;
	Tue, 26 Aug 2025 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218431; cv=none; b=QAs7LQjtIevxJUij/EBYHw5jnIah9C/5wkIKG3ATRkodBlErAoolB6Lwyw9cR3U1PFxWiRYD+m9n0fpq51Q+k6FsTVV7MopLWxZbsR3Ojp5fDajcP8md57wZNO2Q2+1TOpGvFD1TQJVUjyRIbn+dAzUaFMD7kaXt0Xfx4Y5B2yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218431; c=relaxed/simple;
	bh=fIj94XvyCVPefuJ8U2WPb0TsaG+oSmK5gcO9ci3Hdgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb9afXX6UjVirmiFxjrmg36ABYnYbCu5n9tL9R3CHtRZwdVJSrtAGU7n15R6FdatqiVCXpqS4ckM6e/o5n2ed/zQ4dox9lxgHtXOztfrqC8bwzNxdSB+KzHP/KBNZ3pNSXkBY+MMnVX0nDReN89WEvRXxFuAGqgqtujew0sDO+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpdaWBv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpdaWBv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442FCC4CEF1;
	Tue, 26 Aug 2025 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218431;
	bh=fIj94XvyCVPefuJ8U2WPb0TsaG+oSmK5gcO9ci3Hdgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpdaWBv6OWG2CyqO44nPO0g9UosCCYbLNHKh68P1I0oDqPUcwaUHYCCRsHNJ4Umop
	 y2cQq/90ALh9GqhUv1uUgbtZKm9aJXvO/o7pQwhigR/XrsDSPuitN6+6Qew4aMvF4v
	 48pmPKXBRgCkSyX7cm89T8PoHgOIW38KbuPfrK4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mete Durlu <meted@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 520/523] s390/hypfs: Enable limited access during lockdown
Date: Tue, 26 Aug 2025 13:12:10 +0200
Message-ID: <20250826110937.264790605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



