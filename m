Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD819753C;
	Thu,  6 Jun 2024 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683172; cv=none; b=qQStq9cGO/NQWJKAL8jK3UTfPnARuxnaHp7ryO5UhERMfAedJBoJ+zdY0Mf52T5bWpYt/WacevF6pTZZbMIoVDxDjlGs2SUoupO3VYfVK/Svkt7+FI/N2vRihgIqjNZMc3lFs/a4K8EeePONw03LtQd5AR6niBnVPKkzMo3ZjLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683172; c=relaxed/simple;
	bh=1UM61JJp+Xii0u2PxM5O8SY9Kblajv2VWqwY3fOEbFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eukb4WPWV0jpOTeHvIP1iSQx7iyv8PEWzgZqVFCyqqfjMdhQGhAxfGwW1/Ro+sC81kkKvf2/IPWz8KIIyz/eU55lghN1q5PwMx/ZVo94aAD11XHX9gu9FdRgjgcn36ebFqUPix20eZLDvJniroYwgmAKzCqGcy8MVx28fh1OT4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+9CQYJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+9CQYJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C968FC32786;
	Thu,  6 Jun 2024 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683171;
	bh=1UM61JJp+Xii0u2PxM5O8SY9Kblajv2VWqwY3fOEbFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+9CQYJKhU/g5rF0YElAyD/5gS5PbhBFg3D1tsGuO6Xn+8s9b2XSQUojIhkdZWbZR
	 C3fMZn0h4ZP2z54BXxNOfSmXKG12q+eZEqV5PKl461QYETze6kzmf0QpaG+Fn1OYuM
	 oahWInskt8wB7J1ybeB5sGZURbM/NPq6o/NIgvQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chaney <bchaney@akamai.com>,
	Kees Cook <keescook@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 047/473] x86/efistub: Omit physical KASLR when memory reservations exist
Date: Thu,  6 Jun 2024 15:59:36 +0200
Message-ID: <20240606131701.442284898@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

commit 15aa8fb852f995dd234a57f12dfb989044968bb6 upstream.

The legacy decompressor has elaborate logic to ensure that the
randomized physical placement of the decompressed kernel image does not
conflict with any memory reservations, including ones specified on the
command line using mem=, memmap=, efi_fake_mem= or hugepages=, which are
taken into account by the kernel proper at a later stage.

When booting in EFI mode, it is the firmware's job to ensure that the
chosen range does not conflict with any memory reservations that it
knows about, and this is trivially achieved by using the firmware's
memory allocation APIs.

That leaves reservations specified on the command line, though, which
the firmware knows nothing about, as these regions have no other special
significance to the platform. Since commit

  a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")

these reservations are not taken into account when randomizing the
physical placement, which may result in conflicts where the memory
cannot be reserved by the kernel proper because its own executable image
resides there.

To avoid having to duplicate or reuse the existing complicated logic,
disable physical KASLR entirely when such overrides are specified. These
are mostly diagnostic tools or niche features, and physical KASLR (as
opposed to virtual KASLR, which is much more important as it affects the
memory addresses observed by code executing in the kernel) is something
we can live without.

Closes: https://lkml.kernel.org/r/FA5F6719-8824-4B04-803E-82990E65E627%40akamai.com
Reported-by: Ben Chaney <bchaney@akamai.com>
Fixes: a1b87d54f4e4 ("x86/efistub: Avoid legacy decompressor when doing EFI boot")
Cc:  <stable@vger.kernel.org> # v6.1+
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/x86-stub.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -736,6 +736,26 @@ static void error(char *str)
 	efi_warn("Decompression failed: %s\n", str);
 }
 
+static const char *cmdline_memmap_override;
+
+static efi_status_t parse_options(const char *cmdline)
+{
+	static const char opts[][14] = {
+		"mem=", "memmap=", "efi_fake_mem=", "hugepages="
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(opts); i++) {
+		const char *p = strstr(cmdline, opts[i]);
+
+		if (p == cmdline || (p > cmdline && isspace(p[-1]))) {
+			cmdline_memmap_override = opts[i];
+			break;
+		}
+	}
+
+	return efi_parse_options(cmdline);
+}
+
 static efi_status_t efi_decompress_kernel(unsigned long *kernel_entry)
 {
 	unsigned long virt_addr = LOAD_PHYSICAL_ADDR;
@@ -767,6 +787,10 @@ static efi_status_t efi_decompress_kerne
 		    !memcmp(efistub_fw_vendor(), ami, sizeof(ami))) {
 			efi_debug("AMI firmware v2.0 or older detected - disabling physical KASLR\n");
 			seed[0] = 0;
+		} else if (cmdline_memmap_override) {
+			efi_info("%s detected on the kernel command line - disabling physical KASLR\n",
+				 cmdline_memmap_override);
+			seed[0] = 0;
 		}
 
 		boot_params_ptr->hdr.loadflags |= KASLR_FLAG;
@@ -843,7 +867,7 @@ void __noreturn efi_stub_entry(efi_handl
 	}
 
 #ifdef CONFIG_CMDLINE_BOOL
-	status = efi_parse_options(CONFIG_CMDLINE);
+	status = parse_options(CONFIG_CMDLINE);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to parse options\n");
 		goto fail;
@@ -852,7 +876,7 @@ void __noreturn efi_stub_entry(efi_handl
 	if (!IS_ENABLED(CONFIG_CMDLINE_OVERRIDE)) {
 		unsigned long cmdline_paddr = ((u64)hdr->cmd_line_ptr |
 					       ((u64)boot_params->ext_cmd_line_ptr << 32));
-		status = efi_parse_options((char *)cmdline_paddr);
+		status = parse_options((char *)cmdline_paddr);
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to parse options\n");
 			goto fail;


