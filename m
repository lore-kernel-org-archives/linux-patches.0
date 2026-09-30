Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DFF4FDE64;
	Wed, 30 Sep 2026 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788570; cv=none; b=UR1E1LL6WTcgBlUCIZqkY7y3HQTeywN656+fA7Xv+jxvJO7yx7GaStF3gIlCGGp3O6l8xb67k6YbNUQPl6Tc9X/BLZ7z5qiGmuL8ZI97mQyOhUARVpxm4FPAsSxKCX/cArOTboBr7tOGbt+P19PLyavajVv5qrQDf7KXIwNvV/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788570; c=relaxed/simple;
	bh=AkLAmypDI7/TeOF8pgAO8icU9hSfdPNuuDJN2p0JQHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StWnrbzKB0DYzn+1nXA6EfTPkf/byplSb2HZ0qOiVaII18HJakqUoAVcHt2cUdCBFCwAXsvqgteEWItWq+qEthC7FADArax8AmPgNizeRMzDINYYM2H7Yuj+moiFBhsa0IMGa6ftG7mX+wdD8+j26gHoSLm5OWiXo2jlAFvbeHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVe57DFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVe57DFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DE61F000FF;
	Wed, 30 Sep 2026 17:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788569;
	bh=VlhBeQ0mof8/Lr6NrrbNt11nZpS3wMBZ6lGst6iP5o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVe57DFyUmEMS/EHRu2yrbSCojw3KHlivfQENmK+3IgkrjDKI5uqR7o/cnSQdHQVg
	 hZLdiirzH380mj+25sHTrNVLx/a0Aq49LIaZIjT8XEuomgxvKRIAoJn4GqM8USedMc
	 Svcv9F/ifZ0I6jsL33pqy5xMmkiNqcOb7lCZtxyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.12 172/877] x86/microcode/intel: Reject problematic loading on Granite Rapids systems
Date: Wed, 30 Sep 2026 17:18:03 +0200
Message-ID: <20260930152418.438683083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -257,6 +257,26 @@ static void save_microcode_patch(struct
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
@@ -278,6 +298,9 @@ static __init struct microcode_intel *sc
 		if (!intel_find_matching_signature(data, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header->rev))
+			continue;
+
 		/*
 		 * For saving the early microcode, find the matching revision which
 		 * was loaded on the BSP.
@@ -540,6 +563,9 @@ static enum ucode_state parse_microcode_
 		if (!intel_find_matching_signature(mc, &uci->cpu_sig))
 			continue;
 
+		if (!revision_is_safe(&uci->cpu_sig, mc_header.rev))
+			continue;
+
 		is_safe = ucode_validate_minrev(&mc_header);
 		if (force_minrev && !is_safe)
 			continue;


