Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B8318C03F;
	Tue, 10 Sep 2024 09:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961388; cv=none; b=MUOuIvuDYM9W+f7uCkkHAPHYmRe9pZNJLjemZLkWHEdBA52ONyKAxmpQ6o4GYQ05Pz3TY31jnoVWtjiLvorrgrD4OtpQwoiQtPFhdpE87akvpry3Otm7SbOO4wsMn1IKU/TlKnaFIaNGXYPK995geoR5h3I+Q6SXPnk0u76J11k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961388; c=relaxed/simple;
	bh=uKV0yIsLEuKto7mecUXSpgmUSfNNFM7k3caxNFTqpZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRRtjzr0QWmSZxt3n9fGvy+YFmsMo2vjGWe32Tvz+J7pnJs5TIAZdW+RyLZR9j4ZvuszejnLrXlm9kV3sDVLjfL11L43A76Ny+QEIqTTg7BOGFHiYJnEAJg+GWaTsK1sbRuEzByjCkS0BTR69A7AlKiCdS9Vtpa5liMN6zsOROY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShIZK/qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShIZK/qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D78C4CEC3;
	Tue, 10 Sep 2024 09:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961388;
	bh=uKV0yIsLEuKto7mecUXSpgmUSfNNFM7k3caxNFTqpZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShIZK/qv+d36TW1WhVBj/8V+lrgpYQcjSAEtjw5t9UA04wwiIgNWtk6xlCS9Mo5VT
	 J3cVyFMmKwVVRdhz9r/GrJWQ4TgZKYsZ8ACoN7o8Di+4Vq3sR1JH1HEBTlSyNIvNlS
	 dHgJHrpKygaVjQpV+K0XYVs8esyc8xBFSdPc5zwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 054/375] alloc_tag: fix allocation tag reporting when CONFIG_MODULES=n
Date: Tue, 10 Sep 2024 11:27:31 +0200
Message-ID: <20240910092624.048866769@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 052a45c1cb1b32f05dd63a295d65496d8b403283 upstream.

codetag_module_init() is used to initialize sections containing allocation
tags.  This function is used to initialize module sections as well as core
kernel sections, in which case the module parameter is set to NULL.  This
function has to be called even when CONFIG_MODULES=n to initialize core
kernel allocation tag sections.  When CONFIG_MODULES=n, this function is a
NOP, which is wrong.  This leads to /proc/allocinfo reported as empty.
Fix this by making it independent of CONFIG_MODULES.

Link: https://lkml.kernel.org/r/20240828231536.1770519-1-surenb@google.com
Fixes: 916cc5167cc6 ("lib: code tagging framework")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/codetag.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/codetag.c b/lib/codetag.c
index 5ace625f2328..afa8a2d4f317 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -125,7 +125,6 @@ static inline size_t range_size(const struct codetag_type *cttype,
 			cttype->desc.tag_size;
 }
 
-#ifdef CONFIG_MODULES
 static void *get_symbol(struct module *mod, const char *prefix, const char *name)
 {
 	DECLARE_SEQ_BUF(sb, KSYM_NAME_LEN);
@@ -155,6 +154,15 @@ static struct codetag_range get_section_range(struct module *mod,
 	};
 }
 
+static const char *get_mod_name(__maybe_unused struct module *mod)
+{
+#ifdef CONFIG_MODULES
+	if (mod)
+		return mod->name;
+#endif
+	return "(built-in)";
+}
+
 static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 {
 	struct codetag_range range;
@@ -164,8 +172,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 	range = get_section_range(mod, cttype->desc.section);
 	if (!range.start || !range.stop) {
 		pr_warn("Failed to load code tags of type %s from the module %s\n",
-			cttype->desc.section,
-			mod ? mod->name : "(built-in)");
+			cttype->desc.section, get_mod_name(mod));
 		return -EINVAL;
 	}
 
@@ -199,6 +206,7 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 	return 0;
 }
 
+#ifdef CONFIG_MODULES
 void codetag_load_module(struct module *mod)
 {
 	struct codetag_type *cttype;
@@ -248,9 +256,6 @@ bool codetag_unload_module(struct module *mod)
 
 	return unload_ok;
 }
-
-#else /* CONFIG_MODULES */
-static int codetag_module_init(struct codetag_type *cttype, struct module *mod) { return 0; }
 #endif /* CONFIG_MODULES */
 
 struct codetag_type *
-- 
2.46.0



