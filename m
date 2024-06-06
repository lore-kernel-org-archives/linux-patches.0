Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F5F196C7D;
	Thu,  6 Jun 2024 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683094; cv=none; b=fi6KWIzHx2R78sC9rWi/zlz+8suMp7zd/rgU3dXoe4pmkr7t55/GVFJtztGDcq9K+lrLvKqI0BnOCK+uDIWrXHBupeemmBeP0cVC+57QLzoQIDPcf9sS33/IArunBvoTiL2PU4mNGQoySJW8bqt3YHOZtJvGlQ9gUPTgLO+wnaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683094; c=relaxed/simple;
	bh=PsWuirowDps1Qr/UBoErmZqi4cNJNq5yYh7sN2IeRfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXtcdyhlFI3WIVusmt2HH9PG21ShuGaP043PtX+lxZD6FkM0yZITxkamv7TkndSGvOZkmiydVorviJaKaldNR0Fapbxv/YdHkiAxcexG7O21ETMUQdfIUCzbqlhegfNMCzFGW92AdNJWtMqLPAA/Qupz95O0vyuwGLkqfI/RZE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v85NZbFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v85NZbFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6E9C2BD10;
	Thu,  6 Jun 2024 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683094;
	bh=PsWuirowDps1Qr/UBoErmZqi4cNJNq5yYh7sN2IeRfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v85NZbFVvQXUbw0C/7Fl0VxNGH9wVGe676mkvIh9WOtm9/LQhtvwwNZ+QY2QvIJAn
	 Xt1xMzJhUKX8OAr3L6CTzrjPqBM1/UoxJwxCYvatfJyJUYX8KPGcC1K8GZbsOEHmTY
	 NO1+Rwo1cUIJK5vsGM47vYQtr47bgfRG1T0SQd9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chaney <bchaney@akamai.com>,
	Kees Cook <keescook@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.9 366/374] x86/efistub: Omit physical KASLR when memory reservations exist
Date: Thu,  6 Jun 2024 16:05:45 +0200
Message-ID: <20240606131704.136586145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -776,6 +776,26 @@ static void error(char *str)
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
@@ -807,6 +827,10 @@ static efi_status_t efi_decompress_kerne
 		    !memcmp(efistub_fw_vendor(), ami, sizeof(ami))) {
 			efi_debug("AMI firmware v2.0 or older detected - disabling physical KASLR\n");
 			seed[0] = 0;
+		} else if (cmdline_memmap_override) {
+			efi_info("%s detected on the kernel command line - disabling physical KASLR\n",
+				 cmdline_memmap_override);
+			seed[0] = 0;
 		}
 
 		boot_params_ptr->hdr.loadflags |= KASLR_FLAG;
@@ -883,7 +907,7 @@ void __noreturn efi_stub_entry(efi_handl
 	}
 
 #ifdef CONFIG_CMDLINE_BOOL
-	status = efi_parse_options(CONFIG_CMDLINE);
+	status = parse_options(CONFIG_CMDLINE);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to parse options\n");
 		goto fail;
@@ -892,7 +916,7 @@ void __noreturn efi_stub_entry(efi_handl
 	if (!IS_ENABLED(CONFIG_CMDLINE_OVERRIDE)) {
 		unsigned long cmdline_paddr = ((u64)hdr->cmd_line_ptr |
 					       ((u64)boot_params->ext_cmd_line_ptr << 32));
-		status = efi_parse_options((char *)cmdline_paddr);
+		status = parse_options((char *)cmdline_paddr);
 		if (status != EFI_SUCCESS) {
 			efi_err("Failed to parse options\n");
 			goto fail;


