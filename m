Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038C1253326;
	Wed,  5 Mar 2025 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198796; cv=none; b=LzaZ21JCkEBS3GxsUKgFN+rn1zjK229ni0KjkPpSOBfBdiIFWY5cIislh4K7ju1P3VPI5ELrAdCrrOo6kqQidYi+AD7ukjdcW0hOT1UlU+nAOVFGjA+r5o793IPO+EpOJfQS622FuEYjvwmDm5k5WrDmokxJySeRLSStBdHrzZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198796; c=relaxed/simple;
	bh=XCw1gqzmm8pKWxsVcq+wF3Pf4MsXsob0dOVaDpvFmFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWgitHTozXRk+2Z1aDNbH6SHwvF+CEzRc5YhngAysn8YeSouOK/UcuFfjdlC2IWP4TAB67WmoORPRaV9dIIgoJsvmEhdVk0JtNajqBKKiOqrwJCF2lujhx9StgDxTCMJVWGGdTZbWRZUZYy1zxVGUxs6rNt3QBJ7fs5F8QZldjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hq/JABxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hq/JABxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7E5C4CED1;
	Wed,  5 Mar 2025 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198795;
	bh=XCw1gqzmm8pKWxsVcq+wF3Pf4MsXsob0dOVaDpvFmFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hq/JABxaTn7kMqkWDui8l0LyDKBuwBUraux38ZLOojazX8934m6f4LiKcFIQeHqqm
	 zLTkTUKeXlUjQpo/X4BisV/YgFswda3S86Y5oYAXsjPu6uTn+UOgFll4dLi5ANyIKP
	 KR3AGhQvPDu3y79NfvVtEa1bhyoduHR3yIXuLtJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.13 150/157] x86/microcode/AMD: Return bool from find_blobs_in_containers()
Date: Wed,  5 Mar 2025 18:49:46 +0100
Message-ID: <20250305174511.321198387@linuxfoundation.org>
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

From: Nikolay Borisov <nik.borisov@suse.com>

commit a85c08aaa665b5436d325f6d7138732a0e1315ce upstream.

Instead of open-coding the check for size/data move it inside the
function and make it return a boolean indicating whether data was found
or not.

No functional changes.

  [ bp: Write @ret in find_blobs_in_containers() only on success. ]

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241018155151.702350-2-nik.borisov@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -569,14 +569,19 @@ static bool get_builtin_microcode(struct
 	return false;
 }
 
-static void __init find_blobs_in_containers(struct cpio_data *ret)
+static bool __init find_blobs_in_containers(struct cpio_data *ret)
 {
 	struct cpio_data cp;
+	bool found;
 
 	if (!get_builtin_microcode(&cp))
 		cp = find_microcode_in_initrd(ucode_path);
 
-	*ret = cp;
+	found = cp.data && cp.size;
+	if (found)
+		*ret = cp;
+
+	return found;
 }
 
 void __init load_ucode_amd_bsp(struct early_load_data *ed, unsigned int cpuid_1_eax)
@@ -591,8 +596,7 @@ void __init load_ucode_amd_bsp(struct ea
 	/* Needed in load_microcode_amd() */
 	ucode_cpu_info[0].cpu_sig.sig = cpuid_1_eax;
 
-	find_blobs_in_containers(&cp);
-	if (!(cp.data && cp.size))
+	if (!find_blobs_in_containers(&cp))
 		return;
 
 	if (early_apply_microcode(ed->old_rev, cp.data, cp.size))
@@ -612,8 +616,7 @@ static int __init save_microcode_in_init
 	if (dis_ucode_ldr || c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10)
 		return 0;
 
-	find_blobs_in_containers(&cp);
-	if (!(cp.data && cp.size))
+	if (!find_blobs_in_containers(&cp))
 		return -EINVAL;
 
 	scan_containers(cp.data, cp.size, &desc);


