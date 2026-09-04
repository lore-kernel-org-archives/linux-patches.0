Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40C3A6B82;
	Fri,  4 Sep 2026 05:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498587; cv=none; b=hRp4lCHZyAAv0tJ9TndRY96GHywq/UIIAzbPeUwCCTlp+2KQHOGBIRssx1tlPrUow92A01tVtqh0Mupb+dKpATc9BlTpfFdPQuYJ46pijp1nBO/UtkQrH64ejWx7uF+r4eb2m3glCecujLpy5U2tvgvSuq2StVg291qV3KjOgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498587; c=relaxed/simple;
	bh=wXvhf6M/NactEGyELTa1rTKyikGjTmCHVwdE7bszO/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljTbQLjMjBTYuq9ZQMbCm8HZK5M8Gtq/H9oh3f6PoJasW3o3ov1rRc7RR/AphsKNwZ6g8av5OmvVuU4l1HY3CuM2KnwFk87bNESmOxCYD9gBH6cUTVYZZcGTsaijpnRmV07i4QEo2slDSHi64PkoFp9Cq7Vm8C9WeihUZruvPj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaL/VBk0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaL/VBk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3231F00A3E;
	Fri,  4 Sep 2026 05:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498584;
	bh=2mHlRHQNnwSyFU5bEFWsx05r8OMNh07CPpqYS2ll2P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaL/VBk0tsNqp0WyRMAyf/5Og4vcWW4OL0gSuXhpRznvRHCe+9MRChtyb0qbktB/k
	 k/pjYNKdcK5/j8u2QVlWLbI32Aib/09GMAOwBxE0frpxNuWBobeh1uf+8NvYYGoYJ2
	 xYNpSh0qlpVX92HxbUKWUP5tjt+F0poogdCBEiy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9f9d646b08f3b6032fe@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>
Subject: [PATCH 7.2 114/713] usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()
Date: Fri,  4 Sep 2026 06:51:22 +0200
Message-ID: <20260904045806.392968228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1675,19 +1675,25 @@ static struct se_portal_group *usbg_make
 
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
 
 	tpg = kzalloc_obj(struct usbg_tpg);
@@ -1714,7 +1720,6 @@ static struct se_portal_group *usbg_make
 
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
-	mutex_unlock(&opts->dep_lock);
 	mutex_unlock(&tpg_instances_lock);
 	return &tpg->se_tpg;
 
@@ -1727,8 +1732,6 @@ unref_dep:
 		module_put(opts->dependent);
 	else
 		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
-unlock_dep:
-	mutex_unlock(&opts->dep_lock);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
 
@@ -2666,9 +2669,7 @@ static int tcm_set_name(struct usb_funct
 
 	pr_debug("tcm: Activating %s\n", name);
 
-	mutex_lock(&opts->dep_lock);
-	opts->ready = true;
-	mutex_unlock(&opts->dep_lock);
+	WRITE_ONCE(opts->ready, true);
 
 	return 0;
 }


