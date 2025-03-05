Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B75D253340;
	Wed,  5 Mar 2025 18:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198810; cv=none; b=ZMcNte6SXnC6NO3A6r5yW1FDBAEmFboaY3yhSKB6F8zbrto3l4Z4gBHB4vyNr9M+gdc7z3e/cyDy7LRN4NlsndrO3malnPyl4OQ2UebgrYtTCeyHBg8KD/fZZlq/qiam4pdCFPeC0Vi/LJWRJ7f6GijWvPhS3CEika2CQCcYlQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198810; c=relaxed/simple;
	bh=T7cFdM0V8p4DvYc/VEVyarX83/AoF7LEKZ9dzb1BG9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTuLFrexovFBsPWBa8Fhrg0R7m3+dyQU4hd69P00//zBJfoOZ6JK3vCdJWKKUSIvNbYnAiiYi+OVhn0l750EEd1SXuZ/zcSq1SW77+zfOQ+n2uaLzoCGirP/yXkz2xp1W/HbBGh0XX4sE96dyV2XBIOcdRIpeJba4nN1ffP9wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jg6l3de6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jg6l3de6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6237C4CED1;
	Wed,  5 Mar 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198810;
	bh=T7cFdM0V8p4DvYc/VEVyarX83/AoF7LEKZ9dzb1BG9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jg6l3de6rsef3an8dC1zXricDmr5pLu5ofcy26/7JfypJqRhpUtpKmSKq85Jkg3Nc
	 W9VUTz7vE2mEdW1GYDCvlZGEml3ITQohHER/S3qxewWN/x/19Yq2/fj0DRsKywvJJf
	 WrP48RICBnaH1iRpethVfljx6D7PbpoMJJJDujuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.13 154/157] x86/microcode/AMD: Merge early_apply_microcode() into its single callsite
Date: Wed,  5 Mar 2025 18:49:50 +0100
Message-ID: <20250305174511.477929370@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit dc15675074dcfd79a2f10a6e39f96b0244961a01 upstream.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250211163648.30531-4-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   60 +++++++++++++++---------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -512,39 +512,6 @@ static bool __apply_microcode_amd(struct
 	return true;
 }
 
-/*
- * Early load occurs before we can vmalloc(). So we look for the microcode
- * patch container file in initrd, traverse equivalent cpu table, look for a
- * matching microcode patch, and update, all in initrd memory in place.
- * When vmalloc() is available for use later -- on 64-bit during first AP load,
- * and on 32-bit during save_microcode_in_initrd() -- we can call
- * load_microcode_amd() to save equivalent cpu table and microcode patches in
- * kernel heap memory.
- *
- * Returns true if container found (sets @desc), false otherwise.
- */
-static bool early_apply_microcode(u32 old_rev, void *ucode, size_t size)
-{
-	struct cont_desc desc = { 0 };
-	struct microcode_amd *mc;
-	bool ret = false;
-
-	scan_containers(ucode, size, &desc);
-
-	mc = desc.mc;
-	if (!mc)
-		return ret;
-
-	/*
-	 * Allow application of the same revision to pick up SMT-specific
-	 * changes even if the revision of the other SMT thread is already
-	 * up-to-date.
-	 */
-	if (old_rev > mc->hdr.patch_id)
-		return ret;
-
-	return __apply_microcode_amd(mc, desc.psize);
-}
 
 static bool get_builtin_microcode(struct cpio_data *cp)
 {
@@ -583,8 +550,19 @@ static bool __init find_blobs_in_contain
 	return found;
 }
 
+/*
+ * Early load occurs before we can vmalloc(). So we look for the microcode
+ * patch container file in initrd, traverse equivalent cpu table, look for a
+ * matching microcode patch, and update, all in initrd memory in place.
+ * When vmalloc() is available for use later -- on 64-bit during first AP load,
+ * and on 32-bit during save_microcode_in_initrd() -- we can call
+ * load_microcode_amd() to save equivalent cpu table and microcode patches in
+ * kernel heap memory.
+ */
 void __init load_ucode_amd_bsp(struct early_load_data *ed, unsigned int cpuid_1_eax)
 {
+	struct cont_desc desc = { };
+	struct microcode_amd *mc;
 	struct cpio_data cp = { };
 	u32 dummy;
 
@@ -598,7 +576,21 @@ void __init load_ucode_amd_bsp(struct ea
 	if (!find_blobs_in_containers(&cp))
 		return;
 
-	if (early_apply_microcode(ed->old_rev, cp.data, cp.size))
+	scan_containers(cp.data, cp.size, &desc);
+
+	mc = desc.mc;
+	if (!mc)
+		return;
+
+	/*
+	 * Allow application of the same revision to pick up SMT-specific
+	 * changes even if the revision of the other SMT thread is already
+	 * up-to-date.
+	 */
+	if (ed->old_rev > mc->hdr.patch_id)
+		return;
+
+	if (__apply_microcode_amd(mc, desc.psize))
 		native_rdmsr(MSR_AMD64_PATCH_LEVEL, ed->new_rev, dummy);
 }
 


