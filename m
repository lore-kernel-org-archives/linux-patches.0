Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B632765DF;
	Wed, 25 Feb 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983638; cv=none; b=WzuVnqmOoBGo3jYvutKjgTpPzq4fb3q/CPaGV1uqBPOgGIk5VWZYxJwoHjUr6D3BLl4StJGOHna5aCBxHeIiy9B7dFRzstGISwSuAxjjnO440E2h+g27pGGjSHlilIN8rVZHTcLbqlE8hb57PZHhEmgIAcEyj4Bpt9uUzKsXjF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983638; c=relaxed/simple;
	bh=WC2U96jU+SHQ11OEAD/LB9E39EYqvbwEBTTroA9zIn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls+KZ+ADBJjTLAwUr2ezwjNNBnRqOD6u6CrlGuwL/vtmHer2gIIHQL0yuSkGmZpZpEn8tHR8R1UDr8Eoq+qx4h9AupVD49NUCKyhKhA5EchvF4jMJsEolKR2hvK56l0ozZiNO/DoNkj5THCZ2gfC77mnBdiXW43PwqjImk0AYuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhdyAxci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhdyAxci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72477C116D0;
	Wed, 25 Feb 2026 01:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983638;
	bh=WC2U96jU+SHQ11OEAD/LB9E39EYqvbwEBTTroA9zIn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhdyAxciK7HVFDEYWeNuyvlXPFJQxeP9wgH1d2jlY07jxZVpU8/UNKWG0xcCJ+xHW
	 Uo3KTthAkuWAmvC2CyBUdMzPhAbNVmeUYDm4GHWNUMncAyM+wEttw+JYVFqehyNXBG
	 TsbHHtH2lIEJmAYzkWfGawDzg29IPo+/H+AjA+tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 727/781] drm/xe/pf: Fix sysfs initialization
Date: Tue, 24 Feb 2026 17:23:56 -0800
Message-ID: <20260225012417.567593197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit bf7172cd25ed182f30af2cbb9f80c730dc717d8e ]

In case of devm_add_action_or_reset() failure the provided cleanup
action will be run immediately on the not yet initialized kobject.
This may lead to errors like:

 [ ] kobject: '(null)' (ff110001393608e0): is not initialized, yet kobject_put() is being called.
 [ ] WARNING: lib/kobject.c:734 at kobject_put+0xd9/0x250, CPU#0: kworker/0:0/9
 [ ] RIP: 0010:kobject_put+0xdf/0x250
 [ ] Call Trace:
 [ ]  xe_sriov_pf_sysfs_init+0x21/0x100 [xe]
 [ ]  xe_sriov_pf_init_late+0x87/0x2b0 [xe]
 [ ]  xe_sriov_init_late+0x5f/0x2c0 [xe]
 [ ]  xe_device_probe+0x5f2/0xc20 [xe]
 [ ]  xe_pci_probe+0x396/0x610 [xe]
 [ ]  local_pci_probe+0x47/0xb0

 [ ] refcount_t: underflow; use-after-free.
 [ ] WARNING: lib/refcount.c:28 at refcount_warn_saturate+0x68/0xb0, CPU#0: kworker/0:0/9
 [ ] RIP: 0010:refcount_warn_saturate+0x68/0xb0
 [ ] Call Trace:
 [ ]  kobject_put+0x174/0x250
 [ ]  xe_sriov_pf_sysfs_init+0x21/0x100 [xe]
 [ ]  xe_sriov_pf_init_late+0x87/0x2b0 [xe]
 [ ]  xe_sriov_init_late+0x5f/0x2c0 [xe]
 [ ]  xe_device_probe+0x5f2/0xc20 [xe]
 [ ]  xe_pci_probe+0x396/0x610 [xe]
 [ ]  local_pci_probe+0x47/0xb0

Fix that by calling kobject_init() and kobject_add() separately
and register cleanup action after the kobject is initialized.

Also make this cleanup registration a part of the create helper to
fix another mistake, as in the loop we were wrongly passing parent
kobject while registering cleanup action, and this resulted in some
undetected leaks.

