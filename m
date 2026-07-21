Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C85F2D8376;
	Tue, 21 Jul 2026 20:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666481; cv=none; b=Y8m8LBXzckxFtPqxNZZk1yhzzLnUyL+JDjmc4pAvuI97bEmiGiakvkLTwHbq5GrRrwPSk0MRkHmB99shwAET57WI446V5FWqsqqFgw0n6QutergHzmWHoONiG3OZdl7qR7jiXXQUUubgEPAU2SW7Ah1PZBxsiu7E8YCYMfPyuoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666481; c=relaxed/simple;
	bh=2SzY/A+qldVhUSvM1gB90KaHi0ARcb58zOiTB8irQg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9xkpS4uJuYqyQEQx1So9UepAlG22YmB2bPUfox1A9qmlsISBEqWUjIep6Y7xkrBilGdZXs0dNxrO8HjXWOyzwKurKedtumZNa90c+2KDLin/77Kw3rMIwL+7s25wgAK/3b/E+wSmWDp1ShHzFK0RUsJgOR68Vi4UYB54c3xOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSsWImKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSsWImKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E0F1F000E9;
	Tue, 21 Jul 2026 20:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666480;
	bh=YTLMZTdMOKplQ1tungo2yltU+58xifXDtVgT01Nshh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSsWImKI1G0V+Oq0rTnBGe90WQ4t0EQTLadjFloTymxWzfXz7waLkGyoiqRSeuOHd
	 83U6wJyLiZPwT7ZifJI6BnhzvNHQkIYusrreyKtSei9/6iiIF+5VrnAdRW6aXSnv+k
	 wlvdbQy1gbE0ha/w5PZoJsuIUQBzW1mrXcpanZdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0700/1266] apparmor: grab ns lock and refresh when looking up changehat child profiles
Date: Tue, 21 Jul 2026 17:18:57 +0200
Message-ID: <20260721152457.524006162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 7162088629c531..f14f8a4e859461 100644
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
@@ -1061,6 +1062,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 				   int count, int flags)
 {
 	struct aa_profile *profile, *root, *hat = NULL;
+	struct aa_ns *ns, *new_ns;
 	struct aa_label *new;
 	struct label_it it;
 	bool sibling = false;
@@ -1071,6 +1073,32 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
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
 
@@ -1079,7 +1107,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 		name = hats[i];
 		label_for_each_in_ns(it, labels_ns(label), label, profile) {
 			if (sibling && PROFILE_IS_HAT(profile)) {
-				root = aa_get_profile_rcu(&profile->parent);
+				root = aa_get_profile(profile->parent);
 			} else if (!sibling && !PROFILE_IS_HAT(profile)) {
 				root = aa_get_profile(profile);
 			} else {	/* conflicting change type */
@@ -1139,6 +1167,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 				      GLOBAL_ROOT_UID, info, error);
 		}
 	}
+	mutex_unlock(&ns->lock);
 	return ERR_PTR(error);
 
 build:
@@ -1151,7 +1180,7 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 		error = -ENOMEM;
 		goto fail;
 	} /* else if (IS_ERR) build_change_hat has logged error so return new */
-
+	mutex_unlock(&ns->lock);
 	return new;
 }
 
-- 
2.53.0



