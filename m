Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B136FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C63C433EF;
	Mon, 16 Jan 2023 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889195;
	bh=X+aIeeyOZRTXkdQjBjP7gZxVZxF36QCcdUOwCfvRBdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dS5HOZNLUGlRkzqE2C8tQiUvwPI5h2tw6d6rwM4l+RhtWR4nbDc2zZZcv97WEYRaS
	 mWAccNk52ZNVlpbsVx5KGdVfBFyZAMvHdKCtQKIojtAKEdnLebiAHyUszEm2JZGdaT
	 j9U/0qsLhmgDNG3GMJN5uycd9hXnxYpdxdgiaUf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Weiyang <wangweiyang2@huawei.com>,
	Aristeu Rozanski <aris@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.14 294/338] device_cgroup: Roll back to original exceptions after copy failure
Date: Mon, 16 Jan 2023 16:52:47 +0100
Message-Id: <20230116154833.909924056@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Weiyang <wangweiyang2@huawei.com>

commit e68bfbd3b3c3a0ec3cf8c230996ad8cabe90322f upstream.

When add the 'a *:* rwm' entry to devcgroup A's whitelist, at first A's
exceptions will be cleaned and A's behavior is changed to
DEVCG_DEFAULT_ALLOW. Then parent's exceptions will be copyed to A's
whitelist. If copy failure occurs, just return leaving A to grant
permissions to all devices. And A may grant more permissions than
parent.

Backup A's whitelist and recover original exceptions after copy
failure.

Cc: stable@vger.kernel.org
Fixes: 4cef7299b478 ("device_cgroup: add proper checking when changing default behavior")
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Reviewed-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/device_cgroup.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -88,6 +88,17 @@ free_and_exit:
 	return -ENOMEM;
 }
 
+static void dev_exceptions_move(struct list_head *dest, struct list_head *orig)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	lockdep_assert_held(&devcgroup_mutex);
+
+	list_for_each_entry_safe(ex, tmp, orig, list) {
+		list_move_tail(&ex->list, dest);
+	}
+}
+
 /*
  * called under devcgroup_mutex
  */
@@ -609,11 +620,13 @@ static int devcgroup_update_access(struc
 	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
+	struct dev_cgroup tmp_devcgrp;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	memset(&ex, 0, sizeof(ex));
+	memset(&tmp_devcgrp, 0, sizeof(tmp_devcgrp));
 	b = buffer;
 
 	switch (*b) {
@@ -625,15 +638,27 @@ static int devcgroup_update_access(struc
 
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
-			if (!parent)
+			if (!parent) {
+				devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+				dev_exception_clean(devcgroup);
 				break;
+			}
 
+			INIT_LIST_HEAD(&tmp_devcgrp.exceptions);
+			rc = dev_exceptions_copy(&tmp_devcgrp.exceptions,
+						 &devcgroup->exceptions);
+			if (rc)
+				return rc;
+			dev_exception_clean(devcgroup);
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
-			if (rc)
+			if (rc) {
+				dev_exceptions_move(&devcgroup->exceptions,
+						    &tmp_devcgrp.exceptions);
 				return rc;
+			}
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			dev_exception_clean(&tmp_devcgrp);
 			break;
 		case DEVCG_DENY:
 			if (css_has_online_children(&devcgroup->css))


