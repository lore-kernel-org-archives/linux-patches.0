Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD0C14F9C8;
	Tue, 20 Feb 2024 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464320; cv=none; b=hEeZI2wNuaGpekp8RUbSoJslcgycmwzjkjItgnbfpD0bhsYuX/+whbxMKuOzxTTnZXmOm6Zo4edKpm36pyZouOu03Y+5QeEy8ceqja/y1boBpGhuwROoM59+WImh5fj4YQB+CPuMk94WZSRGQyMPCe/KQTyry6FbY57ACE+IpXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464320; c=relaxed/simple;
	bh=mzhKRiKAIDQL7KV2RFZ/j17xjMsyNCCBlTqrnHclKp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEQJNuiqJ452BO7z+MH4tsrtQ0IVtfcLd5TscYtJcJ8r34htS7Motcfu84PKy05Kt1QSbC/5lJ6lcJb7OQkuBqw/0nakUfvCh7Ars5FBfHAvTbv8kLYRkl/odUQ+khlzzDMaEC83npwuvTpfFyC9fyxKs4wNvp0BqeGn4fVbkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wm5l5+MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wm5l5+MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CF9C433F1;
	Tue, 20 Feb 2024 21:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464320;
	bh=mzhKRiKAIDQL7KV2RFZ/j17xjMsyNCCBlTqrnHclKp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm5l5+MOos1mIuhR0mnBQ+Hr3XgG8JadfjHca/Z71WVkkKtqnBKvV7fweuFgC7Tom
	 boun6Re067I/0FTytjnlaY8qvvTKSIyGakwbdLEgIeit3VfV1uN5hcHSqwc7Pc2Jl3
	 FJ7z7zTfubXZcbmB8FV4oaqcciq30HMrOU3IGvYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 321/331] x86/boot: Drop redundant code setting the root device
Date: Tue, 20 Feb 2024 21:57:17 +0100
Message-ID: <20240220205648.308398459@linuxfoundation.org>
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

commit 7448e8e5d15a3c4df649bf6d6d460f78396f7e1e upstream.

The root device defaults to 0,0 and is no longer configurable at build
time [0], so there is no need for the build tool to ever write to this
field.

[0] 079f85e624189292 ("x86, build: Do not set the root_dev field in bzImage")

This change has no impact on the resulting bzImage binary.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230912090051.4014114-23-ardb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/header.S      |    2 +-
 arch/x86/boot/tools/build.c |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -236,7 +236,7 @@ root_flags:	.word ROOT_RDONLY
 syssize:	.long 0			/* Filled in by build.c */
 ram_size:	.word 0			/* Obsolete */
 vid_mode:	.word SVGA_MODE
-root_dev:	.word 0			/* Filled in by build.c */
+root_dev:	.word 0			/* Default to major/minor 0/0 */
 boot_flag:	.word 0xAA55
 
 	# offset 512, entry point
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -40,10 +40,6 @@ typedef unsigned char  u8;
 typedef unsigned short u16;
 typedef unsigned int   u32;
 
-#define DEFAULT_MAJOR_ROOT 0
-#define DEFAULT_MINOR_ROOT 0
-#define DEFAULT_ROOT_DEV (DEFAULT_MAJOR_ROOT << 8 | DEFAULT_MINOR_ROOT)
-
 /* Minimal number of setup sectors */
 #define SETUP_SECT_MIN 5
 #define SETUP_SECT_MAX 64
@@ -399,9 +395,6 @@ int main(int argc, char ** argv)
 
 	update_pecoff_setup_and_reloc(i);
 
-	/* Set the default root device */
-	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
-
 	/* Open and stat the kernel file */
 	fd = open(argv[2], O_RDONLY);
 	if (fd < 0)


