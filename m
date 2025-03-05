Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A651A3174;
	Wed,  5 Mar 2025 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197888; cv=none; b=HgiToyCuPT1GuD7WbzEhY5bHWfeg4DNRTHPd0jec3k1YyT7vBgqtTq/9vjJXjlZa1CQrdYifhyaogsVlvHdc4ltJW1iJfSL4RAsQxUwbAID/apsQr7IGwX5pdKu0QDN/n4Q9lYDaO8LM4LHbPJDipBh4TMNR194jCX4kVBEo+a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197888; c=relaxed/simple;
	bh=s1Zv9OMGNUhfK3R9OqQDVarQwezhoRlmy0Y+gSfMsMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOLHYghWqjADeto772Wo1EsZw5wX0q8P6OAIPAUt4SCfMIeDigGF9VlgLsKGbz2Fi3uH9cu1PvkdbXqI/vTIojgGau8LL6+/X9eS4YcgZ9Q0cgsAVa4i2p9SWGfdkLgr0uPvz7LV/+PpUdU3raoAfSddudWhj1GxzjKfM4XRfZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkEVQlE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkEVQlE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD04C4CED1;
	Wed,  5 Mar 2025 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197887;
	bh=s1Zv9OMGNUhfK3R9OqQDVarQwezhoRlmy0Y+gSfMsMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkEVQlE6XzuzaG5g/fz1YAIFg7aRyt2krtc0HNDO6Yn0TjntaX/7NXfUcq8kE43BH
	 JFjmv9mssNlXCRUD205MMRDBOawQrhvXXwn1pdW/ZEZTTKnkaxSF33LZayaVN8w93i
	 MRGaaEDgpf4Yi4IpL8Zgjsd1QaQXGsHjIhnDPdZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 133/142] x86/microcode/AMD: Split load_microcode_amd()
Date: Wed,  5 Mar 2025 18:49:12 +0100
Message-ID: <20250305174505.676974951@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit 1d81d85d1a19e50d5237dc67d6b825c34ae13de8 upstream

This function should've been split a long time ago because it is used in
two paths:

1) On the late loading path, when the microcode is loaded through the
   request_firmware interface

2) In the save_microcode_in_initrd() path which collects all the
   microcode patches which are relevant for the current system before
   the initrd with the microcode container has been jettisoned.

   In that path, it is not really necessary to iterate over the nodes on
   a system and match a patch however it didn't cause any trouble so it
   was left for a later cleanup

However, that later cleanup was expedited by the fact that Jens was
enabling "Use L3 as a NUMA node" in the BIOS setting in his machine and
so this causes the NUMA CPU masks used in cpumask_of_node() to be
generated *after* 2) above happened on the first node. Which means, all
those masks were funky, wrong, uninitialized and whatnot, leading to
explosions when dereffing c->microcode in load_microcode_amd().

So split that function and do only the necessary work needed at each
stage.

Fixes: 94838d230a6c ("x86/microcode/AMD: Use the family,model,stepping encoded in the patch ID")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/91194406-3fdf-4e38-9838-d334af538f74@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -586,7 +586,7 @@ void __init load_ucode_amd_bsp(struct ea
 		native_rdmsr(MSR_AMD64_PATCH_LEVEL, ed->new_rev, dummy);
 }
 
-static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
+static enum ucode_state _load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 static int __init save_microcode_in_initrd(void)
 {
@@ -607,7 +607,7 @@ static int __init save_microcode_in_init
 	if (!desc.mc)
 		return -EINVAL;
 
-	ret = load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
+	ret = _load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
 	if (ret > UCODE_UPDATED)
 		return -EINVAL;
 
@@ -956,21 +956,30 @@ static enum ucode_state __load_microcode
 	return UCODE_OK;
 }
 
-static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
+static enum ucode_state _load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
-	struct cpuinfo_x86 *c;
-	unsigned int nid, cpu;
-	struct ucode_patch *p;
 	enum ucode_state ret;
 
 	/* free old equiv table */
 	free_equiv_cpu_table();
 
 	ret = __load_microcode_amd(family, data, size);
-	if (ret != UCODE_OK) {
+	if (ret != UCODE_OK)
 		cleanup();
+
+	return ret;
+}
+
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
+{
+	struct cpuinfo_x86 *c;
+	unsigned int nid, cpu;
+	struct ucode_patch *p;
+	enum ucode_state ret;
+
+	ret = _load_microcode_amd(family, data, size);
+	if (ret != UCODE_OK)
 		return ret;
-	}
 
 	for_each_node(nid) {
 		cpu = cpumask_first(cpumask_of_node(nid));


