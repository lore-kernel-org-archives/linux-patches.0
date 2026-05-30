Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1638C3A3E74;
	Sat, 30 May 2026 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160857; cv=none; b=nMu2Ddt+2QqjeHEOVy9cdbjeuShu8bgYNQPF4xsAPao7MIhGDx+rrInHguu9wPC9Zy4Xmh+G80U3BOC9+EHUJXonyLvIMWSlBvR3sd5L01GDdRA7GmcIQc6ymjYtAWJPuv9i6ARnzREsKYs3I6jYxqJACktRm6bOb5NYMmv38KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160857; c=relaxed/simple;
	bh=KMuZnoiPDLyPShCVivt4dp2zYpGPHl1qGlO8+lohjF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+of5TVba5cTaLXjc8emAlq8QMkbeNG9IJ2h8Im87s9dgR45LF76F0I8PcBBc/JmvEu8UyfZWuGOUCcFQBnNBCiShdzZE+TY0rFAGzES57renvVqVGFt0mJ9G0QkqGbHtQQvmpXkxyxnJdz1sswhpD31bexhQGLA2CEm6T6/xUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKxkPB73; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKxkPB73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEFD1F00893;
	Sat, 30 May 2026 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160856;
	bh=Rsv4rW3T+nUjUSyqtYG2JahgwnHKML7J13UtbIA0pSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKxkPB73br6UUaG/EgmKMFnRMR7UewSMmgAazcKDrehMgbReGnNdHIcGAsMBPQw9q
	 snwLkB5DFawMX8YiDDVs9NL0ui5fE1q2BiLKD01f8iJeLOaRgnSlSMUAKtk63ySOJc
	 EW+LkPGZHor8LgrYNSZgTGIf+9Ng3ALDKr6c6J2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 454/969] params: Replace __modinit with __init_or_module
Date: Sat, 30 May 2026 17:59:38 +0200
Message-ID: <20260530160312.813431540@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 3cb0c3bdea5388519bc1bf575dca6421b133302b ]

Remove the custom __modinit macro from kernel/params.c and instead use the
common __init_or_module macro from include/linux/module.h. Both provide the
same functionality.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Stable-dep-of: deffe1edba62 ("module: Fix freeing of charp module parameters when CONFIG_SYSFS=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 587d9cdafd118..5ae507cd19960 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -592,12 +592,6 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 }
 #endif
 
-#ifdef CONFIG_MODULES
-#define __modinit
-#else
-#define __modinit __init
-#endif
-
 #ifdef CONFIG_SYSFS
 void kernel_param_lock(struct module *mod)
 {
@@ -622,9 +616,9 @@ EXPORT_SYMBOL(kernel_param_unlock);
  * create file in sysfs.  Returns an error on out of memory.  Always cleans up
  * if there's an error.
  */
-static __modinit int add_sysfs_param(struct module_kobject *mk,
-				     const struct kernel_param *kp,
-				     const char *name)
+static __init_or_module int add_sysfs_param(struct module_kobject *mk,
+					    const struct kernel_param *kp,
+					    const char *name)
 {
 	struct module_param_attrs *new_mp;
 	struct attribute **new_attrs;
@@ -758,7 +752,8 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-struct module_kobject __modinit * lookup_or_create_module_kobject(const char *name)
+struct module_kobject * __init_or_module
+lookup_or_create_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
-- 
2.53.0



