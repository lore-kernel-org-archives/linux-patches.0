Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088F6533580;
	Wed, 23 Sep 2026 14:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173562; cv=none; b=WXu36AszOZcjxzrFUYKumLhGAbQQ1tYloLIXzD+VwSZuD/W63pQz6tWn1Lwb9C8muxIMnhzHHJv8+eCK0JjKGFbmmNv2bmIMCNvIViyeL17bSFXzt648oDrB02wsA4cIlMpY9pHuWeuj6LlGrIU5FGed7frEGaD0OO+xiKB4UZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173562; c=relaxed/simple;
	bh=MvLk6aRhnxK/CkBhp7TnMrQBCgdff+xjOo3hhtGiPNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMGx9EDYweacur4o8JBuaI0jrO95cepqdKPeWmIQbv59TlywWGC/AmPtky3xi9YAUazYfvxGk1VyKLcJX2u7vhb2uPJ7lDO75HYNfbUabLk+I4sWeSvvHGbc6esuXyXlvUb9ykjO+cMDWDAL4aa06zk+2zNjrvLXtpZOw1oHod0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOCX2n+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOCX2n+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427AA1F000FF;
	Wed, 23 Sep 2026 14:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173560;
	bh=CQKzUsoqaDtwAsNQMT8yOp6nN+NzD0TJ3o0+gPOWrM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOCX2n+1gv06Z9OhU4rgkwpsuVcQg8Z1ezOH4s25gliCgngiwCzbhFGCBYcKnjDrs
	 v/hbQwlMxskzmMT0/BeHoIDYyYpENS860iqtA3C9tldFdMiVs0j+H8ag4hrHUOlh6s
	 IyQw1Fyso+GEfmQpinWQEDb0IJRgiTfyZhvY6gm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 7.2 258/438] x86/microcode/intel: Reject problematic loading on Granite Rapids systems
Date: Wed, 23 Sep 2026 16:04:39 +0200
Message-ID: <20260923140651.463054955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Chang S. Bae <chang.seok.bae@intel.com>

commit e7d3e2f46dd5a69046e6d95a0f189155a5516b93 upstream.

Microcode updates can usually jump revisions. However, there is an erratum on
Granite Rapids systems. If they "jump over" revision 0x1000405, they result in
an #MC. Avoid it.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916225939.1144524-1-chang.seok.bae@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -345,6 +345,26 @@ static void save_microcode_patch(struct
 		pr_err("Unable to allocate microcode memory size: %u\n", size);
 }
 
+static bool revision_is_safe(struct cpu_signature *sig, u32 rev)
+{
+	u32 vfm = IFM(x86_family(sig->sig), x86_model(sig->sig));
+
+	/*
+	 * Erratum GNR98 can cause #MCs if "jumping over" revision 0x1000405.
+	 * Avoid the jumps.
+	 */
+	if (vfm == INTEL_GRANITERAPIDS_X &&
+	    x86_stepping(sig->sig) == 1 &&
+	    sig->pf & 0x95 &&
+	    sig->rev < 0x1000405 &&
+	    rev > 0x1000405) {
+		pr_err_once("Erratum GNR98: skipping revision 0x%x.\n", rev);
+		return false;
+	}
+
+	return true;
+}
+
 /* Scan blob for microcode matching the boot CPUs family, model, stepping */
 static __init struct microcode_intel *scan_microcode(void *data, size_t size,
 						     struct ucode_cpu_info *uci,
@@ -366,6 +386,9 @@ static __init struct microcode_intel *sc
 		if (!intel_find_matching_signature(data, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header->rev))
+			continue;
+
 		/*
 		 * For saving the early microcode, find the matching revision which
 		 * was loaded on the BSP.
@@ -914,6 +937,9 @@ static enum ucode_state parse_microcode_
 		if (!intel_find_matching_signature(mc, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header.rev))
+			continue;
+
 		is_safe = ucode_validate_minrev(&mc_header);
 		if (force_minrev && !is_safe)
 			continue;


