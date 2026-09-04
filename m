Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C482D738A;
	Fri,  4 Sep 2026 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502000; cv=none; b=Ho2raLvJC0FpaA8iFfDHZF3Lt8bHvFaQXC3O6AICwTbAabYozQMwShyljUM1YKIvjxJ0ai9nnpOq07Yni48GoLDFonP2R4KXyeCWqbii7lSi8oQa+NSBrODm15W6jNCfImxOi3xQVAPHiIP5oN84kCLNq+IjSQIaLqiQKhQV0OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502000; c=relaxed/simple;
	bh=5pRtDXh5ZyRAHCVKJgnzZPdp1kb4sssrD4UCxWnMt14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdEKQR2b37t3LbkwmnAVl9+XKNPtq4TwWN5+zE2N6d7ljQZEecFN0VO/g3tqWyw8cAhsdEwZypBUYSFCMrLkTr4bmRm8ZvDXu2hlbFEfzZYSYUwSkunuypmVwi5BZGdKUEfxMoSmLAane6nbViD86jALePvTlOj4qJH2od4k9Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsF73UZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsF73UZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152F31F00A3D;
	Fri,  4 Sep 2026 06:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501999;
	bh=0WtVJXbwQX/aI0lUAg8c6368NBi2WDFgJiL3gejavx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsF73UZYNPmZdOfUoGoaB7ehZQdKbvzAdwIthYwRHdvQ2A/pKv8Tjqrnb8AZZCyqR
	 BDwDHIa96jEKlya1c7LTdZJA8PqHDVTOC1rKd1KV1FDhgEDcL5NffI1D3ImruOvyWq
	 YgXTjYQKlSFgYZcutmbHkZSx6O4jQ7ZEt3I7hZcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9f9d646b08f3b6032fe@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>
Subject: [PATCH 6.12 055/403] usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()
Date: Fri,  4 Sep 2026 06:57:38 +0200
Message-ID: <20260904045736.079044011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

commit 9dbf74f4022f80f7669d2b3c22c5deb46c1b5674 upstream.

usbg_make_tpg() held dep_lock while calling
configfs_depend_item_unlocked(), which acquires the configfs root
inode lock when operating across subsystems. This creates a circular
lock dependency with configfs_rmdir():

  dep_lock -> configfs root inode lock -> su_mutex -> dep_lock

In usbg_make_tpg(), dep_lock only serialized the read of opts->ready,
which is a monotonic flag that transitions from false to true exactly
once (in tcm_set_name()) and never reverts. Remove dep_lock from
usbg_make_tpg() entirely and use READ_ONCE/WRITE_ONCE to access
opts->ready locklessly instead.

Reported-by: syzbot+c9f9d646b08f3b6032fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9f9d646b08f3b6032fe
Fixes: 4bb8548df632 ("usb: gadget: f_tcm: add configfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Link: https://patch.msgid.link/20260731081151.285599-1-yun.zhou@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1330,19 +1330,25 @@ static struct se_portal_group *usbg_make
 
 	opts = container_of(tpg_instances[i].func_inst, struct f_tcm_opts,
 		func_inst);
-	mutex_lock(&opts->dep_lock);
-	if (!opts->ready)
-		goto unlock_dep;
+	if (!READ_ONCE(opts->ready))
+		goto unlock_inst;
 
 	if (opts->has_dep) {
 		if (!try_module_get(opts->dependent))
-			goto unlock_dep;
+			goto unlock_inst;
 	} else {
+		/*
+		 * configfs_depend_item_unlocked() may acquire the configfs
+		 * root inode lock when the target belongs to a different
+		 * subsystem. Calling it under dep_lock would create a
+		 * circular dependency:
+		 *   dep_lock -> configfs inode lock -> su_mutex -> dep_lock
+		 */
 		ret = configfs_depend_item_unlocked(
 			wwn->wwn_group.cg_subsys,
 			&opts->func_inst.group.cg_item);
 		if (ret)
-			goto unlock_dep;
+			goto unlock_inst;
 	}
 
 	tpg = kzalloc(sizeof(struct usbg_tpg), GFP_KERNEL);
@@ -1368,7 +1374,6 @@ static struct se_portal_group *usbg_make
 
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
-	mutex_unlock(&opts->dep_lock);
 	mutex_unlock(&tpg_instances_lock);
 	return &tpg->se_tpg;
 
@@ -1381,8 +1386,6 @@ unref_dep:
 		module_put(opts->dependent);
 	else
 		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
-unlock_dep:
-	mutex_unlock(&opts->dep_lock);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
 
@@ -2317,9 +2320,7 @@ static int tcm_set_name(struct usb_funct
 
 	pr_debug("tcm: Activating %s\n", name);
 
-	mutex_lock(&opts->dep_lock);
-	opts->ready = true;
-	mutex_unlock(&opts->dep_lock);
+	WRITE_ONCE(opts->ready, true);
 
 	return 0;
 }


