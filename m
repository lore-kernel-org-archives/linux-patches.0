Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA2276C9C;
	Tue, 20 Feb 2024 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463685; cv=none; b=T8sPP373YBUnzIHokK2ckoda1xkUl/LfX/QRkBGhuMgBxo+IEhB43Q0k6D721rM5w0Tm7gVST7jjQk4PbpJNAN21Omtj3mQJ66saWrG0ScSEZBHbOx3eLAOi54RLlU0B3YFgptjb+1lAk7K40tEJNK6Qded1CI2ZTlbzFgbVLcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463685; c=relaxed/simple;
	bh=QOeoZs1MW9HzUymSFi+a3ZeKX4hC2+TLa9g6TkyBZ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9V0c5TkPum6QG+7BN2w6VY2lw8LZPkbI0jgmjQXWBhHDyzuhMQOqrWzsY7knevCWW5snnr1uLqcmLVZS4WXkz/xyXBYEgvAtJg/TU1dODhtKfKKWroWpOIT/VbyjdCxqqkfPUoInTvnbiaJ6PEcF0/SjyuHosKFHpvCa1icEC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ5KP+9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ5KP+9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF488C433C7;
	Tue, 20 Feb 2024 21:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463685;
	bh=QOeoZs1MW9HzUymSFi+a3ZeKX4hC2+TLa9g6TkyBZ+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ5KP+9Q0fFd/lTMiEnHw5U9pXjhJwfYvGooob35Bh8TuqyyMJp67KIRyZJ/AKZMl
	 7CQn+Uu7bUDrD//7UPKnci0x1/JBrttOklv3MXmYa2UjUt44qfTkGfYIzOZ/I+SHx6
	 6GvTy1dZ0sJq0SDOHpVjFfXqiXeGoNJEvxSaWKAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/331] Revert "kobject: Remove redundant checks for whether ktype is NULL"
Date: Tue, 20 Feb 2024 21:53:28 +0100
Message-ID: <20240220205640.474362096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



