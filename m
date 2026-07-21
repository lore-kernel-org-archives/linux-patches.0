Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8503B47DF;
	Tue, 21 Jul 2026 21:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669445; cv=none; b=jr0cUApYZnEs+vDghlhDUhoS7NP2X69K1+jVR4kctm2Jag92y6Hc6YYKHO22lKDqpSCk75neHktHYkhimD2R1MB4rCESfTqFsorGr5Utu3/mDEYxVbJh8AZwwRXYrmyO5jTpkwsdhs2dKA0rersRHYVeMehswOUNBK1GhBNoNW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669445; c=relaxed/simple;
	bh=tIZPxr9SU7c+8fMwmfVYao45pnhQZQqu6tOILiMclfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELI3F1KPIGtG3Sdb2WGH3gU6axS4pP/Qcpt6Y+CG5kySgg0fEAdwok0F8M/K6fhSzFOsSTSJvl6FJmoWUcXJy2+48n30i4V7pxqD6+wUF6w5CeTiBNxqqRzk5L2OuArhQJ7SLX0XndqTRdVPndvUWOLicFe92DQx26een36yB+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/j2N0VO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/j2N0VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEDE1F00A3A;
	Tue, 21 Jul 2026 21:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669443;
	bh=y+U8EvZPOZF9MkGjidDLkdfjrU6w1VXz+EBXV8re7JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/j2N0VObrkxVynKFidUlt3b78j3svdTW8YT+AO++9IZA9YQfmOwkUBHjwVgW8bhw
	 44SNGVbk7sIjrMj6cvya7ICNZG0FN6LFNgTFuDN8BkmpB7v9uaOUN2AJ8elBPyTRBz
	 e3Kl6bIMAUlPY1o1QIosrnp8xkxl/kq0dYKLO3OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0555/1067] apparmor: grab ns lock and refresh when looking up changehat child profiles
Date: Tue, 21 Jul 2026 17:19:16 +0200
Message-ID: <20260721152437.023029060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b4fa5abd60667c..a6308d103f7649 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/mutex.h>
 #include <linux/syscalls.h>
 #include <linux/personality.h>
 #include <linux/xattr.h>
@@ -1036,6 +1037,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				   int count, int flags)
 {
 	struct aa_profile *profile, *root, *hat = NULL;
+	struct aa_ns *ns, *new_ns;
 	struct aa_label *new;
 	struct label_it it;
 	bool sibling = false;
@@ -1046,6 +1048,32 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
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
 
@@ -1054,7 +1082,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		name = hats[i];
 		label_for_each_in_ns(it, labels_ns(label), label, profile) {
 			if (sibling && PROFILE_IS_HAT(profile)) {
-				root = aa_get_profile_rcu(&profile->parent);
+				root = aa_get_profile(profile->parent);
 			} else if (!sibling && !PROFILE_IS_HAT(profile)) {
 				root = aa_get_profile(profile);
 			} else {	/* conflicting change type */
@@ -1113,6 +1141,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				      GLOBAL_ROOT_UID, info, error);
 		}
 	}
+	mutex_unlock(&ns->lock);
 	return ERR_PTR(error);
 
 build:
@@ -1124,7 +1153,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		error = -ENOMEM;
 		goto fail;
 	} /* else if (IS_ERR) build_change_hat has logged error so return new */
-
+	mutex_unlock(&ns->lock);
 	return new;
 }
 
-- 
2.53.0



