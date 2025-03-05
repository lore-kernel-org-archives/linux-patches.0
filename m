Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A61251788;
	Wed,  5 Mar 2025 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197879; cv=none; b=dTwQaNaeqKCd0w0rPU/YUshvCmf5YZlkER6AkYfPdLhX4YCMvXAQ3si1T4oGT1rQH1Q0gwFx7FqROL+4omNUBb0PXb9A7ni6I/D0IUg6L3e9niL0Pmpf2NUfKX15v0gwM33WRFyi3OsBTjAmy1wIqirX1YCNShJLNY9zcmq80y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197879; c=relaxed/simple;
	bh=IV/Gff7CF1kCU60jJdHbtXPjB/oW8vj/002bXHK4Bxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etsU9vGWKGMgW3WL6ytSWlrUxnGq1TByrhbRKkNp3Q0LvFPpv66LVEIIuc3TUezpM+V9rutCuhmg2Nga1dqu6pHfsxiTa8PjObrMXtsi/u3MVkrrFW+6ftPPLx1IEqQnP66JcYKm6uUWT6tRuoBkINrgs8IX03Yn6WgA+3M1tdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZSbWVc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZSbWVc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB4C4CEE2;
	Wed,  5 Mar 2025 18:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197879;
	bh=IV/Gff7CF1kCU60jJdHbtXPjB/oW8vj/002bXHK4Bxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZSbWVc+SLw8ef98fbMxk5NO8eAKknJb0LMt2t4gR9wyExgf5nBcnaJfjx1j/kSZo
	 08shxSAZP+e9I8zH/4XsQWsyzeA8F1jSsfmgVdfmQvOTQNuul3BljEHlfY0W0zMOV6
	 89AMkdPF2KRUvTjAjJy2pR3UPVa/ig2cuKf4BZmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 131/142] x86/microcode/AMD: Use the family,model,stepping encoded in the patch ID
Date: Wed,  5 Mar 2025 18:49:10 +0100
Message-ID: <20250305174505.600020598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@alien8.de>

commit 94838d230a6c835ced1bad06b8759e0a5f19c1d3 upstream

On Zen and newer, the family, model and stepping is part of the
microcode patch ID so that the equivalence table the driver has been
using, is not needed anymore.

So switch the driver to use that from now on.

The equivalence table in the microcode blob should still remain in case
there's need to pass some additional information to the kernel loader.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240725112037.GBZqI1BbUk1KMlOJ_D@fat_crate.local
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |  190 +++++++++++++++++++++++++++++-------
 1 file changed, 158 insertions(+), 32 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -91,6 +91,31 @@ static struct equiv_cpu_table {
 	struct equiv_cpu_entry *entry;
 } equiv_table;
 
