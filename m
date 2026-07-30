Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F2391836;
	Thu, 30 Jul 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424661; cv=none; b=cOFLAxwsmksjmYnUG5Dbk3iE+L9AvmuNXGxKtWzNkaX8eNkdvwVmTwPnnnm0i2jHFsyvxqVUUnl9fHdySN+QwXfCaYaLMLSMVqUTVrbvoM8E052kQ0vspSlJQnpVrDd299l8Qr0NF5XYGNWzvXRTJo45eoQgMfKxQNRQotlSY50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424661; c=relaxed/simple;
	bh=UE8Igc/FYfGfJ+UKC1OL+2SIY3EhZ4PCL8fJ2uVTGCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFZlFDgKrDF5R/aBysYg8vj+31TqhzflxHyQinSwcCI4r/ieuMqLYqTECUze6Ak++hF4NHn2fFpcRHcXfk60BtbH6B5cwNa8qhT0dgMH31euRCgiKHSBJtWfHS1ekqw6OS3ztHQoQAMfufy67lYaJafIE4n4vrvZ5IxvgNJYz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtPAfUD0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtPAfUD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037001F000E9;
	Thu, 30 Jul 2026 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424660;
	bh=b86MOsojk3MeiIocwDBAdlyVa1VV0C/c7b5rqMo89Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtPAfUD0CgZ25x0deTm7BuCm8G+p2N4xCIxLwO+hpWVZ027ZAw8s2oVUNDgjLCOJh
	 YxRb+dzsGu0o/YVhvWk3VgsZDJYK5FC0OnyerIthBu8cUpFOSZXMnliWsWe7no15zZ
	 3y9MwZ2Dy4+VFMe15NLgHTsdCWQxM/Z6jGgypfGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 473/675] LoongArch: Fix address space mismatch in kexec command line lookup
Date: Thu, 30 Jul 2026 16:13:23 +0200
Message-ID: <20260730141455.181656565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Guo <guodongtai@kylinos.cn>

commit 485ed44db5694d8d2e5027f63ad608e705286f30 upstream.

When searching the loaded segments for the "kexec" command line marker,
the kexec_load(2) path (file_mode == 0) passes the user-space segment
buffer straight to strncmp() through a bogus (char __user *) cast. This
dereferences a user pointer in kernel context, which is wrong and is
flagged by sparse:

  arch/loongarch/kernel/machine_kexec.c:84:51: sparse: incorrect type in
  argument 2 (different address spaces) @@ expected char const * @@ got
  char [noderef] __user *

Here copy the marker-sized prefix of each segment into a small on-stack
buffer with copy_from_user() before comparing, and skip segments that
fault. The subsequent copy_from_user() that stages the full command line
into the safe area is left unchanged.

Cc: stable@vger.kernel.org
Fixes: 4a03b2ac06a5 ("LoongArch: Add kexec support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605051639.aEPioXdD-lkp@intel.com/
Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -42,6 +42,7 @@ static unsigned long first_ind_entry;
 int machine_kexec_prepare(struct kimage *kimage)
 {
 	int i;
+	char head[8];
 	char *bootloader = "kexec";
 	void *cmdline_ptr = (void *)KEXEC_CMDLINE_ADDR;
 
@@ -59,7 +60,9 @@ int machine_kexec_prepare(struct kimage
 	} else {
 		/* Find the command line */
 		for (i = 0; i < kimage->nr_segments; i++) {
-			if (!strncmp(bootloader, (char __user *)kimage->segment[i].buf, strlen(bootloader))) {
+			if (copy_from_user(head, kimage->segment[i].buf, strlen(bootloader)))
+				continue;
+			if (!strncmp(bootloader, head, strlen(bootloader))) {
 				if (!copy_from_user(cmdline_ptr, kimage->segment[i].buf, COMMAND_LINE_SIZE))
 					kimage->arch.cmdline_ptr = (unsigned long)cmdline_ptr;
 				break;


