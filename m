Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4F619AD5C;
	Wed,  7 May 2025 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644303; cv=none; b=N1jfVckEmoYaXIqs17K05S4TOkYT0aO1zHT1Y1VldRUvkxh89jP4hQImBVDgg01g1dfODRWyAWmiGTSKt+jc/zxL9muoz5WWnpx+0EC7F/2Pwt1BCkO6uR12tXhukfDvxQq5dNxuB5KS7R4fGWOh8jHHjiJOfxOVUQgRo9xP1KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644303; c=relaxed/simple;
	bh=TZRzo72VGyl3zl39vfgnmGJxLxmcGPwRqSzRfs2pH8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQKY0CXpEzkDupRTubqTSiJX77Ch3hld5SkMVL6SaUChTeCh5uouzABM447fGte9V4NxRwsJrqsSt2eb5t48qT+z1gjfovVsFD+7ZeW7Gfq2wGcX6t35WMNfGxnaVBK14xSellKksOMKihuJQ0yuY0Ilo8W5elNItZtHxQ8paN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcaFrlOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcaFrlOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219EBC4CEE2;
	Wed,  7 May 2025 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644303;
	bh=TZRzo72VGyl3zl39vfgnmGJxLxmcGPwRqSzRfs2pH8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcaFrlOdkV/a1/r4qKmiBRGSUsua6kmcwTZhyxoFNIA1kGtxzKHQfTg6KEc/gj6yz
	 ZxfWAslbrHYbMEZnWZOtjWq+fyEy43JWkC16NhqdnzEikjYOWF5HsWaH+xJ+xJCTU5
	 qke4TND1M8dD1m32yNpVMSZa9ZOzBX3WKNY0oQeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 176/183] drivers: base: handle module_kobject creation
Date: Wed,  7 May 2025 20:40:21 +0200
Message-ID: <20250507183831.987769220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Saini <shyamsaini@linux.microsoft.com>

[ Upstream commit f95bbfe18512c5c018720468959edac056a17196 ]

module_add_driver() relies on module_kset list for
/sys/module/<built-in-module>/drivers directory creation.

Since,
commit 96a1a2412acba ("kernel/params.c: defer most of param_sysfs_init() to late_initcall time")
drivers which are initialized from subsys_initcall() or any other
higher precedence initcall couldn't find the related kobject entry
in the module_kset list because module_kset is not fully populated
by the time module_add_driver() refers it. As a consequence,
module_add_driver() returns early without calling make_driver_name().
Therefore, /sys/module/<built-in-module>/drivers is never created.

Fix this issue by letting module_add_driver() handle module_kobject
creation itself.

Fixes: 96a1a2412acb ("kernel/params.c: defer most of param_sysfs_init() to late_initcall time")
Cc: stable@vger.kernel.org # requires all other patches from the series
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250227184930.34163-5-shyamsaini@linux.microsoft.com
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/module.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/base/module.c b/drivers/base/module.c
index 5bc71bea883a0..218aaa0964552 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -42,16 +42,13 @@ int module_add_driver(struct module *mod, const struct device_driver *drv)
 	if (mod)
 		mk = &mod->mkobj;
 	else if (drv->mod_name) {
-		struct kobject *mkobj;
-
-		/* Lookup built-in module entry in /sys/modules */
-		mkobj = kset_find_obj(module_kset, drv->mod_name);
-		if (mkobj) {
-			mk = container_of(mkobj, struct module_kobject, kobj);
+		/* Lookup or create built-in module entry in /sys/modules */
+		mk = lookup_or_create_module_kobject(drv->mod_name);
+		if (mk) {
 			/* remember our module structure */
 			drv->p->mkobj = mk;
-			/* kset_find_obj took a reference */
-			kobject_put(mkobj);
+			/* lookup_or_create_module_kobject took a reference */
+			kobject_put(&mk->kobj);
 		}
 	}
 
-- 
2.39.5



