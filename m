Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632A6214813;
	Wed,  7 May 2025 19:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645230; cv=none; b=Ce1hFP1qvHPHoa9dgidYVNE+J5atBIgiWXuF5t+VY1TSsT2Q/mxN45LVhJeQ58FaamUuM2BFXQXlAuTwBy3t/BaZ+R/PohVs9AL1fxRXBfmsfT5Y6XX3L2oNdgu538G2YLEXhrxDHARbr+DJLkGobn3QB36RSpxkkLTvt8ugHbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645230; c=relaxed/simple;
	bh=KSvXKAhJqOEgKhCIhDRfzWZYGSjVgXLg/Im6ChQW7Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLZU/9265Wxv5A/fxyoWMg+DCrDYemC/URqE4TOuagOTWAlJ2TDrFlQiyB0B2KE2qMOKw08yHZnCG5RXe3L9hpCmtnEfcXo7vippommUBEVxJ6vd/yVsDCUDDre0/zuFg+hWMq8T44DRYe1B5XULkhX2/t1TrsM7fg/2MdfupX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbdpV9qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbdpV9qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D504EC4CEE2;
	Wed,  7 May 2025 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645230;
	bh=KSvXKAhJqOEgKhCIhDRfzWZYGSjVgXLg/Im6ChQW7Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbdpV9qx71ovwF9CLvWINqHnu9XptmxNfiTpGyUk9cnODYRZMnGZ372ldQiuK8RDx
	 cG4U3dax4QN7MwDAki11pGPdqKAu2VTJLWNeYw6VVhNDXBTxEkrRa+ZBJKNMZekK7i
	 Q4/j9zBCdwZiclxbQ0QJCKtLLstNhudJSPdghubw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shyam Saini <shyamsaini@linux.microsoft.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/129] drivers: base: handle module_kobject creation
Date: Wed,  7 May 2025 20:40:59 +0200
Message-ID: <20250507183818.570632647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a33663d92256d..955582b34e54a 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -42,16 +42,13 @@ int module_add_driver(struct module *mod, struct device_driver *drv)
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



