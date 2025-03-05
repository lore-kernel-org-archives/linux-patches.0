Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3CD25335F;
	Wed,  5 Mar 2025 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197788; cv=none; b=QmvFN/FAegm9UuV++hWeuhooKgfYwhKkD2w/sMJsv44x6wmPvGXlz0ULrO1llCnFgSEXd7lY0W3wwjZhwRubBjbwwHA2tuxiwLyfABl5Nuhprcnx8GfAOlQWuOPK7Eok1NamC5ARygbGt0jslK4PM+8ggTiuazNL4fNnQxNC1Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197788; c=relaxed/simple;
	bh=CPCyfmDtUjYUb7oJ+NAaXkCt0420waRCSB0T0BV35NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYONovxW6zM63RJCLv/RRtnZSLG+V62U9EtROu2Gq0D1faA5aGD8bb3KhL7ld3n0uVZ2/yUH5nkJPSWZnUiPXevIbhpCuSgGDgPhVjjfkVnq3Q18dhzrQa44W8PEjH+R3FtM7h3ElOlJ56BAXBnoWVlVqCE2NuTSkOcS9zb638Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhnQb7Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhnQb7Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5152FC4CED1;
	Wed,  5 Mar 2025 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197788;
	bh=CPCyfmDtUjYUb7oJ+NAaXkCt0420waRCSB0T0BV35NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhnQb7QfrmJZKMuTextn9DULGU87+OXaCtVB0oxcg8AAsD/JsTvLRG69wmkQdC+O5
	 Pf3wXspwWXqEbuO40e4wc6SPLtJ9QuXayfTa5Ya8jwbGFOQltstTLdRdHQD6P53LLE
	 xfE3QsDlr3gb5GVL6WKU62NMSNeDjbzluXFOQX+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 099/142] x86/microcode/intel: Simplify scan_microcode()
Date: Wed,  5 Mar 2025 18:48:38 +0100
Message-ID: <20250305174504.312449416@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit b0f0bf5eef5fac6ba30b7cac15ca4cb01f8a6ca9 upstream

Make it readable and comprehensible.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115902.271940980@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -266,22 +266,16 @@ static void save_microcode_patch(void *d
 	intel_ucode_patch = (struct microcode_intel *)p;
 }
 
-/*
- * Get microcode matching with BSP's model. Only CPUs with the same model as
- * BSP can stay in the platform.
- */
-static struct microcode_intel *
-scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
+/* Scan CPIO for microcode matching the boot CPU's family, model, stepping */
+static struct microcode_intel *scan_microcode(void *data, size_t size,
+					      struct ucode_cpu_info *uci, bool save)
 {
 	struct microcode_header_intel *mc_header;
 	struct microcode_intel *patch = NULL;
 	u32 cur_rev = uci->cpu_sig.rev;
 	unsigned int mc_size;
 
-	while (size) {
-		if (size < sizeof(struct microcode_header_intel))
-			break;
-
+	for (; size >= sizeof(struct microcode_header_intel); size -= mc_size, data += mc_size) {
 		mc_header = (struct microcode_header_intel *)data;
 
 		mc_size = get_totalsize(mc_header);
@@ -289,27 +283,19 @@ scan_microcode(void *data, size_t size,
 		    intel_microcode_sanity_check(data, false, MC_HEADER_TYPE_MICROCODE) < 0)
 			break;
 
-		size -= mc_size;
-
-		if (!intel_find_matching_signature(data, uci->cpu_sig.sig,
-						   uci->cpu_sig.pf)) {
-			data += mc_size;
+		if (!intel_find_matching_signature(data, uci->cpu_sig.sig, uci->cpu_sig.pf))
 			continue;
-		}
 
 		/* BSP scan: Check whether there is newer microcode */
 		if (!save && cur_rev >= mc_header->rev)
-			goto next;
+			continue;
 
 		/* Save scan: Check whether there is newer or matching microcode */
 		if (save && cur_rev != mc_header->rev)
-			goto next;
+			continue;
 
 		patch = data;
 		cur_rev = mc_header->rev;
-
-next:
-		data += mc_size;
 	}
 
 	if (size)