Fixes: 5c170a4d9c53 ("drm/xe/pf: Prepare sysfs for SR-IOV admin attributes")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260203235332.1350-1-michal.wajdeczko@intel.com
(cherry picked from commit 98b16727f07e26a5d4de84d88805ce7ffcfdd324)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_sriov_pf_sysfs.c | 54 +++++++++++++-------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_sysfs.c b/drivers/gpu/drm/xe/xe_sriov_pf_sysfs.c
index c0b767ac735cf..d1c1f6c295664 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_sysfs.c
@@ -349,18 +349,33 @@ static const struct attribute_group *xe_sriov_vf_attr_groups[] = {
 
 /* no user serviceable parts below */
 
-static struct kobject *create_xe_sriov_kobj(struct xe_device *xe, unsigned int vfid)
+static void action_put_kobject(void *arg)
+{
+	struct kobject *kobj = arg;
+
+	kobject_put(kobj);
+}
+
+static struct kobject *create_xe_sriov_kobj(struct xe_device *xe, unsigned int vfid,
+					    const struct kobj_type *ktype)
 {
 	struct xe_sriov_kobj *vkobj;
+	int err;
 
 	xe_sriov_pf_assert_vfid(xe, vfid);
 
 	vkobj = kzalloc(sizeof(*vkobj), GFP_KERNEL);
 	if (!vkobj)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	vkobj->xe = xe;
 	vkobj->vfid = vfid;
+	kobject_init(&vkobj->base, ktype);
+
+	err = devm_add_action_or_reset(xe->drm.dev, action_put_kobject, &vkobj->base);
+	if (err)
+		return ERR_PTR(err);
+
 	return &vkobj->base;
 }
 
@@ -471,28 +486,17 @@ static void pf_sysfs_note(struct xe_device *xe, int err, const char *what)
 	xe_sriov_dbg(xe, "Failed to setup sysfs %s (%pe)\n", what, ERR_PTR(err));
 }
 
-static void action_put_kobject(void *arg)
-{
-	struct kobject *kobj = arg;
-
-	kobject_put(kobj);
-}
-
 static int pf_setup_root(struct xe_device *xe)
 {
 	struct kobject *parent = &xe->drm.dev->kobj;
 	struct kobject *root;
 	int err;
 
-	root = create_xe_sriov_kobj(xe, PFID);
-	if (!root)
-		return pf_sysfs_error(xe, -ENOMEM, "root obj");
-
-	err = devm_add_action_or_reset(xe->drm.dev, action_put_kobject, root);
-	if (err)
-		return pf_sysfs_error(xe, err, "root action");
+	root = create_xe_sriov_kobj(xe, PFID, &xe_sriov_dev_ktype);
+	if (IS_ERR(root))
+		return pf_sysfs_error(xe, PTR_ERR(root), "root obj");
 
-	err = kobject_init_and_add(root, &xe_sriov_dev_ktype, parent, "sriov_admin");
+	err = kobject_add(root, parent, "sriov_admin");
 	if (err)
 		return pf_sysfs_error(xe, err, "root init");
 
@@ -513,20 +517,14 @@ static int pf_setup_tree(struct xe_device *xe)
 	root = xe->sriov.pf.sysfs.root;
 
 	for (n = 0; n <= totalvfs; n++) {
-		kobj = create_xe_sriov_kobj(xe, VFID(n));
-		if (!kobj)
-			return pf_sysfs_error(xe, -ENOMEM, "tree obj");
-
-		err = devm_add_action_or_reset(xe->drm.dev, action_put_kobject, root);
-		if (err)
-			return pf_sysfs_error(xe, err, "tree action");
+		kobj = create_xe_sriov_kobj(xe, VFID(n), &xe_sriov_vf_ktype);
+		if (IS_ERR(kobj))
+			return pf_sysfs_error(xe, PTR_ERR(kobj), "tree obj");
 
 		if (n)
-			err = kobject_init_and_add(kobj, &xe_sriov_vf_ktype,
-						   root, "vf%u", n);
+			err = kobject_add(kobj, root, "vf%u", n);
 		else
-			err = kobject_init_and_add(kobj, &xe_sriov_vf_ktype,
-						   root, "pf");
+			err = kobject_add(kobj, root, "pf");
 		if (err)
 			return pf_sysfs_error(xe, err, "tree init");
 
-- 
2.51.0



