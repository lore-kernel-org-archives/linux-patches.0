Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBEF1F667C;
	Tue, 21 Jan 2025 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482239; cv=none; b=BS/SZ8fCSX4TOTg06QYJUW2OEc67I9gr7/KY1M0nJaEXCST/uIK7PVJqrUQ8zcnVvt2KQ3G4ALe6uG6/0Pz5p1AD5oREoN9EfrK8+l14aPpiAXgX7n3ts4N3wDDpb/G8tHGw9Adr7c2q8tTcO5FgFR3XrTQCosGmEaw9THxSR+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482239; c=relaxed/simple;
	bh=n/28BHZlRDKBVmIUgq1vc8/tLxo+VcUKXSB5jFTfJF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnKMbwGE58U0DImL7dbPHTn8tf37WYXl+eXW+EHCqIBOsBzq7TrulYwSHvP0QPee6kAzxYEbaTXw2VcJwBaVqmKJNhU7k1NxkNuEwe39XRLAzNnc+Rd99jDAHvMUNvs/qOH+85/zprF+U7KXKVSyJME2WvBpH5lF5TX3Ojbe0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL/7eZGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL/7eZGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C56C4CEE1;
	Tue, 21 Jan 2025 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482239;
	bh=n/28BHZlRDKBVmIUgq1vc8/tLxo+VcUKXSB5jFTfJF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL/7eZGsKCyDP9GczEqPO6APuyi7PBacvlTEy1zhDXE7zi400KAdtDxISC6BY77kl
	 0dJ8qJvibcFL7Q/2fquMLO0pTerDefUUClEyCEezV42qK6PHiSaNomeluzUDRSCrdV
	 SyUjFaZeoXGuol7r3eXGXoBZvi17ZKpnOBK1pEX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 001/122] efi/zboot: Limit compression options to GZIP and ZSTD
Date: Tue, 21 Jan 2025 18:50:49 +0100
Message-ID: <20250121174533.049821905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 0b2c29fb68f8bf3e87a9d88404aa6fdd486223e5 upstream.

For historical reasons, the legacy decompressor code on various
architectures supports 7 different compression types for the compressed
kernel image.

EFI zboot is not a compression library museum, and so the options can be
limited to what is likely to be useful in practice:

- GZIP is tried and tested, and is still one of the fastest at
  decompression time, although the compression ratio is not very high;
  moreover, Fedora is already shipping EFI zboot kernels for arm64 that
  use GZIP, and QEMU implements direct support for it when booting a
  kernel without firmware loaded;

- ZSTD has a very high compression ratio (although not the highest), and
  is almost as fast as GZIP at decompression time.

Reducing the number of options makes it less of a hassle for other
consumers of the EFI zboot format (such as QEMU today, and kexec in the
future) to support it transparently without having to carry 7 different
decompression libraries.

Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/Kconfig                |    4 ----
 drivers/firmware/efi/libstub/Makefile.zboot |   18 ++++++------------
 2 files changed, 6 insertions(+), 16 deletions(-)

--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -76,10 +76,6 @@ config EFI_ZBOOT
 	bool "Enable the generic EFI decompressor"
 	depends on EFI_GENERIC_STUB && !ARM
 	select HAVE_KERNEL_GZIP
-	select HAVE_KERNEL_LZ4
-	select HAVE_KERNEL_LZMA
-	select HAVE_KERNEL_LZO
-	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_ZSTD
 	help
 	  Create the bootable image as an EFI application that carries the
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -12,22 +12,16 @@ quiet_cmd_copy_and_pad = PAD     $@
 $(obj)/vmlinux.bin: $(obj)/$(EFI_ZBOOT_PAYLOAD) FORCE
 	$(call if_changed,copy_and_pad)
 
-comp-type-$(CONFIG_KERNEL_GZIP)		:= gzip
-comp-type-$(CONFIG_KERNEL_LZ4)		:= lz4
-comp-type-$(CONFIG_KERNEL_LZMA)		:= lzma
-comp-type-$(CONFIG_KERNEL_LZO)		:= lzo
-comp-type-$(CONFIG_KERNEL_XZ)		:= xzkern
-comp-type-$(CONFIG_KERNEL_ZSTD)		:= zstd22
-
 # in GZIP, the appended le32 carrying the uncompressed size is part of the
 # format, but in other cases, we just append it at the end for convenience,
 # causing the original tools to complain when checking image integrity.
-# So disregard it when calculating the payload size in the zimage header.
-zboot-method-y                         := $(comp-type-y)_with_size
-zboot-size-len-y                       := 4
+comp-type-y				:= gzip
+zboot-method-y				:= gzip
+zboot-size-len-y			:= 0
 
-zboot-method-$(CONFIG_KERNEL_GZIP)     := gzip
-zboot-size-len-$(CONFIG_KERNEL_GZIP)   := 0
+comp-type-$(CONFIG_KERNEL_ZSTD)		:= zstd
+zboot-method-$(CONFIG_KERNEL_ZSTD)	:= zstd22_with_size
+zboot-size-len-$(CONFIG_KERNEL_ZSTD)	:= 4
 
 $(obj)/vmlinuz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,$(zboot-method-y))


