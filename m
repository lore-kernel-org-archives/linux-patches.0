Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEAF652
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 05:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TU8tmoj4+nC9iaV5IMo+u+NGjzkEv9TSC0uMqT3ZueI=; b=EyOGTA5xTDzDcGr8GSBjkFLAN8
	nGjkRQkjVZyZ1K+MuXZXYknzkVx1pGnFe94XPuHo4pX/P+jISL8mSC74ra5XSjl1AhLiUBcKp5fHv
	HTH3BHIqG/QCcwQsDxY47l8GSa8CI27vezXz4S8W5/UNxP1wlFF10VEDXPBlEczhj4nWzdiZLjwjX
	7y3fYrCRccB7AfukcLW8wj8KzNE4sFjwAO8RmmNXBw3hKI83KBPOegRJadxHY8gH3WWgOCCElc0zS
	AVLGLYqIZAsNBXE0Lnh18BuIo2GpcXFQIA723+MLHAFr/MYvdVp4KTBPRmb7fTKZtEPos+zmyZheG
	vngAaacw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pnBfp-008KKL-23;
	Fri, 14 Apr 2023 05:08:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: david@redhat.com,
	patches@lists.linux.dev,
	linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pmladek@suse.com,
	petr.pavlu@suse.com,
	prarit@redhat.com,
	torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org
Cc: christophe.leroy@csgroup.eu,
	tglx@linutronix.de,
	peterz@infradead.org,
	song@kernel.org,
	rppt@kernel.org,
	dave@stgolabs.net,
	willy@infradead.org,
	vbabka@suse.cz,
	mhocko@suse.com,
	dave.hansen@linux.intel.com,
	colin.i.king@gmail.com,
	jim.cromie@gmail.com,
	catalin.marinas@arm.com,
	jbaron@akamai.com,
	rick.p.edgecombe@intel.com,
	mcgrof@kernel.org
Subject: [PATCH v3 2/4] module: extract patient module check into helper
Date: Thu, 13 Apr 2023 22:08:34 -0700
Message-Id: <20230414050836.1984746-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230414050836.1984746-1-mcgrof@kernel.org>
References: <20230414050836.1984746-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

The patient module check inside add_unformed_module() is large
enough as we need it. It is a bit hard to read too, so just
move it to a helper and do the inverse checks first to help
shift the code and make it easier to read. The new helper then
is module_patient_check_exists().

To make this work we need to mvoe the finished_loading() up,
we do that without making any functional changes to that routine.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 kernel/module/main.c | 112 +++++++++++++++++++++++--------------------
 1 file changed, 60 insertions(+), 52 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 32554d8a5791..75b23257128d 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2447,27 +2447,6 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
-/* Is this module of this name done loading?  No locks held. */
-static bool finished_loading(const char *name)
-{
-	struct module *mod;
-	bool ret;
-
-	/*
-	 * The module_mutex should not be a heavily contended lock;
-	 * if we get the occasional sleep here, we'll go an extra iteration
-	 * in the wait_event_interruptible(), which is harmless.
-	 */
-	sched_annotate_sleep();
-	mutex_lock(&module_mutex);
-	mod = find_module_all(name, strlen(name), true);
-	ret = !mod || mod->state == MODULE_STATE_LIVE
-		|| mod->state == MODULE_STATE_GOING;
-	mutex_unlock(&module_mutex);
-
-	return ret;
-}
-
 /* Call module constructors. */
 static void do_mod_ctors(struct module *mod)
 {
@@ -2631,6 +2610,63 @@ static int may_init_module(void)
 	return 0;
 }
 
+/* Is this module of this name done loading?  No locks held. */
+static bool finished_loading(const char *name)
+{
+	struct module *mod;
+	bool ret;
+
+	/*
+	 * The module_mutex should not be a heavily contended lock;
+	 * if we get the occasional sleep here, we'll go an extra iteration
+	 * in the wait_event_interruptible(), which is harmless.
+	 */
+	sched_annotate_sleep();
+	mutex_lock(&module_mutex);
+	mod = find_module_all(name, strlen(name), true);
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
+	mutex_unlock(&module_mutex);
+
+	return ret;
+}
+
+/* Must be called with module_mutex held */
+static int module_patient_check_exists(const char *name)
+{
+	struct module *old;
+	int err = 0;
+
+	old = find_module_all(name, strlen(name), true);
+	if (old == NULL)
+		return 0;
+
+	if (old->state == MODULE_STATE_COMING ||
+	    old->state == MODULE_STATE_UNFORMED) {
+		/* Wait in case it fails to load. */
+		mutex_unlock(&module_mutex);
+		err = wait_event_interruptible(module_wq,
+				       finished_loading(name));
+		mutex_lock(&module_mutex);
+		if (err)
+			return err;
+
+		/* The module might have gone in the meantime. */
+		old = find_module_all(name, strlen(name), true);
+	}
+
+	/*
+	 * We are here only when the same module was being loaded. Do
+	 * not try to load it again right now. It prevents long delays
+	 * caused by serialized module load failures. It might happen
+	 * when more devices of the same type trigger load of
+	 * a particular module.
+	 */
+	if (old && old->state == MODULE_STATE_LIVE)
+		return -EEXIST;
+	return -EBUSY;
+}
+
 /*
  * We try to place it in the list now to make sure it's unique before
  * we dedicate too many resources.  In particular, temporary percpu
@@ -2639,41 +2675,14 @@ static int may_init_module(void)
 static int add_unformed_module(struct module *mod)
 {
 	int err;
-	struct module *old;
 
 	mod->state = MODULE_STATE_UNFORMED;
 
 	mutex_lock(&module_mutex);
-	old = find_module_all(mod->name, strlen(mod->name), true);
-	if (old != NULL) {
-		if (old->state == MODULE_STATE_COMING
-		    || old->state == MODULE_STATE_UNFORMED) {
-			/* Wait in case it fails to load. */
-			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
-			if (err)
-				goto out_unlocked;
-
-			/* The module might have gone in the meantime. */
-			mutex_lock(&module_mutex);
-			old = find_module_all(mod->name, strlen(mod->name),
-					      true);
-		}
-
-		/*
-		 * We are here only when the same module was being loaded. Do
-		 * not try to load it again right now. It prevents long delays
-		 * caused by serialized module load failures. It might happen
-		 * when more devices of the same type trigger load of
-		 * a particular module.
-		 */
-		if (old && old->state == MODULE_STATE_LIVE)
-			err = -EEXIST;
-		else
-			err = -EBUSY;
+	err = module_patient_check_exists(mod->name);
+	if (err)
 		goto out;
-	}
+
 	mod_update_bounds(mod);
 	list_add_rcu(&mod->list, &modules);
 	mod_tree_insert(mod);
@@ -2681,7 +2690,6 @@ static int add_unformed_module(struct module *mod)
 
 out:
 	mutex_unlock(&module_mutex);
-out_unlocked:
 	return err;
 }
 
-- 
2.39.2

