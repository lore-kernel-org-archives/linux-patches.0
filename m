Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E922924EA81;
	Mon, 23 Jun 2025 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684168; cv=none; b=pGuCnpF3Vy3eGGSQNhaEEq6HErB4cpkUpqCO5T6BmblMKduM+ATRveu1YamaLdMio/6xa4GzdYYWX8AtlbNU/Qs5P2iJsO4x05Dc/71Pi+P0tBasbUaodSGvK5p5I2EK4aX11BQUaC6WSEeZajdb1rkWAfxDt99+NCpJm1JPGjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684168; c=relaxed/simple;
	bh=eCKlJEHcMNlRwddJoXNdIgBuJoqiBqeJ94nr5xwVIIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs+ZQbIlLawETBRc5EFwA9XCFSuFfOLxMtcVrWNGchTcWughAMLgXiHsCuJPB9ZGoGKdnd7L4Yxw+d95d2og6RME6kITo6yaMncPd+CMoZDvYx1FSeebTpWodohZCV7Jdb5JXjx6IzQzPQW5o4JTmDzNOF/x9AdP5ejoNM2z9gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw5IKBlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw5IKBlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF7C4CEEA;
	Mon, 23 Jun 2025 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684167;
	bh=eCKlJEHcMNlRwddJoXNdIgBuJoqiBqeJ94nr5xwVIIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw5IKBlIt/EcVnsw+2Q+fd7+/sioxhBtXI49/e/IwzuQ/bKOn473K8yOrexxMiGL3
	 St1pdggqGqshfhDAFvL/oPT29JW60O7ZI+Z+1TRpKJRA7+nSyIiXp8wyg5vuoSARCH
	 ExWBzw4uOSqnarOcN0oKcOW/RvRx50SG5mGBROmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Casey Chen <cachen@purestorage.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	David Wang <00107082@163.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 001/592] alloc_tag: handle module codetag load errors as module load failures
Date: Mon, 23 Jun 2025 14:59:19 +0200
Message-ID: <20250623130700.252293579@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 044d2aee6c575231ed4a24fb3d119bad0937488b upstream.

Failures inside codetag_load_module() are currently ignored.  As a result
an error there would not cause a module load failure and freeing of the
associated resources.  Correct this behavior by propagating the error code
to the caller and handling possible errors.  With this change, error to
allocate percpu counters, which happens at this stage, will not be ignored
and will cause a module load failure and freeing of resources.  With this
change we also do not need to disable memory allocation profiling when
this error happens, instead we fail to load the module.

Link: https://lkml.kernel.org/r/20250521160602.1940771-1-surenb@google.com
Fixes: 10075262888b ("alloc_tag: allocate percpu counters for module tags dynamically")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Casey Chen <cachen@purestorage.com>
Closes: https://lore.kernel.org/all/20250520231620.15259-1-cachen@purestorage.com/
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/codetag.h |    8 ++++----
 kernel/module/main.c    |    5 +++--
 lib/alloc_tag.c         |   12 +++++++-----
 lib/codetag.c           |   34 +++++++++++++++++++++++++---------
 4 files changed, 39 insertions(+), 20 deletions(-)

