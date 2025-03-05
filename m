Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848F253B4E;
	Wed,  5 Mar 2025 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197791; cv=none; b=BEqYbBpHYWqfKQI5GM7VXCpIPubmolGmFumbqV0fTb4yzHYFuFgIAL/N8vkvkKm8tWBsHZOlSpSALcwF2GfRxxSDALB3nRbVZFKDobuIn0M40KTKWcyShA5YOly5t2L1cWS+3btwwelhBwRHf+/vCu2/IZsmV75AkWRwWWCvy8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197791; c=relaxed/simple;
	bh=K34JlZ6wg0sG+AUb7gDyEx+yIR2pe8baqwHOWGPY2nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFi1H9wAIO2ExC3AyfYZtYckuwCkch6xkLczmYmVzQ6gbkYwMyK5Lir4qqNW0OPfZk7qJFzM8DEccCVRsxZnbckKz0uuR/41XBkNxkV8utoPZlKF6ZjEa2E+WMcYNwfjf+eRUmEE2re605+7W2hQzw7vld3zkJ6uIkVcbSvnLxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEBz4lhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEBz4lhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F1FC4CEE0;
	Wed,  5 Mar 2025 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197791;
	bh=K34JlZ6wg0sG+AUb7gDyEx+yIR2pe8baqwHOWGPY2nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEBz4lhxXBmXHhrM2EB3klS0RCXCIXr2NlCSDQbluzpaMiHcNv6+i7+eooMFL87p/
	 MHcCBBfeWpjDMkLKFvuMJ48GnCSMzkVfoeoOBr7kvhNOR+fadw+MM8cFtBqxryDeLR
	 VCy/www0iPS/g/mCDh1r3FFdkVEWPlEJOjJCLP/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 100/142] x86/microcode/intel: Simplify and rename generic_load_microcode()
Date: Wed,  5 Mar 2025 18:48:39 +0100
Message-ID: <20250305174504.351482778@linuxfoundation.org>
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

commit 6b072022ab2e1e83b7588144ee0080f7197b71da upstream

so it becomes less obfuscated and rename it because there is nothing
generic about it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231002115902.330295409@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/intel.c |   47 ++++++++++++----------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -240,19 +240,6 @@ int intel_microcode_sanity_check(void *m
 }
 EXPORT_SYMBOL_GPL(intel_microcode_sanity_check);
 
-/*
- * Returns 1 if update has been found, 0 otherwise.
- */
-static int has_newer_microcode(void *mc, unsigned int csig, int cpf, int new_rev)
-{
-	struct microcode_header_intel *mc_hdr = mc;
-
-	if (mc_hdr->rev <= new_rev)
-		return 0;
-
-	return intel_find_matching_signature(mc, csig, cpf);
-}
-
 static void save_microcode_patch(void *data, unsigned int size)
 {
 	struct microcode_header_intel *p;
@@ -559,14 +546,12 @@ out:
 	return ret;
 }
 
-static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
+static enum ucode_state parse_microcode_blobs(int cpu, struct iov_iter *iter)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	unsigned int curr_mc_size = 0, new_mc_size = 0;
-	enum ucode_state ret = UCODE_OK;
-	int new_rev = uci->cpu_sig.rev;
+	int cur_rev = uci->cpu_sig.rev;
 	u8 *new_mc = NULL, *mc = NULL;
-	unsigned int csig, cpf;
 
 	while (iov_iter_count(iter)) {
 		struct microcode_header_intel mc_header;
@@ -583,6 +568,7 @@ static enum ucode_state generic_load_mic
 			pr_err("error! Bad data in microcode data file (totalsize too small)\n");
 			break;
 		}
+
 		data_size = mc_size - sizeof(mc_header);
 		if (data_size > iov_iter_count(iter)) {
 			pr_err("error! Bad data in microcode data file (truncated file?)\n");
@@ -605,16 +591,17 @@ static enum ucode_state generic_load_mic
 			break;
 		}
 
-		csig = uci->cpu_sig.sig;
-		cpf = uci->cpu_sig.pf;
-		if (has_newer_microcode(mc, csig, cpf, new_rev)) {
-			vfree(new_mc);
-			new_rev = mc_header.rev;
-			new_mc  = mc;
-			new_mc_size = mc_size;
-			mc = NULL;	/* trigger new vmalloc */
-			ret = UCODE_NEW;
-		}
+		if (cur_rev >= mc_header.rev)
+			continue;
+
+		if (!intel_find_matching_signature(mc, uci->cpu_sig.sig, uci->cpu_sig.pf))
+			continue;
+
+		vfree(new_mc);
+		cur_rev = mc_header.rev;
+		new_mc  = mc;
+		new_mc_size = mc_size;
+		mc = NULL;
 	}
 
 	vfree(mc);
@@ -634,9 +621,9 @@ static enum ucode_state generic_load_mic
 	save_microcode_patch(new_mc, new_mc_size);
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
-		 cpu, new_rev, uci->cpu_sig.rev);
+		 cpu, cur_rev, uci->cpu_sig.rev);
 
-	return ret;
+	return UCODE_NEW;
 }
 
 static bool is_blacklisted(unsigned int cpu)
@@ -685,7 +672,7 @@ static enum ucode_state request_microcod
 	kvec.iov_base = (void *)firmware->data;
 	kvec.iov_len = firmware->size;
 	iov_iter_kvec(&iter, ITER_SOURCE, &kvec, 1, firmware->size);
-	ret = generic_load_microcode(cpu, &iter);
+	ret = parse_microcode_blobs(cpu, &iter);
 
 	release_firmware(firmware);
 


