Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87D14A4E6;
	Tue, 20 Feb 2024 21:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464333; cv=none; b=nUPjR6iulFUbEwaG3wIamqV7xpAIPFF+i1FPm24hQ2FWhYFspSvhFcrn1aQlJiRIU1nmp6vWj/CUX4j7+HZc4AcbLxedP2PykQRSfMyopwntmjuFatVW731yxCJJXsSJ4TqZJL2e7I4W6Fvmyd6NLaMlR6aVD4Wg3nZeSQnphxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464333; c=relaxed/simple;
	bh=rV9PvKIJ5RFwthLBAlWMbkgpZ64WIYYycx4PntUxB38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuZj3XD2jYm62oyZR2KLHFjgtJTQfAiPoh1C7tKsW1d37YPBDKOpgFu9SOR6mRDwdcI4sEvz2E8BZW52oZ9hIReamKWmbRIkwaLt3PgsZQcuT5+m9Jk2Cn96QOk03NBMdlVFgDS+RIf8NKdEbBIEn+2LhbOh3fxV+SF6omVvF3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afrH1k4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afrH1k4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85DCC433C7;
	Tue, 20 Feb 2024 21:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464333;
	bh=rV9PvKIJ5RFwthLBAlWMbkgpZ64WIYYycx4PntUxB38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afrH1k4r8PR77fKboZaBF4iJBCmoo2PzcSGh+Ix8ESpD0ukWXk08o6lv9W/Ri9Bh+
	 nXc+7dN4TdQIfNgnEE1jiMtF0OucL3NW1DkHyjgrOR/AIXhke3jaR9adpsKV09mOfC
	 +LifU1qB3IGDn5Dp+VRhEp2HCl04uFlrcKsEYTPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 324/331] x86/boot: Set EFI handover offset directly in header asm
Date: Tue, 20 Feb 2024 21:57:20 +0100
Message-ID: <20240220205648.399417236@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit eac956345f99dda3d68f4ae6cf7b494105e54780 upstream.

The offsets of the EFI handover entrypoints are available to the
assembler when constructing the header, so there is no need to set them
from the build tool afterwards.

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-12-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |   18 +++++++++++++++++-
 arch/x86/boot/tools/build.c |   24 ------------------------
 2 files changed, 17 insertions(+), 25 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -524,8 +524,24 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR
 # define INIT_SIZE VO_INIT_SIZE
 #endif
 
+	.macro		__handover_offset
+#ifndef CONFIG_EFI_HANDOVER_PROTOCOL
+	.long		0
+#elif !defined(CONFIG_X86_64)
+	.long		ZO_efi32_stub_entry
+#else
+	/* Yes, this is really how we defined it :( */
+	.long		ZO_efi64_stub_entry - 0x200
+#ifdef CONFIG_EFI_MIXED
+	.if		ZO_efi32_stub_entry != ZO_efi64_stub_entry - 0x200
+	.error		"32-bit and 64-bit EFI entry points do not match"
+	.endif
+#endif
+#endif
+	.endm
+
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:	.long 0			# Filled in by build.c
+handover_offset:	__handover_offset
 kernel_info_offset:	.long ZO_kernel_info
 
 # End of setup header #####################################################
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -55,8 +55,6 @@ u8 buf[SETUP_SECT_MAX*512];
 #define PECOFF_COMPAT_RESERVE 0x0
 #endif
 
-static unsigned long efi32_stub_entry;
-static unsigned long efi64_stub_entry;
 static unsigned long efi_pe_entry;
 static unsigned long efi32_pe_entry;
 static unsigned long _end;
@@ -265,31 +263,12 @@ static void efi_stub_defaults(void)
 #endif
 }
 
-static void efi_stub_entry_update(void)
-{
-	unsigned long addr = efi32_stub_entry;
-
-#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
-#ifdef CONFIG_X86_64
-	/* Yes, this is really how we defined it :( */
-	addr = efi64_stub_entry - 0x200;
-#endif
-
-#ifdef CONFIG_EFI_MIXED
-	if (efi32_stub_entry != addr)
-		die("32-bit and 64-bit EFI entry points do not match\n");
-#endif
-#endif
-	put_unaligned_le32(addr, &buf[0x264]);
-}
-
 #else
 
 static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
 static inline void update_pecoff_text(unsigned int text_start,
 				      unsigned int file_sz) {}
 static inline void efi_stub_defaults(void) {}
-static inline void efi_stub_entry_update(void) {}
 
 static inline int reserve_pecoff_reloc_section(int c)
 {
@@ -332,8 +311,6 @@ static void parse_zoffset(char *fname)
 	p = (char *)buf;
 
 	while (p && *p) {
-		PARSE_ZOFS(p, efi32_stub_entry);
-		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, efi32_pe_entry);
 		PARSE_ZOFS(p, _end);
@@ -416,7 +393,6 @@ int main(int argc, char ** argv)
 
 	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
 
-	efi_stub_entry_update();
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)


