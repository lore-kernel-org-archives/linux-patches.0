Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E5F3C0611;
	Tue, 21 Jul 2026 22:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671921; cv=none; b=pkuS8WkNB1VyUL8ypY+hKTBkwBIGXT8NOv9hqUzCrK/pF4nQGIIht9BSXNwpeAV9eII4fcs0S2VD4MzGLTO+swgNz6oRji5/pnKZBUgWHh7NLezAuXraP5aNwB7JEkMpHPociap9iqdvtHl8VgusL555lD8pgKkEOInj4+somAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671921; c=relaxed/simple;
	bh=E8a0Zc7eSEFXzBQTy+NK2998nv+gIubLRanr+jbGMeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkYASeiKQ7PE/vOHLsolxrzIvrP+/ZyKlWz3VdlRSFYiy01yG0YAAHP3j7uIReG3SuX7St9aVBX7adLqVkpaZ9dND4U+jR6glZdt2fqNFHT0FQj7FBooTs9K8hw+XGITxB4bzgfgBEYsCeH1v93bJRG1M9AHa+kY5b5u0ziyMDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5IZdCRT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5IZdCRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904431F000E9;
	Tue, 21 Jul 2026 22:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671920;
	bh=8t5RJM6TJcHWpyMWlQGP4g/W6pDXsEFOuFwcrZAX/1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5IZdCRT3KbX0xuEx5PVRNJkFmvNgdN0YSfw/2CmTuEYoglAYU5xR+ctRPcFZo6JG
	 DhOi4GHUeXdJrek5N6R5E82FRZH1DVQvSVJ7MgcpfE6XgAQKRSBScyQUuuJ57PmFaY
	 W43WWkO83z4uuJMpSxZaKRwHZ0xcX75g3q6Px5eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/843] apparmor: grab ns lock and refresh when looking up changehat child profiles
Date: Tue, 21 Jul 2026 17:21:04 +0200
Message-ID: <20260721152415.682661042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec262513aedffd..a861089bcb65c7 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/mutex.h>
 #include <linux/syscalls.h>
 #include <linux/tracehook.h>
 #include <linux/personality.h>
@@ -1037,6 +1038,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				   int count, int flags)
 {
 	struct aa_profile *profile, *root, *hat = NULL;
+	struct aa_ns *ns, *new_ns;
 	struct aa_label *new;
 	struct label_it it;
 	bool sibling = false;
@@ -1047,6 +1049,32 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
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
 
@@ -1055,7 +1083,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		name = hats[i];
 		label_for_each_in_ns(it, labels_ns(label), label, profile) {
 			if (sibling && PROFILE_IS_HAT(profile)) {
-				root = aa_get_profile_rcu(&profile->parent);
+				root = aa_get_profile(profile->parent);
 			} else if (!sibling && !PROFILE_IS_HAT(profile)) {
 				root = aa_get_profile(profile);
 			} else {	/* conflicting change type */
@@ -1114,6 +1142,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				      GLOBAL_ROOT_UID, info, error);
 		}
 	}
+	mutex_unlock(&ns->lock);
 	return ERR_PTR(error);
 
 build:
@@ -1125,7 +1154,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		error = -ENOMEM;
 		goto fail;
 	} /* else if (IS_ERR) build_change_hat has logged error so return new */
-
+	mutex_unlock(&ns->lock);
 	return new;
 }
 
-- 
2.53.0



