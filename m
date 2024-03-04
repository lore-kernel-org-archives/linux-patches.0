Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1A21EB5A;
	Mon,  4 Mar 2024 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588832; cv=none; b=eHb6qiACDMOc2RV71CuYySmk240nHxepmEXMeTMyJOkAPg3v4WVifGnuMdwDzlkTy35/TFnXd7bZSAQBf39SWVScEyJC5EpqtgUp/ZPM6eWDBQ2Mr4Ap11Oi0daE5q+dBYX4EqOFjEWyonw/eDw8i6s0by5OSej/6pzjnWeagfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588832; c=relaxed/simple;
	bh=yJSw6hQen/TH8atuJYcPDq7Sh5/EW1CAG0nGC1DSo+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnvqsSy8EPuzB7/T/h+q4cSQTNWr8qU4IlogGHnUT18yEDx4W6OvLqP/ZAHqBGZt9475QuR+5KTtiXFDQSuaSFZXlPczIh6KWLAzqGoA/RYZiooemYCfSf3mv5m/L3pAlfvHanbpJo9erLanWulGtaGx5NQ77mu3HW75mXpVWa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZyP5imK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZyP5imK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2D9C433F1;
	Mon,  4 Mar 2024 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588831;
	bh=yJSw6hQen/TH8atuJYcPDq7Sh5/EW1CAG0nGC1DSo+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZyP5imK8CLmVCGTYqVS92yqJuNcVW7ZKyYDihYadlS5alPUVWDziqjr0c2NiPQ7O
	 LTs0UWpHmkbgPbh6DV5BVMPVg9n7CB+1Hw/fyJqIYg2hTSaz+oNTcecFCMxQf9HJUA
	 8Dzh97gElF0Nv4Lg/asLXR7bQ2YRPietdRwtaMuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 113/215] x86/boot/compressed: Move efi32_pe_entry into .text section
Date: Mon,  4 Mar 2024 21:22:56 +0000
Message-ID: <20240304211600.628138681@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 91592b5c0c2f076ff9d8cc0c14aa563448ac9fc4 upstream.

Move efi32_pe_entry() into the .text section, so that it can be moved
out of head_64.S and into a separate compilation unit in a subsequent
patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-5-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -786,7 +786,7 @@ SYM_DATA(efi_is64, .byte 1)
 #define BS32_handle_protocol	88 // offsetof(efi_boot_services_32_t, handle_protocol)
 #define LI32_image_base		32 // offsetof(efi_loaded_image_32_t, image_base)
 
-	__HEAD
+	.text
 	.code32
 SYM_FUNC_START(efi32_pe_entry)
 /*
@@ -808,12 +808,11 @@ SYM_FUNC_START(efi32_pe_entry)
 
 	call	1f
 1:	pop	%ebx
-	subl	$ rva(1b), %ebx
 
 	/* Get the loaded image protocol pointer from the image handle */
 	leal	-4(%ebp), %eax
 	pushl	%eax				// &loaded_image
-	leal	rva(loaded_image_proto)(%ebx), %eax
+	leal	(loaded_image_proto - 1b)(%ebx), %eax
 	pushl	%eax				// pass the GUID address
 	pushl	8(%ebp)				// pass the image handle
 
@@ -842,13 +841,13 @@ SYM_FUNC_START(efi32_pe_entry)
 	movl	12(%ebp), %edx			// sys_table
 	movl	-4(%ebp), %esi			// loaded_image
 	movl	LI32_image_base(%esi), %esi	// loaded_image->image_base
-	movl	%ebx, %ebp			// startup_32 for efi32_pe_stub_entry
+	leal	(startup_32 - 1b)(%ebx), %ebp	// runtime address of startup_32
 	/*
 	 * We need to set the image_offset variable here since startup_32() will
 	 * use it before we get to the 64-bit efi_pe_entry() in C code.
 	 */
-	subl	%esi, %ebx
-	movl	%ebx, rva(image_offset)(%ebp)	// save image_offset
+	subl	%esi, %ebp			// calculate image_offset
+	movl	%ebp, (image_offset - 1b)(%ebx)	// save image_offset
 	xorl	%esi, %esi
 	jmp	efi32_entry			// pass %ecx, %edx, %esi
 						// no other registers remain live