--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -36,8 +36,8 @@ union codetag_ref {
 struct codetag_type_desc {
 	const char *section;
 	size_t tag_size;
-	void (*module_load)(struct module *mod,
-			    struct codetag *start, struct codetag *end);
+	int (*module_load)(struct module *mod,
+			   struct codetag *start, struct codetag *end);
 	void (*module_unload)(struct module *mod,
 			      struct codetag *start, struct codetag *end);
 #ifdef CONFIG_MODULES
@@ -89,7 +89,7 @@ void *codetag_alloc_module_section(struc
 				   unsigned long align);
 void codetag_free_module_sections(struct module *mod);
 void codetag_module_replaced(struct module *mod, struct module *new_mod);
-void codetag_load_module(struct module *mod);
+int codetag_load_module(struct module *mod);
 void codetag_unload_module(struct module *mod);
 
 #else /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
@@ -103,7 +103,7 @@ codetag_alloc_module_section(struct modu
 			     unsigned long align) { return NULL; }
 static inline void codetag_free_module_sections(struct module *mod) {}
 static inline void codetag_module_replaced(struct module *mod, struct module *new_mod) {}
-static inline void codetag_load_module(struct module *mod) {}
+static inline int codetag_load_module(struct module *mod) { return 0; }
 static inline void codetag_unload_module(struct module *mod) {}
 
 #endif /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3399,11 +3399,12 @@ static int load_module(struct load_info
 			goto sysfs_cleanup;
 	}
 
+	if (codetag_load_module(mod))
+		goto sysfs_cleanup;
+
 	/* Get rid of temporary copy. */
 	free_copy(info, flags);
 
-	codetag_load_module(mod);
-
 	/* Done! */
 	trace_module_load(mod);
 
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -618,15 +618,16 @@ out:
 	mas_unlock(&mas);
 }
 
-static void load_module(struct module *mod, struct codetag *start, struct codetag *stop)
+static int load_module(struct module *mod, struct codetag *start, struct codetag *stop)
 {
 	/* Allocate module alloc_tag percpu counters */
 	struct alloc_tag *start_tag;
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
-		return;
+		return 0;
 
 	start_tag = ct_to_alloc_tag(start);
 	stop_tag = ct_to_alloc_tag(stop);
@@ -638,12 +639,13 @@ static void load_module(struct module *m
 				free_percpu(tag->counters);
 				tag->counters = NULL;
 			}
-			shutdown_mem_profiling(true);
-			pr_err("Failed to allocate memory for allocation tag percpu counters in the module %s. Memory allocation profiling is disabled!\n",
+			pr_err("Failed to allocate memory for allocation tag percpu counters in the module %s\n",
 			       mod->name);
-			break;
+			return -ENOMEM;
 		}
 	}
+
+	return 0;
 }
 
 static void replace_module(struct module *mod, struct module *new_mod)
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -167,6 +167,7 @@ static int codetag_module_init(struct co
 {
 	struct codetag_range range;
 	struct codetag_module *cmod;
+	int mod_id;
 	int err;
 
 	range = get_section_range(mod, cttype->desc.section);
@@ -190,11 +191,20 @@ static int codetag_module_init(struct co
 	cmod->range = range;
 
 	down_write(&cttype->mod_lock);
-	err = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
-	if (err >= 0) {
-		cttype->count += range_size(cttype, &range);
-		if (cttype->desc.module_load)
-			cttype->desc.module_load(mod, range.start, range.stop);
+	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
+	if (mod_id >= 0) {
+		if (cttype->desc.module_load) {
+			err = cttype->desc.module_load(mod, range.start, range.stop);
+			if (!err)
+				cttype->count += range_size(cttype, &range);
+			else
+				idr_remove(&cttype->mod_idr, mod_id);
+		} else {
+			cttype->count += range_size(cttype, &range);
+			err = 0;
+		}
+	} else {
+		err = mod_id;
 	}
 	up_write(&cttype->mod_lock);
 
@@ -295,17 +305,23 @@ void codetag_module_replaced(struct modu
 	mutex_unlock(&codetag_lock);
 }
 
-void codetag_load_module(struct module *mod)
+int codetag_load_module(struct module *mod)
 {
 	struct codetag_type *cttype;
+	int ret = 0;
 
 	if (!mod)
-		return;
+		return 0;
 
 	mutex_lock(&codetag_lock);
-	list_for_each_entry(cttype, &codetag_types, link)
-		codetag_module_init(cttype, mod);
+	list_for_each_entry(cttype, &codetag_types, link) {
+		ret = codetag_module_init(cttype, mod);
+		if (ret)
+			break;
+	}
 	mutex_unlock(&codetag_lock);
+
+	return ret;
 }
 
 void codetag_unload_module(struct module *mod)


