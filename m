Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE854DEC26;
	Wed, 30 Sep 2026 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792391; cv=none; b=usVzSM0rh9KEAbo9mD4cidp/qSr2erpjmoOfRH5YmtQJXkf3+1Wtc6x8/HpWRMkX2tfgFZGsTK41jkUOsOzoV+3NVF9YSgzLYf78rbL36ThsaD8KzWGLR8d8AkUSN1YrvV3LlrU0zNE05TL9T2BzfLQRN++YLuTeEGsYsvrZqOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792391; c=relaxed/simple;
	bh=y4qHvHiE7G365R6Ptfvkquz6wEGClSW5xAZh8Rdfnlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZEQTymaR6pw6qzpCgozj6yTCWFPdjaBGo16B0VD0PMo83+X5TMQieaZwnxyjeRawOYZPHHQKSd3hlGcSG2kZab+sizU0mJ27EgHVudHJmJorjok9pxXnTJ1i3k381MojcliJjo+S4cZ+RWpm1vEXqDStAkiLjSNsDc9gbykRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/ZJtXhS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/ZJtXhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A721F000FF;
	Wed, 30 Sep 2026 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792389;
	bh=9FAFsYM1wMGoKzscWg55pONXGUVehvNESgJdlZn2its=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/ZJtXhSIZMRmqKC1ysJUJIVu03di4o3a2MtKoVvQBK38Va33WCExUA36pn6sY55t
	 VNkAvIvJeeQYmpbt4Xf+WH5QMXjpqSx8tKv595WTNvoVtEZ1/mEblX+dUaUreyMnT8
	 B5nkzRu5lGIJ62g4gqbvdGLjvaE4zuI845fmTjGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/752] s390/debug: Do not register views for failed static debug areas
Date: Wed, 30 Sep 2026 17:28:27 +0200
Message-ID: <20260930152412.051676342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Mikhail Zaslonko <zaslonko@linux.ibm.com>

[ Upstream commit 28e29992b034acffc9342df216c06097825ce610 ]

__REGISTER_STATIC_DEBUG_INFO() calls debug_register_view()
unconditionally, even when debug_register_static() has failed. In that
case _debug_register() was never reached and id->debugfs_root_entry is
still NULL, so debugfs_create_file() places the view file in the debugfs
root directory. For sclp_err this leaves a /sys/kernel/debug/hex_ascii
file with nothing to indicate which debug log it belongs to.

debug_register_static() is not exported and the macro is its only
caller, so let it return an error code and skip the view registration
when it fails. No debugfs files are created for such an area then.

Reproduce by booting with s390dbf=sclp_err::100000000. The sclp_err
registration fails, no s390dbf/sclp_err/ directory is created, and a
hex_ascii file appears in the debugfs root instead.

Fixes: d72541f94512 ("s390/debug: add early tracing support")
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/debug.h |  8 ++++++--
 arch/s390/kernel/debug.c      | 12 +++++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index 5fc91a90657e7..64a58246e5cd1 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -451,7 +451,11 @@ static int VNAME(var, active_entries)[EARLY_AREAS] __initdata
 #define __REGISTER_STATIC_DEBUG_INFO(var, name, pages, areas, view)	\
 static int __init VNAME(var, reg)(void)					\
 {									\
-	debug_register_static(&var, (pages), (areas));			\
+	int rc;								\
+									\
+	rc = debug_register_static(&var, (pages), (areas));		\
+	if (rc)								\
+		return rc;						\
 	debug_register_view(&var, (view));				\
 	return 0;							\
 }									\
@@ -483,7 +487,7 @@ static debug_info_t __refdata var =					\
 	__DEBUG_INFO_INIT(var, (name), (buf_size));			\
 __REGISTER_STATIC_DEBUG_INFO(var, name, pages, nr_areas, view)
 
-void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
+int debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
 
 #endif /* MODULE */
 
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index d02e62476c817..6b0fe0c0d94c4 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -703,8 +703,12 @@ EXPORT_SYMBOL(debug_register);
  *
  * Note: This function is called automatically via an initcall generated by
  *	 DEFINE_STATIC_DEBUG_INFO.
+ *
+ * Return:
+ * - 0 on success
+ * - negative error code on failure
  */
-void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
+int debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 {
 	unsigned long flags;
 	debug_info_t *copy;
@@ -712,7 +716,7 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 	if (!initialized) {
 		pr_err("Tried to register debug feature %s too early\n",
 		       id->name);
-		return;
+		return -EINVAL;
 	}
 
 	copy = debug_info_alloc("", pages_per_area, nr_areas, id->buf_size,
@@ -727,7 +731,7 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 		id->active_entries = NULL;
 		spin_unlock_irqrestore(&id->lock, flags);
 
-		return;
+		return -ENOMEM;
 	}
 
 	/* Replace static trace area with dynamic copy. */
@@ -745,6 +749,8 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 	mutex_lock(&debug_mutex);
 	_debug_register(id);
 	mutex_unlock(&debug_mutex);
+
+	return 0;
 }
 
 /* Remove debugfs entries. */
-- 
2.53.0



