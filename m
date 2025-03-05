Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9978C19067C;
	Wed,  5 Mar 2025 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197882; cv=none; b=J1GJU76Q7pIQ7p3hM8DPLw9wxJDlpNQeZPCVXUWnC+i2aaOVFL0iSrehOwkPQ7Ly5Tvr8dqr948L+1l5FfQF1MbWxhW9MgrZ8ovhd2JggUuZdmQYIu1kMYNBezfriyLRR9NLxczY27gP0EZSwhXdERIBOtkcVEhp+kIxbWruA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197882; c=relaxed/simple;
	bh=MbKrjp7NjZIyaoi/56oy4i+puAj97eiKVfLVh0E7B7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSKczoETemW+PFlYurK3MosRLv9pxtFNBvKbA8DqBhDSXqwfwEIzAbZn2NAKhXb/gjgvoHLOJNmyZllKilNwLDy40435V3FG22ezKqKz8Tj+38KhnhEQ7Jy/BRPA/INZtfaD7cJ7Ct7T+gRXjn2Dp+Yro6gbw+OhyJuZkaCY8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DALdXZNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DALdXZNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD824C4CEE2;
	Wed,  5 Mar 2025 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197882;
	bh=MbKrjp7NjZIyaoi/56oy4i+puAj97eiKVfLVh0E7B7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DALdXZNzeOlibXxAkl6cXFa4xVzGE+ltJ4wso9Yl+mpijB0pjHyh6SBBNGQSQVM/J
	 OAenyM6+1HtEJBnQB1sSH41MqqwuuxodDltCVpcQ0NF3xoFIdr/yIUGWFGOO3GoP5e
	 Xc98nugOHH/6l2dYQln31OZIrEpN694v+yjB9xTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 132/142] x86/microcode/AMD: Pay attention to the stepping dynamically
Date: Wed,  5 Mar 2025 18:49:11 +0100
Message-ID: <20250305174505.638490485@linuxfoundation.org>
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

commit d1744a4c975b1acbe8b498356d28afbc46c88428 upstream

Commit in Fixes changed how a microcode patch is loaded on Zen and newer but
the patch matching needs to happen with different rigidity, depending on what
is being done:

1) When the patch is added to the patches cache, the stepping must be ignored
   because the driver still supports different steppings per system

2) When the patch is matched for loading, then the stepping must be taken into
   account because each CPU needs the patch matching its exact stepping

Take care of that by making the matching smarter.

Fixes: 94838d230a6c ("x86/microcode/AMD: Use the family,model,stepping encoded in the patch ID")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/91194406-3fdf-4e38-9838-d334af538f74@kernel.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -615,16 +615,19 @@ static int __init save_microcode_in_init
 }
 early_initcall(save_microcode_in_initrd);
 
-static inline bool patch_cpus_equivalent(struct ucode_patch *p, struct ucode_patch *n)
+static inline bool patch_cpus_equivalent(struct ucode_patch *p,
+					 struct ucode_patch *n,
+					 bool ignore_stepping)
 {
 	/* Zen and newer hardcode the f/m/s in the patch ID */
         if (x86_family(bsp_cpuid_1_eax) >= 0x17) {
 		union cpuid_1_eax p_cid = ucode_rev_to_cpuid(p->patch_id);
 		union cpuid_1_eax n_cid = ucode_rev_to_cpuid(n->patch_id);
 
-		/* Zap stepping */
-		p_cid.stepping = 0;
-		n_cid.stepping = 0;
+		if (ignore_stepping) {
+			p_cid.stepping = 0;
+			n_cid.stepping = 0;
+		}
 
 		return p_cid.full == n_cid.full;
 	} else {
@@ -646,13 +649,13 @@ static struct ucode_patch *cache_find_pa
 	WARN_ON_ONCE(!n.patch_id);
 
 	list_for_each_entry(p, &microcode_cache, plist)
-		if (patch_cpus_equivalent(p, &n))
+		if (patch_cpus_equivalent(p, &n, false))
 			return p;
 
 	return NULL;
 }
 
-static inline bool patch_newer(struct ucode_patch *p, struct ucode_patch *n)
+static inline int patch_newer(struct ucode_patch *p, struct ucode_patch *n)
 {
 	/* Zen and newer hardcode the f/m/s in the patch ID */
         if (x86_family(bsp_cpuid_1_eax) >= 0x17) {
@@ -661,6 +664,9 @@ static inline bool patch_newer(struct uc
 		zp.ucode_rev = p->patch_id;
 		zn.ucode_rev = n->patch_id;
 
+		if (zn.stepping != zp.stepping)
+			return -1;
+
 		return zn.rev > zp.rev;
 	} else {
 		return n->patch_id > p->patch_id;
@@ -670,10 +676,14 @@ static inline bool patch_newer(struct uc
 static void update_cache(struct ucode_patch *new_patch)
 {
 	struct ucode_patch *p;
+	int ret;
 
 	list_for_each_entry(p, &microcode_cache, plist) {
-		if (patch_cpus_equivalent(p, new_patch)) {
-			if (!patch_newer(p, new_patch)) {
+		if (patch_cpus_equivalent(p, new_patch, true)) {
+			ret = patch_newer(p, new_patch);
+			if (ret < 0)
+				continue;
+			else if (!ret) {
 				/* we already have the latest patch */
 				kfree(new_patch->data);
 				kfree(new_patch);


