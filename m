Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91567340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301077; cv=none; b=L0F1i/9LSYpo2WLyP0rKMa/EZeDNUHuWHpnAZCGJzVI6iDDsvEoJq1am+BuMZMKMkl34d1v7ZrqK1B8Zegyr+UZ5h84Iuz1fdptAqb9Z+2lA+lz9gGepLMhR1T/mv32xzUBVx94Z2Dh5Zb02zfM9YyG3talJglcXvmRpxMmxTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301077; c=relaxed/simple;
	bh=cHUYixm8h1kdxcHkyLLsIHClUhF9li/px0bV+qqgbyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTbaJdZs96cxnfb1IR6qUb98jeZprcAVHjREHAlxZjynO0bI6ij0NE7EBhTVMi6PJ73IccyYeDWyXp27/6AWPoOWGvdcvis9xgzl4HTvM3liF5cWn8f1pJ2rmw/NNKbg4YpWOR9rw9vzoVtqR9NbEPLAdshDpBcZFLTifcemyR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYHYBfb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYHYBfb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EC5C116D0;
	Sat, 28 Feb 2026 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301077;
	bh=cHUYixm8h1kdxcHkyLLsIHClUhF9li/px0bV+qqgbyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DYHYBfb3AJCCTFRpBCV1rKFtEzSCVnuarc+MfhZqIkn5sWtJNMYU6WZkNq0SYqSsh
	 LIOnrfJHSPVwQijy0GfziJA1fSE6BzZgk/BMxgwh2g5ml6fKlb+cHf+Pio6hyBeWRn
	 b614OukvI9pGV5DoF793oEPnxxN1j0YB29It9/XS0e51kQ/Z8GYV8e23SwK9aLCae1
	 mc1nk6J+fpTUJ1eCYxB0ZW0uZMn372nOQAmF42rJZIyWNCyxUiMRFvg4WWZrjefUzK
	 2i6X30fdrkPNvvI4th/nL3q7SVRhoAu6GxC0lqXARvNtfbZgs85e0Ipxzv6ZfkLaT5
	 qoRyB7LGhfc0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Gomez <da.gomez@samsung.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/752] dm: replace -EEXIST with -EBUSY
Date: Sat, 28 Feb 2026 12:38:55 -0500
Message-ID: <20260228174750.1542406-224-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit b13ef361d47f09b7aecd18e0383ecc83ff61057e ]

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register().

Affected modules:
  * dm_cache dm_clone dm_integrity dm_mirror dm_multipath dm_pcache
  * dm_vdo dm-ps-round-robin dm_historical_service_time dm_io_affinity
  * dm_queue_length dm_service_time dm_snapshot

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-exception-store.c | 2 +-
 drivers/md/dm-log.c             | 2 +-
 drivers/md/dm-path-selector.c   | 2 +-
 drivers/md/dm-target.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index c3799757bf4a0..88f119a0a2ae0 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -116,7 +116,7 @@ int dm_exception_store_type_register(struct dm_exception_store_type *type)
 	if (!__find_exception_store_type(type->name))
 		list_add(&type->list, &_exception_store_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 9d85d045f9d9d..bced5a783ee33 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -121,7 +121,7 @@ int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 	if (!__find_dirty_log_type(type->name))
 		list_add(&type->list, &_log_types);
 	else
-		r = -EEXIST;
+		r = -EBUSY;
 	spin_unlock(&_lock);
 
 	return r;
diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index d0b883fabfeb6..2b0ac200f1c02 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -107,7 +107,7 @@ int dm_register_path_selector(struct path_selector_type *pst)
 
 	if (__find_path_selector_type(pst->name)) {
 		kfree(psi);
-		r = -EEXIST;
+		r = -EBUSY;
 	} else
 		list_add(&psi->list, &_path_selectors);
 
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 8fede41adec00..1fd41289de367 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -88,7 +88,7 @@ int dm_register_target(struct target_type *tt)
 	if (__find_target_type(tt->name)) {
 		DMERR("%s: '%s' target already registered",
 		      __func__, tt->name);
-		rv = -EEXIST;
+		rv = -EBUSY;
 	} else {
 		list_add(&tt->list, &_targets);
 	}
-- 
2.51.0

