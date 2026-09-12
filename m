Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56693381E88;
	Sat, 12 Sep 2026 19:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241071; cv=none; b=EYuMM1qv9lsQrDnwKKWOcK3It+IzEau58/lhsNu1DHH9KZZQPohzTy1FG2C9HpdDy6vPAb1Xsw50m1p6+H9KOi9uYc6At1DFPuYksDb7FQR2A36R6x6UFvCGI3x2/vJJZE9G0fqT/ALnbCJLD716WtMyR/+XnzostzV5P+Rjfjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241071; c=relaxed/simple;
	bh=CKskG4GilF3WALpHzBXJWJXuPUXuYO2jf0KtmSRes8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo6JXypcqoc/1TrdeAW/DUvfhfy850dYZysB603nHWfkh3au3oalW1Q7Jf8o42n0qSgvtOnuG3rpITYHnXhzPlKuepH9ZxQubNLIEjF9HILoYMsYTgZdScQR18kL/S/NAMZItcFFAwrZ98aVJMbc1+VPS6nkChg/KU/XxlarBA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pObd4ibU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pObd4ibU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F031F000FF;
	Sat, 12 Sep 2026 19:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241068;
	bh=AGxK1m7eI1i/CyiOrdKkytZbbmi82tEnruI9pdCN0eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pObd4ibUBjfGFIpfCXbgDpGxS72rSIJEcwoGZ4nqE2nNCM1iUby+nGFdrPvhdGfQM
	 4N9JBXkV5laLYlbFtM/f3VMKdPZ4o1BTjdf1GZuSbiUzLGcDWVBOq9JsS4bzD/6UBe
	 dV5J9NWSB6sRwNRoQB/X7Y/nb/CEoXwsjcHNiZfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9f9d646b08f3b6032fe@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>
Subject: [PATCH 5.10 017/798] usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065517.355555481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1358,19 +1358,25 @@ static struct se_portal_group *usbg_make
 
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
@@ -1396,7 +1402,6 @@ static struct se_portal_group *usbg_make
 
 	tpg_instances[i].tpg = tpg;
 	tpg->fi = tpg_instances[i].func_inst;
-	mutex_unlock(&opts->dep_lock);
 	mutex_unlock(&tpg_instances_lock);
 	return &tpg->se_tpg;
 
@@ -1409,8 +1414,6 @@ unref_dep:
 		module_put(opts->dependent);
 	else
 		configfs_undepend_item_unlocked(&opts->func_inst.group.cg_item);
-unlock_dep:
-	mutex_unlock(&opts->dep_lock);
 unlock_inst:
 	mutex_unlock(&tpg_instances_lock);
 
@@ -2368,9 +2371,7 @@ static int tcm_set_name(struct usb_funct
 
 	pr_debug("tcm: Activating %s\n", name);
 
-	mutex_lock(&opts->dep_lock);
-	opts->ready = true;
-	mutex_unlock(&opts->dep_lock);
+	WRITE_ONCE(opts->ready, true);
 
 	return 0;
 }


