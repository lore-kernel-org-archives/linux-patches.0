Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF383AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE07C4339B;
	Wed,  7 Jun 2023 20:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169337;
	bh=Va2pPca/0z+orAVU2OmFlX6nh9rnojWE9YcW0VkxqF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt0kozM4WVxRmb72g7s6upEIiw8M7IsAWrqrTu6CjxUm/44BHwoogxWvijGPHPoVZ
	 VXbe3TpzvXbsqLCZ3nS/KGcID9o9q6Meo+DhAh0RDV2ut2OuZDRUVjP6SfdLGDFrpo
	 iuF2vhdHIYS1ZfoLS+4zHW7L4On5NmqD3UT1sQDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akihiro Suda <suda.kyoto@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 043/286] efi: Bump stub image version for macOS HVF compatibility
Date: Wed,  7 Jun 2023 22:12:22 +0200
Message-ID: <20230607200924.447175481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiro Suda <suda.kyoto@gmail.com>

[ Upstream commit 36e4fc57fc1619f462e669e939209c45763bc8f5 ]

The macOS hypervisor framework includes a host-side VMM called
VZLinuxBootLoader [1] which implements native support for booting the
Linux kernel inside a guest directly (instead of, e.g., via GRUB
installed inside the guest). On x86, it incorporates a BIOS style loader
that does not implement or expose EFI to the loaded kernel. However,
this loader appears to fail when the 'image minor version' field in the
kernel image's PE/COFF header (which is generally only used by EFI based
bootloaders) is set to any value other than 0x0. [2]

Commit e346bebbd36b1576 ("efi: libstub: Always enable initrd command
line loader and bump version") incremented the EFI stub image minor
version to convey that all EFI stub kernels now implement support for
the initrd= command line option, and do so in a way where it can load
initrd images from any filesystem known to the EFI firmware (as opposed
to prior implementations that could only load initrds from the same
volume that the kernel image was loaded from).

Unfortunately, bumping the version to v1.1 triggers this issue in
VZLinuxBootLoader, breaking the boot on x86. So let's keep the image
minor version at 0x0, and bump the image major version instead.

While at it, convert this field to a bit field, so that individual
features are discoverable from it, as suggested by Linus. So let's bump
the major version to v3, and document the initrd= command line loading
feature as being represented by bit 1 in the mask.

Note that, due to the prior interpretation as a monotonically increasing
version field, loaders are still permitted to assume that the LoadFile2
initrd loading feature is supported for any major version value >= 1,
even if bit 0 is not set.

[1] https://developer.apple.com/documentation/virtualization/vzlinuxbootloader
[2] https://lore.kernel.org/linux-efi/CAG8fp8Teu4G9JuenQrqGndFt2Gy+V4YgJ=hN1xX7AD940YKf3A@mail.gmail.com/

Fixes: e346bebbd36b1576 ("efi: libstub: Always enable initrd command ...")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217485
Signed-off-by: Akihiro Suda <suda.kyoto@gmail.com>
[ardb: rewrite comment and commit log]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pe.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/pe.h b/include/linux/pe.h
index 6ffabf1e6d039..16754fb2f954a 100644
--- a/include/linux/pe.h
+++ b/include/linux/pe.h
@@ -11,25 +11,26 @@
 #include <linux/types.h>
 
 /*
- * Linux EFI stub v1.0 adds the following functionality:
- * - Loading initrd from the LINUX_EFI_INITRD_MEDIA_GUID device path,
- * - Loading/starting the kernel from firmware that targets a different
- *   machine type, via the entrypoint exposed in the .compat PE/COFF section.
+ * Starting from version v3.0, the major version field should be interpreted as
+ * a bit mask of features supported by the kernel's EFI stub:
+ * - 0x1: initrd loading from the LINUX_EFI_INITRD_MEDIA_GUID device path,
+ * - 0x2: initrd loading using the initrd= command line option, where the file
+ *        may be specified using device path notation, and is not required to
+ *        reside on the same volume as the loaded kernel image.
  *
  * The recommended way of loading and starting v1.0 or later kernels is to use
  * the LoadImage() and StartImage() EFI boot services, and expose the initrd
  * via the LINUX_EFI_INITRD_MEDIA_GUID device path.
  *
- * Versions older than v1.0 support initrd loading via the image load options
- * (using initrd=, limited to the volume from which the kernel itself was
- * loaded), or via arch specific means (bootparams, DT, etc).
+ * Versions older than v1.0 may support initrd loading via the image load
+ * options (using initrd=, limited to the volume from which the kernel itself
+ * was loaded), or only via arch specific means (bootparams, DT, etc).
  *
- * On x86, LoadImage() and StartImage() can be omitted if the EFI handover
- * protocol is implemented, which can be inferred from the version,
- * handover_offset and xloadflags fields in the bootparams structure.
+ * The minor version field must remain 0x0.
+ * (https://lore.kernel.org/all/efd6f2d4-547c-1378-1faa-53c044dbd297@gmail.com/)
  */
-#define LINUX_EFISTUB_MAJOR_VERSION		0x1
-#define LINUX_EFISTUB_MINOR_VERSION		0x1
+#define LINUX_EFISTUB_MAJOR_VERSION		0x3
+#define LINUX_EFISTUB_MINOR_VERSION		0x0
 
 /*
  * LINUX_PE_MAGIC appears at offset 0x38 into the MS-DOS header of EFI bootable
-- 
2.39.2



