Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9725333C;
	Wed,  5 Mar 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198798; cv=none; b=TG1c+2RbSbwiGaHa0/1RF5Wf1dhzJprxwh7tBcx3aV1tw+dd8PDVtDi8sbtjbja25t+pQ2j8HtbvNJ5psfyGyu0dVj0V6EJLyUPXNTveot2fZ8bUROEXVbVb70P+IXRGFk6xoTgWeSEZMAdsxCl3SImiIev4xknOXLvZXLLrxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198798; c=relaxed/simple;
	bh=4ldk8t+1X6YsrjIIrjOe+QLxwiynWJSqGQzbcRBSVac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDh6QpuvowSVmZnRDN6xVutzAL8XzQGKJorbxhqAnxS5r+yZq4CzuaK9GMKyRRnvCV4PlcllCX1qbj891WoMzkZJVWcnxHBE5iuhO3zs01NP+vys3i8PSefdmnKp9p1rJMdlWRrV+REafJt3sDqji7+9QjACk76dDb7eK3dd4ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EP/N4mCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EP/N4mCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0ACC4CED1;
	Wed,  5 Mar 2025 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198798;
	bh=4ldk8t+1X6YsrjIIrjOe+QLxwiynWJSqGQzbcRBSVac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EP/N4mCOJ9GIW4sDW2v9nyt8IgoIdV8KtgylVNPF8e7L2tNzJ0v7hy2nsyWT2Dp6E
	 ZyUbCXeFnasYb5iNjFSUM77vBoqOm6OL/87MxYoSWeMHRhchMhmhZeVZ8/YjZ6d9TA
	 FX0ukkNJYLxCH5dR0k9Sn9GrbUwBVCu5xiBh73ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.13 151/157] x86/microcode/AMD: Have __apply_microcode_amd() return bool
Date: Wed,  5 Mar 2025 18:49:47 +0100
Message-ID: <20250305174511.360334708@linuxfoundation.org>
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
@@ -484,7 +484,7 @@ static void scan_containers(u8 *ucode, s
 	}
 }
 
-static int __apply_microcode_amd(struct microcode_amd *mc, unsigned int psize)
+static bool __apply_microcode_amd(struct microcode_amd *mc, unsigned int psize)
 {
 	unsigned long p_addr = (unsigned long)&mc->hdr.data_code;
 	u32 rev, dummy;
@@ -508,9 +508,9 @@ static int __apply_microcode_amd(struct
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev != mc->hdr.patch_id)
-		return -1;
+		return false;
 
-	return 0;
+	return true;
 }
 
 /*
@@ -544,7 +544,7 @@ static bool early_apply_microcode(u32 ol
 	if (old_rev > mc->hdr.patch_id)
 		return ret;
 
-	return !__apply_microcode_amd(mc, desc.psize);
+	return __apply_microcode_amd(mc, desc.psize);
 }
 
 static bool get_builtin_microcode(struct cpio_data *cp)
@@ -763,7 +763,7 @@ void reload_ucode_amd(unsigned int cpu)
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
 	if (rev < mc->hdr.patch_id) {
-		if (!__apply_microcode_amd(mc, p->size))
+		if (__apply_microcode_amd(mc, p->size))
 			pr_info_once("reload revision: 0x%08x\n", mc->hdr.patch_id);
 	}
 }
@@ -816,7 +816,7 @@ static enum ucode_state apply_microcode_
 		goto out;
 	}
 
-	if (__apply_microcode_amd(mc_amd, p->size)) {
+	if (!__apply_microcode_amd(mc_amd, p->size)) {
 		pr_err("CPU%d: update failed for patch_level=0x%08x\n",
 			cpu, mc_amd->hdr.patch_id);
 		return UCODE_ERROR;


