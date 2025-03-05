Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB0146588;
	Wed,  5 Mar 2025 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198337; cv=none; b=cM7O1u5tSCgPKhjnnZbH0WIqQpYroAjCID2yNWAFFYV+szhzJHVV4xYE4iOasyYFPU+IqvpCv/z4cCLzURUiJz2mt7/4pFikecdj6dXhnTWPhzojFFj7X92/wicw2T4HyLZDNbj8AGEyBNFtCgLJI6W/42+UzOmAoKQSbWCPRws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198337; c=relaxed/simple;
	bh=WZ9nsChepPJjl2IbaVb2bcZR3tew8yPa5JwbAXFexH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYt4lC/lvpEDdQpvC5NLug+JzF22Oqun8Nq3Az8WwamNTU6lRNobgJ3MXuwhbcANGzxJOeLVDfe/t7ucLj5ErIl/JluFxO2RVTMMKWT2grL4RgAJN1RyiECM0iHOwVfPXXsD4VBQYUxjFlxC6OCR2L7yIhCF+6+ZPBbwos3L4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnMZKHpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnMZKHpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11481C4CED1;
	Wed,  5 Mar 2025 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198337;
	bh=WZ9nsChepPJjl2IbaVb2bcZR3tew8yPa5JwbAXFexH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnMZKHpPW+91yE0G/JfLkd+wUvT0m8Z0JnW6HI4ZGGfJpCsb62120s3x5NxmYVPb6
	 T8Ref7h2Y1WQAcTfZ7LjgHXNwnrqCou0HyHEN6riTOugzJX3qrDT3nWhV49fEdSops
	 xfCLpPWCIxSqiV7KRmrVjulckN8/CKQgO5Gd4EZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 143/150] x86/microcode/AMD: Return bool from find_blobs_in_containers()
Date: Wed,  5 Mar 2025 18:49:32 +0100
Message-ID: <20250305174509.559883580@linuxfoundation.org>
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


