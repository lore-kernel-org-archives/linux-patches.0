Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0781E1C5D4E;
	Wed,  5 Mar 2025 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198378; cv=none; b=a2eQfuvqiRIu+yTzeFnvMCOwex3rdxEuzHQRz+Xxn1/X29dHReIsV6Va+T8VgVvqBVo5+qXdp+DCVQSxg3npJbQuE7E4nHvoHFtkBOGZ3I2BnGLoRg7vuGs6cIcg4dtXiX2UD5zYSkMn58+af3xwZUFIoWVKSEev6rNnZnLqnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198378; c=relaxed/simple;
	bh=C01tfapc2Y75b0WeR+s+8+z9L3UQeM2oxSm07EW8lwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9/SSs4JoWxZm6lHfc3gSGSecBhzj60XtJ+g8DyZ18cwiatXeHyKw3icUgxj54/kqKwAgJ+zenVkZnulVG6yTdcqJdiKnqSMlhAtP7D1BN2326D8A4oy0ii1NZVpxtwYBjfB75ibkXRamYvBo2SNvXdiSrOJl/gP4unsWUUmL1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHwiqrPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHwiqrPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B9EC4CEE2;
	Wed,  5 Mar 2025 18:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198377;
	bh=C01tfapc2Y75b0WeR+s+8+z9L3UQeM2oxSm07EW8lwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHwiqrPknjMHx6R75yUzhYRQ7TgBV6cQn9N4J6wX/C/y/ueB3yRTGvuLlUP6qZsZ7
	 JYF+9a0o0F14CVl7SntmpyXqeeDx1SEDcTKuE2hBE7pUL+2puR5Rfd1amCWEUSIU2U
	 nRX3NHB62hkVV1kZ9Y7FgKKlReI3kh7kzlBH7tZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 144/150] x86/microcode/AMD: Have __apply_microcode_amd() return bool
Date: Wed,  5 Mar 2025 18:49:33 +0100
Message-ID: <20250305174509.600535852@linuxfoundation.org>
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


