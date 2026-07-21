Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14D51F03D9;
	Tue, 21 Jul 2026 22:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673870; cv=none; b=o7haA6RpM6hTic7iiVSsdnystEaMfjXvjK+vBjazB/wqf27nRhTmPgEXUmDXsHzTBeAajIetf9GrXRMbrHEgQMdfjeNbmLtS68RH/Zy97n/46VF7oEJUR5a10sYw6Gw1NGgUzEEMn/fmOc6Sx0vi+OOeMRkL5KVoK+bfKURGYVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673870; c=relaxed/simple;
	bh=srQ4W8gIZaF79bkWGziqLLj3/2hehZNesSgITNRMv2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz9OU6evzKXczOfknlbvhlcNRp1Xi7/zUYZPpWFK0Ute2Oqt/DJok49TyabRIAXy8HxkN1blIwQeayyL5Tc0QiiTFEf8lJpl8kqJO+/xZWL2v19L3LKE/ihmlFX8Ir1ueTDDiK1RCWyFJSgySxQXgv4pAUZlBkJGS9o6gQxmm7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrEVh+dF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrEVh+dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D551F000E9;
	Tue, 21 Jul 2026 22:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673869;
	bh=SVo05/bDkyjGYbNZWFz0NZGi8cAhL80gPVxUyYRN7PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrEVh+dFYtMvF6wjsj6MyoikyYYcFHGl2sR7VngJ0z3K1VUwWJu5y5uHJcVPcqrlI
	 jC5t5T5RbN9ow6zBjU7cj2+oR+1xQMcSt22ofsNobRKbwu5VBufsHTpP3M+AZy/Akx
	 AEY+H2QINA8dXb/6PKAsp6Ll28o+4qrg3IHMGZfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 327/699] apparmor: grab ns lock and refresh when looking up changehat child profiles
Date: Tue, 21 Jul 2026 17:21:26 +0200
Message-ID: <20260721152403.066535376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
index f7bf0ebc00cb8c..4a7891ffe86b91 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -12,6 +12,7 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/mount.h>
+#include <linux/mutex.h>
 #include <linux/syscalls.h>
 #include <linux/tracehook.h>
 #include <linux/personality.h>
@@ -1034,6 +1035,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				   int count, int flags)
 {
 	struct aa_profile *profile, *root, *hat = NULL;
+	struct aa_ns *ns, *new_ns;
 	struct aa_label *new;
 	struct label_it it;
 	bool sibling = false;
@@ -1044,6 +1046,32 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
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
 
@@ -1052,7 +1080,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		name = hats[i];
 		label_for_each_in_ns(it, labels_ns(label), label, profile) {
 			if (sibling && PROFILE_IS_HAT(profile)) {
-				root = aa_get_profile_rcu(&profile->parent);
+				root = aa_get_profile(profile->parent);
 			} else if (!sibling && !PROFILE_IS_HAT(profile)) {
 				root = aa_get_profile(profile);
 			} else {	/* conflicting change type */
@@ -1111,6 +1139,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 				      GLOBAL_ROOT_UID, info, error);
 		}
 	}
+	mutex_unlock(&ns->lock);
 	return ERR_PTR(error);
 
 build:
@@ -1122,7 +1151,7 @@ static struct aa_label *change_hat(struct aa_label *label, const char *hats[],
 		error = -ENOMEM;
 		goto fail;
 	} /* else if (IS_ERR) build_change_hat has logged error so return new */
-
+	mutex_unlock(&ns->lock);
 	return new;
 }
 
-- 
2.53.0



