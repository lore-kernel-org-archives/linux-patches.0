Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779481A3176;
	Wed,  5 Mar 2025 18:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197876; cv=none; b=THieDDmF5W5lNlspqk2yp010adbC4T9LeZVCcAd5Tb5Fug2a7FV8KOxLiscr/zwAWWUbybnbLFAtA2RDobBAnPIY5TjqRFwVPKfO1rZytZcgkBwYBhIdg3mkwrmiAS02H3XA/cudNm4dlLQ04ZSLu/SQrGVLvFNlDOAB6rW8GlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197876; c=relaxed/simple;
	bh=VAw4DXgyx6tHyDyX+0KR7MnMPnTGFZ/nh82mKjQy2hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwGiQeT9XxO5YI25cLmk5OHiGSSG3sww3N/coGfB5tCPy7l8ZyJkk7E1pw6nHO7QGrFmL7Azk5/PifgH24S9k/FEjP0XXsM3BmS3MEk2yvJ3ArnfSAi7/RF02i8/1NMJ4wrHwDzzHZbrVwoY64Ymb1VNQfX1HoSSkZDP2h0UWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR4ICIPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR4ICIPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1443C4CED1;
	Wed,  5 Mar 2025 18:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197876;
	bh=VAw4DXgyx6tHyDyX+0KR7MnMPnTGFZ/nh82mKjQy2hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR4ICIPAsP8wtLKvYMmTmMRlcu3YisfyqPcZ7bN2S7MzXVSHp6BHdVc82fxRXu9zf
	 XDqkSZ8myPp7DUOFCRItPtN2iQyVXiXgvFD2wQeCp/WNU/aaON7dAJunyHk9w6BLOG
	 DWgwbWVvya4WwUhglOEkZrkaTjEn/Y1dEspPy/tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashok Raj <ashok.raj@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 130/142] x86/microcode/intel: Set new revision only after a successful update
Date: Wed,  5 Mar 2025 18:49:09 +0100
Message-ID: <20250305174505.558543585@linuxfoundation.org>
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

commit 9c21ea53e6bd1104c637b80a0688040f184cc761 upstream

This was meant to be done only when early microcode got updated
successfully. Move it into the if-branch.

Also, make sure the current revision is read unconditionally and only
once.

Fixes: 080990aa3344 ("x86/microcode: Rework early revisions reporting")
Reported-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Ashok Raj <ashok.raj@intel.com>
Link: https://lore.kernel.org/r/ZWjVt5dNRjbcvlzR@a4bf019067fa.jf.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -370,14 +370,14 @@ static __init struct microcode_intel *ge
 {
 	struct cpio_data cp;
 
+	intel_collect_cpu_info(&uci->cpu_sig);
+
 	if (!load_builtin_intel_microcode(&cp))
 		cp = find_microcode_in_initrd(ucode_path);
 
 	if (!(cp.data && cp.size))
 		return NULL;
 
-	intel_collect_cpu_info(&uci->cpu_sig);
-
 	return scan_microcode(cp.data, cp.size, uci, save);
 }
 
@@ -410,13 +410,13 @@ void __init load_ucode_intel_bsp(struct
 {
 	struct ucode_cpu_info uci;
 
-	ed->old_rev = intel_get_microcode_revision();
-
 	uci.mc = get_microcode_blob(&uci, false);
-	if (uci.mc && apply_microcode_early(&uci) == UCODE_UPDATED)
-		ucode_patch_va = UCODE_BSP_LOADED;
+	ed->old_rev = uci.cpu_sig.rev;
 
-	ed->new_rev = uci.cpu_sig.rev;
+	if (uci.mc && apply_microcode_early(&uci) == UCODE_UPDATED) {
+		ucode_patch_va = UCODE_BSP_LOADED;
+		ed->new_rev = uci.cpu_sig.rev;
+	}
 }
 
 void load_ucode_intel_ap(void)