+union zen_patch_rev {
+	struct {
+		__u32 rev	 : 8,
+		      stepping	 : 4,
+		      model	 : 4,
+		      __reserved : 4,
+		      ext_model	 : 4,
+		      ext_fam	 : 8;
+	};
+	__u32 ucode_rev;
+};
+
+union cpuid_1_eax {
+	struct {
+		__u32 stepping    : 4,
+		      model	  : 4,
+		      family	  : 4,
+		      __reserved0 : 4,
+		      ext_model   : 4,
+		      ext_fam     : 8,
+		      __reserved1 : 4;
+	};
+	__u32 full;
+};
+
 /*
  * This points to the current valid container of microcode patches which we will
  * save from the initrd/builtin before jettisoning its contents. @mc is the
@@ -98,7 +123,6 @@ static struct equiv_cpu_table {
  */
 struct cont_desc {
 	struct microcode_amd *mc;
-	u32		     cpuid_1_eax;
 	u32		     psize;
 	u8		     *data;
 	size_t		     size;
@@ -111,10 +135,42 @@ struct cont_desc {
 static const char
 ucode_path[] __maybe_unused = "kernel/x86/microcode/AuthenticAMD.bin";
 
+/*
+ * This is CPUID(1).EAX on the BSP. It is used in two ways:
+ *
+ * 1. To ignore the equivalence table on Zen1 and newer.
+ *
+ * 2. To match which patches to load because the patch revision ID
+ *    already contains the f/m/s for which the microcode is destined
+ *    for.
+ */
+static u32 bsp_cpuid_1_eax __ro_after_init;
+
+static union cpuid_1_eax ucode_rev_to_cpuid(unsigned int val)
+{
+	union zen_patch_rev p;
+	union cpuid_1_eax c;
+
+	p.ucode_rev = val;
+	c.full = 0;
+
+	c.stepping  = p.stepping;
+	c.model     = p.model;
+	c.ext_model = p.ext_model;
+	c.family    = 0xf;
+	c.ext_fam   = p.ext_fam;
+
+	return c;
+}
+
 static u16 find_equiv_id(struct equiv_cpu_table *et, u32 sig)
 {
 	unsigned int i;
 
+	/* Zen and newer do not need an equivalence table. */
+	if (x86_family(bsp_cpuid_1_eax) >= 0x17)
+		return 0;
+
 	if (!et || !et->num_entries)
 		return 0;
 
@@ -161,6 +217,10 @@ static bool verify_equivalence_table(con
 	if (!verify_container(buf, buf_size))
 		return false;
 
+	/* Zen and newer do not need an equivalence table. */
+	if (x86_family(bsp_cpuid_1_eax) >= 0x17)
+		return true;
+
 	cont_type = hdr[1];
 	if (cont_type != UCODE_EQUIV_CPU_TABLE_TYPE) {
 		pr_debug("Wrong microcode container equivalence table type: %u.\n",
@@ -224,8 +284,9 @@ __verify_patch_section(const u8 *buf, si
  * exceed the per-family maximum). @sh_psize is the size read from the section
  * header.
  */
-static unsigned int __verify_patch_size(u8 family, u32 sh_psize, size_t buf_size)
+static unsigned int __verify_patch_size(u32 sh_psize, size_t buf_size)
 {
+	u8 family = x86_family(bsp_cpuid_1_eax);
 	u32 max_size;
 
 	if (family >= 0x15)
@@ -260,9 +321,9 @@ static unsigned int __verify_patch_size(
  * positive: patch is not for this family, skip it
  * 0: success
  */
-static int
-verify_patch(u8 family, const u8 *buf, size_t buf_size, u32 *patch_size)
+static int verify_patch(const u8 *buf, size_t buf_size, u32 *patch_size)
 {
+	u8 family = x86_family(bsp_cpuid_1_eax);
 	struct microcode_header_amd *mc_hdr;
 	unsigned int ret;
 	u32 sh_psize;
@@ -288,7 +349,7 @@ verify_patch(u8 family, const u8 *buf, s
 		return -1;
 	}
 
-	ret = __verify_patch_size(family, sh_psize, buf_size);
+	ret = __verify_patch_size(sh_psize, buf_size);
 	if (!ret) {
 		pr_debug("Per-family patch size mismatch.\n");
 		return -1;
@@ -310,6 +371,15 @@ verify_patch(u8 family, const u8 *buf, s
 	return 0;
 }
 
+static bool mc_patch_matches(struct microcode_amd *mc, u16 eq_id)
+{
+	/* Zen and newer do not need an equivalence table. */
+	if (x86_family(bsp_cpuid_1_eax) >= 0x17)
+		return ucode_rev_to_cpuid(mc->hdr.patch_id).full == bsp_cpuid_1_eax;
+	else
+		return eq_id == mc->hdr.processor_rev_id;
+}
+
 /*
  * This scans the ucode blob for the proper container as we can have multiple
  * containers glued together. Returns the equivalence ID from the equivalence
@@ -338,7 +408,7 @@ static size_t parse_container(u8 *ucode,
 	 * doesn't contain a patch for the CPU, scan through the whole container
 	 * so that it can be skipped in case there are other containers appended.
 	 */
-	eq_id = find_equiv_id(&table, desc->cpuid_1_eax);
+	eq_id = find_equiv_id(&table, bsp_cpuid_1_eax);
 
 	buf  += hdr[2] + CONTAINER_HDR_SZ;
 	size -= hdr[2] + CONTAINER_HDR_SZ;
@@ -352,7 +422,7 @@ static size_t parse_container(u8 *ucode,
 		u32 patch_size;
 		int ret;
 
-		ret = verify_patch(x86_family(desc->cpuid_1_eax), buf, size, &patch_size);
+		ret = verify_patch(buf, size, &patch_size);
 		if (ret < 0) {
 			/*
 			 * Patch verification failed, skip to the next container, if
@@ -365,7 +435,7 @@ static size_t parse_container(u8 *ucode,
 		}
 
 		mc = (struct microcode_amd *)(buf + SECTION_HDR_SIZE);
-		if (eq_id == mc->hdr.processor_rev_id) {
+		if (mc_patch_matches(mc, eq_id)) {
 			desc->psize = patch_size;
 			desc->mc = mc;
 		}
@@ -423,6 +493,7 @@ static int __apply_microcode_amd(struct
 
 	/* verify patch application was successful */
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+
 	if (rev != mc->hdr.patch_id)
 		return -1;
 
@@ -440,14 +511,12 @@ static int __apply_microcode_amd(struct
  *
  * Returns true if container found (sets @desc), false otherwise.
  */
-static bool early_apply_microcode(u32 cpuid_1_eax, u32 old_rev, void *ucode, size_t size)
+static bool early_apply_microcode(u32 old_rev, void *ucode, size_t size)
 {
 	struct cont_desc desc = { 0 };
 	struct microcode_amd *mc;
 	bool ret = false;
 
-	desc.cpuid_1_eax = cpuid_1_eax;
-
 	scan_containers(ucode, size, &desc);
 
 	mc = desc.mc;
@@ -465,9 +534,10 @@ static bool early_apply_microcode(u32 cp
 	return !__apply_microcode_amd(mc);
 }
 
-static bool get_builtin_microcode(struct cpio_data *cp, unsigned int family)
+static bool get_builtin_microcode(struct cpio_data *cp)
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
+	u8 family = x86_family(bsp_cpuid_1_eax);
 	struct firmware fw;
 
 	if (IS_ENABLED(CONFIG_X86_32))
@@ -486,11 +556,11 @@ static bool get_builtin_microcode(struct
 	return false;
 }
 
-static void __init find_blobs_in_containers(unsigned int cpuid_1_eax, struct cpio_data *ret)
+static void __init find_blobs_in_containers(struct cpio_data *ret)
 {
 	struct cpio_data cp;
 
-	if (!get_builtin_microcode(&cp, x86_family(cpuid_1_eax)))
+	if (!get_builtin_microcode(&cp))
 		cp = find_microcode_in_initrd(ucode_path);
 
 	*ret = cp;
@@ -501,16 +571,18 @@ void __init load_ucode_amd_bsp(struct ea
 	struct cpio_data cp = { };
 	u32 dummy;
 
+	bsp_cpuid_1_eax = cpuid_1_eax;
+
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, ed->old_rev, dummy);
 
 	/* Needed in load_microcode_amd() */
 	ucode_cpu_info[0].cpu_sig.sig = cpuid_1_eax;
 
-	find_blobs_in_containers(cpuid_1_eax, &cp);
+	find_blobs_in_containers(&cp);
 	if (!(cp.data && cp.size))
 		return;
 
-	if (early_apply_microcode(cpuid_1_eax, ed->old_rev, cp.data, cp.size))
+	if (early_apply_microcode(ed->old_rev, cp.data, cp.size))
 		native_rdmsr(MSR_AMD64_PATCH_LEVEL, ed->new_rev, dummy);
 }
 
@@ -527,12 +599,10 @@ static int __init save_microcode_in_init
 	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
 		return 0;
 
-	find_blobs_in_containers(cpuid_1_eax, &cp);
+	find_blobs_in_containers(&cp);
 	if (!(cp.data && cp.size))
 		return -EINVAL;
 
-	desc.cpuid_1_eax = cpuid_1_eax;
-
 	scan_containers(cp.data, cp.size, &desc);
 	if (!desc.mc)
 		return -EINVAL;
@@ -545,26 +615,65 @@ static int __init save_microcode_in_init
 }
 early_initcall(save_microcode_in_initrd);
 
+static inline bool patch_cpus_equivalent(struct ucode_patch *p, struct ucode_patch *n)
+{
+	/* Zen and newer hardcode the f/m/s in the patch ID */
+        if (x86_family(bsp_cpuid_1_eax) >= 0x17) {
+		union cpuid_1_eax p_cid = ucode_rev_to_cpuid(p->patch_id);
+		union cpuid_1_eax n_cid = ucode_rev_to_cpuid(n->patch_id);
+
+		/* Zap stepping */
+		p_cid.stepping = 0;
+		n_cid.stepping = 0;
+
+		return p_cid.full == n_cid.full;
+	} else {
+		return p->equiv_cpu == n->equiv_cpu;
+	}
+}
+
 /*
  * a small, trivial cache of per-family ucode patches
  */
-static struct ucode_patch *cache_find_patch(u16 equiv_cpu)
+static struct ucode_patch *cache_find_patch(struct ucode_cpu_info *uci, u16 equiv_cpu)
 {
 	struct ucode_patch *p;
+	struct ucode_patch n;
+
+	n.equiv_cpu = equiv_cpu;
+	n.patch_id  = uci->cpu_sig.rev;
+
+	WARN_ON_ONCE(!n.patch_id);
 
 	list_for_each_entry(p, &microcode_cache, plist)
-		if (p->equiv_cpu == equiv_cpu)
+		if (patch_cpus_equivalent(p, &n))
 			return p;
+
 	return NULL;
 }
 
+static inline bool patch_newer(struct ucode_patch *p, struct ucode_patch *n)
+{
+	/* Zen and newer hardcode the f/m/s in the patch ID */
+        if (x86_family(bsp_cpuid_1_eax) >= 0x17) {
+		union zen_patch_rev zp, zn;
+
+		zp.ucode_rev = p->patch_id;
+		zn.ucode_rev = n->patch_id;
+
+		return zn.rev > zp.rev;
+	} else {
+		return n->patch_id > p->patch_id;
+	}
+}
+
 static void update_cache(struct ucode_patch *new_patch)
 {
 	struct ucode_patch *p;
 
 	list_for_each_entry(p, &microcode_cache, plist) {
-		if (p->equiv_cpu == new_patch->equiv_cpu) {
-			if (p->patch_id >= new_patch->patch_id) {
+		if (patch_cpus_equivalent(p, new_patch)) {
+			if (!patch_newer(p, new_patch)) {
 				/* we already have the latest patch */
 				kfree(new_patch->data);
 				kfree(new_patch);
@@ -595,13 +704,22 @@ static void free_cache(void)
 static struct ucode_patch *find_patch(unsigned int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u32 rev, dummy __always_unused;
 	u16 equiv_id;
 
-	equiv_id = find_equiv_id(&equiv_table, uci->cpu_sig.sig);
-	if (!equiv_id)
-		return NULL;
+	/* fetch rev if not populated yet: */
+	if (!uci->cpu_sig.rev) {
+		rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+		uci->cpu_sig.rev = rev;
+	}
+
+	if (x86_family(bsp_cpuid_1_eax) < 0x17) {
+		equiv_id = find_equiv_id(&equiv_table, uci->cpu_sig.sig);
+		if (!equiv_id)
+			return NULL;
+	}
 
-	return cache_find_patch(equiv_id);
+	return cache_find_patch(uci, equiv_id);
 }
 
 void reload_ucode_amd(unsigned int cpu)
@@ -651,7 +769,7 @@ static enum ucode_state apply_microcode_
 	struct ucode_cpu_info *uci;
 	struct ucode_patch *p;
 	enum ucode_state ret;
-	u32 rev, dummy __always_unused;
+	u32 rev;
 
 	BUG_ON(raw_smp_processor_id() != cpu);
 
@@ -661,11 +779,11 @@ static enum ucode_state apply_microcode_
 	if (!p)
 		return UCODE_NFOUND;
 
+	rev = uci->cpu_sig.rev;
+
 	mc_amd  = p->data;
 	uci->mc = p->data;
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
-
 	/* need to apply patch? */
 	if (rev > mc_amd->hdr.patch_id) {
 		ret = UCODE_OK;
@@ -711,6 +829,10 @@ static size_t install_equiv_cpu_table(co
 	hdr = (const u32 *)buf;
 	equiv_tbl_len = hdr[2];
 
+	/* Zen and newer do not need an equivalence table. */
+	if (x86_family(bsp_cpuid_1_eax) >= 0x17)
+		goto out;
+
 	equiv_table.entry = vmalloc(equiv_tbl_len);
 	if (!equiv_table.entry) {
 		pr_err("failed to allocate equivalent CPU table\n");
@@ -720,12 +842,16 @@ static size_t install_equiv_cpu_table(co
 	memcpy(equiv_table.entry, buf + CONTAINER_HDR_SZ, equiv_tbl_len);
 	equiv_table.num_entries = equiv_tbl_len / sizeof(struct equiv_cpu_entry);
 
+out:
 	/* add header length */
 	return equiv_tbl_len + CONTAINER_HDR_SZ;
 }
 
 static void free_equiv_cpu_table(void)
 {
+	if (x86_family(bsp_cpuid_1_eax) >= 0x17)
+		return;
+
 	vfree(equiv_table.entry);
 	memset(&equiv_table, 0, sizeof(equiv_table));
 }
@@ -751,7 +877,7 @@ static int verify_and_add_patch(u8 famil
 	u16 proc_id;
 	int ret;
 
-	ret = verify_patch(family, fw, leftover, patch_size);
+	ret = verify_patch(fw, leftover, patch_size);
 	if (ret)
 		return ret;
 
@@ -776,7 +902,7 @@ static int verify_and_add_patch(u8 famil
 	patch->patch_id  = mc_hdr->patch_id;
 	patch->equiv_cpu = proc_id;
 
-	pr_debug("%s: Added patch_id: 0x%08x, proc_id: 0x%04x\n",
+	pr_debug("%s: Adding patch_id: 0x%08x, proc_id: 0x%04x\n",
 		 __func__, patch->patch_id, proc_id);
 
 	/* ... and add to cache. */


