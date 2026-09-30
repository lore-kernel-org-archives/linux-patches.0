Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EACE5172CB;
	Wed, 30 Sep 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787187; cv=none; b=bolRY60KavVAiBTE73Ca/r8zT/oHW4yKjkzcH/mv07PgdRrn3R+vWr51rpRkZii4VURpI6xiMAhNr6TMHSt6p1ElFIAqBFYfhCrtZcK7hsNS42L4zRg7f8baA4TTitUeSK+6MsZ5vdjbR9TZslUreTKlxhkoRDgcgxVULPNOEm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787187; c=relaxed/simple;
	bh=lLdELZY8s4PlNrLQ/JH+pvAfsODgkigMiOmugdesUlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvhzhJTbX6HNt/CQuHPPzPmzVh0+4OLbwbsogl3j51OWZSYk57CoUwGfQlcAcWslkX/QYodiYMre8FXyxyLk1aKu3Tge/k6A6TlaSQE/6xTHzIIrOzZ7w3jD7loUuj0MwiudAgSX0VZJHzzHzeSOj7bcK6LuSnCrHLWF5yi5jSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsewzNpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsewzNpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C281F000FF;
	Wed, 30 Sep 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787186;
	bh=OhJlG9QDDirs/dhue4nbYdEsOodl8t4q/yj2CB250vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsewzNpAlw8w5m37NLKLGbMSdM92c667EpeXMXFm7nSPrIL+xnPTuh3WcR84X0qCW
	 MDhI0Nieg6osTmAr/ret81fpNOPL4e+wTPI8xkGgRgoLoi/P0mhF8Vef49af/bG1tj
	 Vdeioc1WKLQ6mIBZHZvqoe6b344JrNtDR+eKYTt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 141/457] s390/debug: Do not register views for failed static debug areas
Date: Wed, 30 Sep 2026 17:24:06 +0200
Message-ID: <20260930152349.096311565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 39d484c597748..ad438d6352c8e 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -460,7 +460,11 @@ static int VNAME(var, active_entries)[EARLY_AREAS] __initdata
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
@@ -493,7 +497,7 @@ static debug_info_t __refdata var =					\
 static debug_info_t __used __section(".s390dbf_info") *VNAME(var, info) = &var; \
 __REGISTER_STATIC_DEBUG_INFO(var, name, pages, nr_areas, view)
 
-void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
+int debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas);
 
 #endif /* MODULE */
 
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index e06abf1dbc218..d193c6fd1ecc7 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -948,8 +948,12 @@ EXPORT_SYMBOL(debug_register);
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
@@ -957,7 +961,7 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 	if (!initialized) {
 		pr_err("Tried to register debug feature %s too early\n",
 		       id->name);
-		return;
+		return -EINVAL;
 	}
 
 	debug_get_param(id->name, &id->level, &pages_per_area);
@@ -973,7 +977,7 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 		id->active_entries = NULL;
 		raw_spin_unlock_irqrestore(&id->lock, flags);
 
-		return;
+		return -ENOMEM;
 	}
 
 	/* Replace static trace area with dynamic copy. */
@@ -991,6 +995,8 @@ void debug_register_static(debug_info_t *id, int pages_per_area, int nr_areas)
 	mutex_lock(&debug_mutex);
 	_debug_register(id);
 	mutex_unlock(&debug_mutex);
+
+	return 0;
 }
 
 /* Remove debugfs entries. */
-- 
2.53.0



