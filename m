Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC221420BE;
	Tue, 23 Apr 2024 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908698; cv=none; b=d4D2f7KidJDPYAH1bfqyHIV+66F5KbfFfO77qIsYZkCLrY8pTj+97LCU/7dpP+7UXZol4/nLFg1agwpeDdaSdNnG2mYxHWRnKWtSfps8Hm52EDpRJPFqpYrQzpMPeRROWis+4cA5e1bA1vHNYQVfx/9g7bwpXjZaHTYjbPAZDJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908698; c=relaxed/simple;
	bh=Q6YwlQiH1NtgVKr6pCUIfHy+V+xwn/Sq6i+/WlI09OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWsVFRLMMIvc/9rivboDnsvYpO2q/oUaRloL4RsOtsyHLyjq2RpI2Yl3G0rKxKlmTFTkrEHvwQqFuzOf4eyvh5pFiKUJ9yhcJVcsELmHx+Q06fS+F0n/jqO64zn/6mSv3+ANujJE+cqI6GR7zXPsvIf50TRVD3OBe1hqCJ2eVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYv3cYZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYv3cYZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72143C4AF08;
	Tue, 23 Apr 2024 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908698;
	bh=Q6YwlQiH1NtgVKr6pCUIfHy+V+xwn/Sq6i+/WlI09OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYv3cYZ8RJO72K2jcFeofG638iqgPQRfJxwAUD8TvMYhCkw8LLYjlOrQpulXgKj94
	 3eDtQDYALHG0y/FOQFA1MPz5a+T2WsHCTk5tPmgvTVokOuRHzs09JucRSEbLcLNBFn
	 lqQ5R7RRCxsxbrCJk2Id3wGusMcLY/nZEWFqDomo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 025/141] x86/boot: Split off PE/COFF .data section
Date: Tue, 23 Apr 2024 14:38:13 -0700
Message-ID: <20240423213854.135827745@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

[ Commit 34951f3c28bdf6481d949a20413b2ce7693687b2 upstream ]

Describe the code and data of the decompressor binary using separate
.text and .data PE/COFF sections, so that we will be able to map them
using restricted permissions once we increase the section and file
alignment sufficiently. This avoids the need for memory mappings that
are writable and executable at the same time, which is something that
is best avoided for security reasons.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230915171623.655440-17-ardb@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/Makefile |    2 +-
 arch/x86/boot/header.S |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -91,7 +91,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vm
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi.._stub_entry\|efi\(32\)\?_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|_edata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [a-zA-Z] \(startup_32\|efi.._stub_entry\|efi\(32\)\?_pe_entry\|input_data\|kernel_info\|_end\|_ehead\|_text\|_e\?data\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -74,9 +74,9 @@ optional_header:
 	.byte	0x02				# MajorLinkerVersion
 	.byte	0x14				# MinorLinkerVersion
 
-	.long	setup_size + ZO__end - 0x200	# SizeOfCode
+	.long	ZO__data			# SizeOfCode
 
-	.long	0				# SizeOfInitializedData
+	.long	ZO__end - ZO__data		# SizeOfInitializedData
 	.long	0				# SizeOfUninitializedData
 
 	.long	setup_size + ZO_efi_pe_entry	# AddressOfEntryPoint
@@ -177,9 +177,9 @@ section_table:
 	.byte	0
 	.byte	0
 	.byte	0
-	.long	ZO__end
+	.long	ZO__data
 	.long	setup_size
-	.long	ZO__edata			# Size of initialized data
+	.long	ZO__data			# Size of initialized data
 						# on disk
 	.long	setup_size
 	.long	0				# PointerToRelocations
@@ -190,6 +190,17 @@ section_table:
 		IMAGE_SCN_MEM_READ		| \
 		IMAGE_SCN_MEM_EXECUTE		# Characteristics
 
+	.ascii	".data\0\0\0"
+	.long	ZO__end - ZO__data		# VirtualSize
+	.long	setup_size + ZO__data		# VirtualAddress
+	.long	ZO__edata - ZO__data		# SizeOfRawData
+	.long	setup_size + ZO__data		# PointerToRawData
+
+	.long	0, 0, 0
+	.long	IMAGE_SCN_CNT_INITIALIZED_DATA	| \
+		IMAGE_SCN_MEM_READ		| \
+		IMAGE_SCN_MEM_WRITE		# Characteristics
+
 	.set	section_count, (. - section_table) / 40
 #endif /* CONFIG_EFI_STUB */
 


