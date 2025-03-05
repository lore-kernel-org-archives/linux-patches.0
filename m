Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7951A3174;
	Wed,  5 Mar 2025 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197934; cv=none; b=SMcE1gDesw4NxUCp/qwqKVmOCAGf07iqCABEr11wcUPdEkixndExL/WpsFuk8DCJqC4LIlG9uv5V3IVfjjKcLhbsoI/qbBCVNcv3ADFUQNTqmwDwVF1YhhKk6hyrTFe0cV5Eexhm6lBO7cMmPnWtWMti3j6m4J5BpbHhno3gclY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197934; c=relaxed/simple;
	bh=Mck8a4P65WHE8tuoHjj6/0t2uS06Gjcyh6yRZP/l3sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH5pk7O3fVfcoWR735jTzvRgrK/+ZVwwsa9kxvQqfurBipNrdEpTsuoihSjYCS23SRHv3Da23+kL3vHV+wjkMjLYO3+Dxts+PD96z6gITrM6CXTy91YkeP+lS9NElUQ3xCSAO/Zhp3j8coZqRq3M0jnnTexj5naz8cS/+vVV8Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo7Nu8zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo7Nu8zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB1DC4CED1;
	Wed,  5 Mar 2025 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197934;
	bh=Mck8a4P65WHE8tuoHjj6/0t2uS06Gjcyh6yRZP/l3sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xo7Nu8zk6p1dSrBc4u/xOkfuhHMIOUcuj7kFrCCU/tlSTe12T3e3zvZ719EF/MDHn
	 nilGEbCy5agXv/0EkWURD/vxTgIc0VdCMw73sY661ij/OGEyuUuQ12dcIel5OfWAFG
	 ENkbgmI7uNHxCOEB+ShtjGcIJHdG5qwPxfBFzNF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 138/142] x86/microcode/AMD: Have __apply_microcode_amd() return bool
Date: Wed,  5 Mar 2025 18:49:17 +0100
Message-ID: <20250305174505.880910499@linuxfoundation.org>
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

commit 78e0aadbd4c6807a06a9d25bc190fe515d3f3c42 upstream

This is the natural thing to do anyway.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -486,7 +486,7 @@ static void scan_containers(u8 *ucode, s
 	}
 }
 
-static int __apply_microcode_amd(struct microcode_amd *mc, unsigned int psize)
+static bool __apply_microcode_amd(struct microcode_amd *mc, unsigned int psize)
 {
 	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 	u32 rev, dummy;
@@ -510,9 +510,9 @@ static int __apply_microcode_amd(struct
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev != mc->hdr.patch_id)
-		return -1;
+		return false;
 
-	return 0;
+	return true;
 }
 
 /*
@@ -546,7 +546,7 @@ static bool early_apply_microcode(u32 ol
 	if (old_rev > mc->hdr.patch_id)
 		return ret;
 
-	return !__apply_microcode_amd(mc, desc.psize);
+	return __apply_microcode_amd(mc, desc.psize);
 }
 
 static bool get_builtin_microcode(struct cpio_data *cp)
@@ -765,7 +765,7 @@ void reload_ucode_amd(unsigned int cpu)
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev < mc->hdr.patch_id) {
-		if (!__apply_microcode_amd(mc, p->size))
+		if (__apply_microcode_amd(mc, p->size))
 			pr_info_once("reload revision: 0x%08x\n", mc->hdr.patch_id);
 	}
 }
@@ -818,7 +818,7 @@ static enum ucode_state apply_microcode_
 		goto out;
 	}
 
-	if (__apply_microcode_amd(mc_amd, p->size)) {
+	if (!__apply_microcode_amd(mc_amd, p->size)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
 		return UCODE_ERROR;


