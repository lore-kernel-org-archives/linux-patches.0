Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C7E1A23A6;
	Wed,  5 Mar 2025 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198366; cv=none; b=K7XCI3wA5xmZ4QlDeqJ2NobUjrvdx3Tzqm1i4Ll48U6hFvNUAaeU2hfcPhPCfbDPSSHSQ2Z2/t2Fw0lKadI6laNk9t7x3Uc0t5Z5eRCqDxLkB+hW65/g5eB7hd1yB6KUxlbBEBjQG74z3EBExJbe6SEdN1DxZRSS47yQSYD/BN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198366; c=relaxed/simple;
	bh=+9rRt1Z/lJ5UQeq56GPzlObf1J96Vvb13H2tvW43Jz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOUUtJXr6XITkjFTK7PNTd2PLUPlJzQwsKiScUFrQBxdYGh1FZrlavYGLxFzfmZOLwtlGIYu4ZHoqz8PHuFZPrAItT12+cqoBSMrwsz66HRHCZslL2IrBj3ZP9JhVNfHgm6NcIjJc1V1i1oAuHTZQfuR1OPZrsXZ4KJVgABabdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6nY3vrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6nY3vrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C986CC4CED1;
	Wed,  5 Mar 2025 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198366;
	bh=+9rRt1Z/lJ5UQeq56GPzlObf1J96Vvb13H2tvW43Jz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6nY3vrvdvV//EvKqgSuevoK4KJLO4KP6JtlRw7N/L8c3BorNsdSNQoOBn77+yHe9
	 sYtJRmSVqV7rj4h8X7MJG6bYHdU3tTHga0R9KdPYnjVdEVk6hfDinHbZrsCAky/lOm
	 +iX1tTA8ORvljjWDbKqsYOJO36FxWTTEah9aJ4ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 147/150] x86/microcode/AMD: Merge early_apply_microcode() into its single callsite
Date: Wed,  5 Mar 2025 18:49:36 +0100
Message-ID: <20250305174509.721704758@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


