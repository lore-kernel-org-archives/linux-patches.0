Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3A7449B1C;
	Tue, 21 Jul 2026 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662701; cv=none; b=uRwjef5Sv2Bsfn/oBPRqjlkN4i4TSlzoQo6X5j7hlBOssB9wk2taEF7gZhuG9TGPsPpxXRYVF0HcHKyXxRjgQYrbu96POVU+HuViUpBI8h6LHm9EC8yyTElNm2eaqYzSnqxTXusOd2gcK+46CJzEyDW3CPc8+Y78yKmFBTGiocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662701; c=relaxed/simple;
	bh=cG3ZSVOa/ZL3CfeNOsDHNsYH/c39R0mlELht1ugy26A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1btM8qvJhU7SXzwcDblLKSl9+TTq4xdlXZVmI3pPnYuT2piq7FEyo8a6nayOOZbcCeN0v5rmypZbbcBhIaa8rhkkXTIz7AGLjDKfuupz1wptMu4lKRgW3A5zRlbXlcK926wUGqUq3VB6iuo8iL5icUoAml+in82EwEnh5HLbH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naHRE9gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naHRE9gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1891F00A3A;
	Tue, 21 Jul 2026 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662692;
	bh=M4t7BummvPap5Ac5ttGmSpe3eQlSYnbaA/Q5cSW11/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naHRE9grb4p3IvpW9wL+W2ZK5zith59YkOVrlKOfYQxpuTrsrP6fnbXom8QqOQB+O
	 g10vWg4cBHKd9yRby/b2urgHGHlr4EuB1TjXyznVA+jOTbYxbSJT1CWB6LEuvjTiiZ
	 LYHdZzXhP5kBozLtuBuGSo+K31j9vaQwXBegCKI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0540/1276] apparmor: grab ns lock and refresh when looking up changehat child profiles
Date: Tue, 21 Jul 2026 17:16:23 +0200
Message-ID: <20260721152458.206161588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 32e92764d6f8d251c1bca62be33793287b453a81 ]

There was a race condition involving change_hat and profile replacement in
which replacement of the parent profile during a changehat operation could
result in the list of children becoming empty and the changehat operation
failing. To prevent this:
 - grab the namespace lock until we've built the hat transition, and
 - use aa_get_newest_profile to avoid using stale profile objects.

Link: https://bugs.launchpad.net/bugs/2139664
Fixes: 89dbf1962aa63 ("apparmor: move change_hat mediation to using labels")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 3ae50f8675e23c..ced513197ed5e8 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/mutex.h>
 #include <linux/syscalls.h>
 #include <linux/personality.h>
 #include <linux/xattr.h>
@@ -1068,6 +1069,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 				   int count, int flags)
 {
 	struct aa_profile *profile, *root, *hat = NULL;
+	struct aa_ns *ns, *new_ns;
 	struct aa_label *new;
 	struct label_it it;
 	bool sibling = false;
@@ -1078,6 +1080,32 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 	AA_BUG(!hats);
 	AA_BUG(count < 1);
 
+	/*
+	 * Acquire the newest label and then hold the lock until we choose a
+	 * hat, so that profile replacement doesn't atomically truncate the
+	 * list of potential hats. Because we are getting the namespaces from
+	 * the profiles and label, we can rely on the namespaces being live
+	 * and avoid incrementing their refcounts while grabbing the lock.
+	 */
+	label = aa_get_label(label);
+	ns = labels_ns(label);
+
+retry:
+	mutex_lock_nested(&ns->lock, ns->level);
+	if (label_is_stale(label)) {
+		new = aa_get_newest_label(label);
+		new_ns = labels_ns(new);
+		if (new_ns != ns) {
+			aa_put_label(new);
+			mutex_unlock(&ns->lock);
+			ns = new_ns;
+			label = new;
+			goto retry;
+		}
+		aa_put_label(label);
+		label = new;
+	}
+
 	if (PROFILE_IS_HAT(labels_profile(label)))
 		sibling = true;
 
@@ -1086,7 +1114,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 		name = hats[i];
 		label_for_each_in_ns(it, labels_ns(label), label, profile) {
 			if (sibling && PROFILE_IS_HAT(profile)) {
-				root = aa_get_profile_rcu(&profile->parent);
+				root = aa_get_profile(profile->parent);
 			} else if (!sibling && !PROFILE_IS_HAT(profile)) {
 				root = aa_get_profile(profile);
 			} else {	/* conflicting change type */
@@ -1146,6 +1174,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 				      GLOBAL_ROOT_UID, info, error);
 		}
 	}
+	mutex_unlock(&ns->lock);
 	return ERR_PTR(error);
 
 build:
@@ -1158,7 +1187,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 		error = -ENOMEM;
 		goto fail;
 	} /* else if (IS_ERR) build_change_hat has logged error so return new */
-
+	mutex_unlock(&ns->lock);
 	return new;
 }
 
-- 
2.53.0



