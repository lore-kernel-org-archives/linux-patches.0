Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5072E47CA63;
	Sat, 12 Sep 2026 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219738; cv=none; b=Z5NRH79zAAW4Jj+9z3gmEL6Hw2dsLg26OqEU1Xk8gnEuFnFnZKNjcSh+og/N7+uuKSlkRJ/U0eOc2cfzTdDrePGurgTMs5n/GFDAXoq1CpNfDJCtcJYyEmfsyBTgya3R+hsHfCSZKZ0g7aTKB2vHmPdh8WGyyUjzsept1GCZKvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219738; c=relaxed/simple;
	bh=evoNld+ttuzYBsCarZVyaWsl8+cMyRVjRp749lxaMsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClO4ZJxusqTPrjFIv0PRloo2sbHAWmn2fcvrQDCa2bSsrQazdMvSxhIiOwvAmY81+SFz38N/NCBExD1/RYGaz77cLwr62tRudnbCnp6onPIDV2gbgn5T2vUwitUhELxLiAh34C0joPQuYO14aq60M2mzzQ6uwDiOhDXUJ66h8kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFKEkxWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFKEkxWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E13F1F000FF;
	Sat, 12 Sep 2026 13:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219736;
	bh=NnRVe8RWxgnwaTpd/dJtVI3oVYL86nA6UWVegJSD5xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFKEkxWQgCRJINmbVe64n26BSMO9s5rIswMn6EvF7jK1tuGTU29c+YGmP2U4Osy3F
	 IGNA74+TWM6QKKJTQ/aDjGy4TBeCLimr1kXKl2CaD5vLwpTfnyjvYeyP/YPaBprxqW
	 xVJe+HdPOhj78ucLVZ9LFSGBl6p2DhLEKz+8uKMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c9f9d646b08f3b6032fe@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>
Subject: [PATCH 6.6 0035/1424] usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()
Date: Sat, 12 Sep 2026 08:41:07 +0200
Message-ID: <20260912065608.091910243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -2314,9 +2317,7 @@ static int tcm_set_name(struct usb_funct
 
 	pr_debug("tcm: Activating %s\n", name);
 
-	mutex_lock(&opts->dep_lock);
-	opts->ready = true;
-	mutex_unlock(&opts->dep_lock);
+	WRITE_ONCE(opts->ready, true);
 
 	return 0;
 }


