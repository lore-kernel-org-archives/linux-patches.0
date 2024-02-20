Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01E714A4D2;
	Tue, 20 Feb 2024 21:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464677; cv=none; b=tx6BjOIj0P8SPD8qemnGvAPa+5GVRQb5jnzzIgEs1VMHx51bODA33mNOQb9Pn0LAcGPnW5BtewYtK4qIxNW4aJpAtgPgAomcMubsEZ0paO9qR4Fhv0vbOglv6sZu4OPxxrFJhXGvHEegSU1OMuDX7S2s2LByAJ9nAKznqF0iT4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464677; c=relaxed/simple;
	bh=caLlnc0InqbQymxx8j9qtzuc0Np/anM6sLAB0Odpg1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWETKs2yuyeLEvVMgDI8rQ/aLGU04AbRHivZJ3ppl5TPZ5h0Au70+7ZwccDhwx0fohunbn1T0q2hYM+maUPJbMw2an6ekR4iQ0FIxe6SDrvzTjOnTVQyAmCg7ODL0ECw2wTlaxVWnoGMQe5zGNbbHg7JZaEoY31fmO/1pjLbmsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfhHFoHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfhHFoHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEC4C433F1;
	Tue, 20 Feb 2024 21:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464677;
	bh=caLlnc0InqbQymxx8j9qtzuc0Np/anM6sLAB0Odpg1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfhHFoHO4mhO/A7xavIZdWiiXEJAUsbnkXlbLrXwsz7VtHa7MUTpHBy0mdNGo0FcC
	 QxqTDmIDnl+wcc5QzPYmAEymluZI+8ZyzWeWiBZ9g7Wg5qy0ZKih/skLvvn3mxPifZ
	 Ntw+/YENkdnhMNT7i/2VF6Tbbdq45exvMSc8aBGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 102/309] Revert "kobject: Remove redundant checks for whether ktype is NULL"
Date: Tue, 20 Feb 2024 21:54:21 +0100
Message-ID: <20240220205636.371109845@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 3ca8fbabcceb8bfe44f7f50640092fd8f1de375c ]

This reverts commit 1b28cb81dab7c1eedc6034206f4e8d644046ad31.

It is reported to cause problems, so revert it for now until the root
cause can be found.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 1b28cb81dab7 ("kobject: Remove redundant checks for whether ktype is NULL")
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Closes: https://lore.kernel.org/oe-lkp/202402071403.e302e33a-oliver.sang@intel.com
Link: https://lore.kernel.org/r/2024020849-consensus-length-6264@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 59dbcbdb1c91..72fa20f405f1 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -74,10 +74,12 @@ static int create_dir(struct kobject *kobj)
 	if (error)
 		return error;
 
-	error = sysfs_create_groups(kobj, ktype->default_groups);
-	if (error) {
-		sysfs_remove_dir(kobj);
-		return error;
+	if (ktype) {
+		error = sysfs_create_groups(kobj, ktype->default_groups);
+		if (error) {
+			sysfs_remove_dir(kobj);
+			return error;
+		}
 	}
 
 	/*
@@ -589,7 +591,8 @@ static void __kobject_del(struct kobject *kobj)
 	sd = kobj->sd;
 	ktype = get_ktype(kobj);
 
-	sysfs_remove_groups(kobj, ktype->default_groups);
+	if (ktype)
+		sysfs_remove_groups(kobj, ktype->default_groups);
 
 	/* send "remove" if the caller did not do it but sent "add" */
 	if (kobj->state_add_uevent_sent && !kobj->state_remove_uevent_sent) {
@@ -666,6 +669,10 @@ static void kobject_cleanup(struct kobject *kobj)
 	pr_debug("'%s' (%p): %s, parent %p\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 
+	if (t && !t->release)
+		pr_debug("'%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/core-api/kobject.rst.\n",
+			 kobject_name(kobj), kobj);
+
 	/* remove from sysfs if the caller did not do it */
 	if (kobj->state_in_sysfs) {
 		pr_debug("'%s' (%p): auto cleanup kobject_del\n",
@@ -676,13 +683,10 @@ static void kobject_cleanup(struct kobject *kobj)
 		parent = NULL;
 	}
 
-	if (t->release) {
+	if (t && t->release) {
 		pr_debug("'%s' (%p): calling ktype release\n",
 			 kobject_name(kobj), kobj);
 		t->release(kobj);
-	} else {
-		pr_debug("'%s' (%p): does not have a release() function, it is broken and must be fixed. See Documentation/core-api/kobject.rst.\n",
-			 kobject_name(kobj), kobj);
 	}
 
 	/* free name if we allocated it */
@@ -1056,7 +1060,7 @@ const struct kobj_ns_type_operations *kobj_child_ns_ops(const struct kobject *pa
 {
 	const struct kobj_ns_type_operations *ops = NULL;
 
-	if (parent && parent->ktype->child_ns_type)
+	if (parent && parent->ktype && parent->ktype->child_ns_type)
 		ops = parent->ktype->child_ns_type(parent);
 
 	return ops;
-- 
2.43.0



