Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1F1DDA0C;
	Tue,  8 Apr 2025 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109763; cv=none; b=pYs9aLTpVeLzoD6IzRQzuDLKUBYJXKEzjg61FW6nnWezc4DKrYDXglab2IMC3hYbgSbL2JjNhySscGcm0OANNyxQljjWsBoP5YzX0si6ogN6Ixo5c070lqTjVZ1m3r8mNObUmSdujMRGt2oTIBi5m511x+Iz3wTUxmfvMWHXa1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109763; c=relaxed/simple;
	bh=YsgehcfqK50m+D0Fm04iiXuyVC63aZpRyfqUG/rakQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qb52g0OuQbiTjLuVO3Aa64Zx83jTwTyg2pYYfr1wIWS5w8Ga3jI/FxB9Zia3w3zbxZca596cUjR7ZsG67yvcQZWTDUI8VH2BZPKNppHyTGDDWN3bjfUOegHL9iY5oe5WjeYj3CoFsa7p/fL2m2/xYOZdHqhLpbuYePyR1z2gOz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdtzH+1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdtzH+1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565C2C4CEE5;
	Tue,  8 Apr 2025 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109762;
	bh=YsgehcfqK50m+D0Fm04iiXuyVC63aZpRyfqUG/rakQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdtzH+1DlgVQwqf5vCed08+LZcF+5V3PXCdx1+Y0W3GgApDHgymUDY9vzQcl6kXsn
	 8+yPm9cODOokXI6ViIg4ghZ7XRrl7Jc5upSqqI1j9a1os2I7cWjOEBq62y5TJVifvW
	 eyeXoUsmJMHbw1XfrQW3i4IzwqgiGDKPlS1Lued4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Abdelkareem Abdelsaamad <kareemem@amazon.com>
Subject: [PATCH 5.10 006/227] x86/kexec: fix memory leak of elf header buffer
Date: Tue,  8 Apr 2025 12:46:24 +0200
Message-ID: <20250408104820.565104123@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

commit b3e34a47f98974d0844444c5121aaff123004e57 upstream.

This is reported by kmemleak detector:

unreferenced object 0xffffc900002a9000 (size 4096):
  comm "kexec", pid 14950, jiffies 4295110793 (age 373.951s)
  hex dump (first 32 bytes):
    7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  .ELF............
    04 00 3e 00 01 00 00 00 00 00 00 00 00 00 00 00  ..>.............
  backtrace:
    [<0000000016a8ef9f>] __vmalloc_node_range+0x101/0x170
    [<000000002b66b6c0>] __vmalloc_node+0xb4/0x160
    [<00000000ad40107d>] crash_prepare_elf64_headers+0x8e/0xcd0
    [<0000000019afff23>] crash_load_segments+0x260/0x470
    [<0000000019ebe95c>] bzImage64_load+0x814/0xad0
    [<0000000093e16b05>] arch_kexec_kernel_image_load+0x1be/0x2a0
    [<000000009ef2fc88>] kimage_file_alloc_init+0x2ec/0x5a0
    [<0000000038f5a97a>] __do_sys_kexec_file_load+0x28d/0x530
    [<0000000087c19992>] do_syscall_64+0x3b/0x90
    [<0000000066e063a4>] entry_SYSCALL_64_after_hwframe+0x44/0xae

In crash_prepare_elf64_headers(), a buffer is allocated via vmalloc() to
store elf headers.  While it's not freed back to system correctly when
kdump kernel is reloaded or unloaded.  Then memory leak is caused.  Fix it
by introducing x86 specific function arch_kimage_file_post_load_cleanup(),
and freeing the buffer there.

And also remove the incorrect elf header buffer freeing code.  Before
calling arch specific kexec_file loading function, the image instance has
been initialized.  So 'image->elf_headers' must be NULL.  It doesn't make
sense to free the elf header buffer in the place.

Three different people have reported three bugs about the memory leak on
x86_64 inside Redhat.

Link: https://lkml.kernel.org/r/20220223113225.63106-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Conflict due to 179350f00e06 ("x86: Use ELF fields defined in 'struct
  kimage'") not in the tree ]
Signed-off-by: Abdelkareem Abdelsaamad <kareemem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/machine_kexec_64.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -402,9 +402,6 @@ void machine_kexec(struct kimage *image)
 #ifdef CONFIG_KEXEC_FILE
 void *arch_kexec_kernel_image_load(struct kimage *image)
 {
-	vfree(image->arch.elf_headers);
-	image->arch.elf_headers = NULL;
-
 	if (!image->fops || !image->fops->load)
 		return ERR_PTR(-ENOEXEC);
 
@@ -540,6 +537,15 @@ overflow:
 	       (int)ELF64_R_TYPE(rel[i].r_info), value);
 	return -ENOEXEC;
 }
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	vfree(image->arch.elf_headers);
+	image->arch.elf_headers = NULL;
+	image->arch.elf_headers_sz = 0;
+
+	return kexec_image_post_load_cleanup_default(image);
+}
 #endif /* CONFIG_KEXEC_FILE */
 
 static int


