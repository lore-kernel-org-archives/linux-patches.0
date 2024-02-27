Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B613AA2F;
	Tue, 27 Feb 2024 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041671; cv=none; b=mhqUnh/Ngk0iWh5n1I1rZpVXP0SGRqfJNfu9vFSxR9mjD1tLFdR3uZRYtOf/+o7SHHBsYBNe0s/HLWM33qtR7M0oKQ5f3g5TZxsNP8x73p0srv2/fNgu4KoLQFTxFPTD+o+uMN8dpmlwm+1ai61DXRnfBAdysZ+lvUyt3UJY3w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041671; c=relaxed/simple;
	bh=7EuEz0rD4LU9fjQN54SgpS1VBBd2m0F/pnHxoZwTKCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ms4JcgqmeSlG72upVdMmW6pEJ8bYaJqCQNtTir8dQsmisd8024udM45F9fj6t0+UABkfnDgGIPwFYOW1yz97KkmNshywwiNQor46Ml9pXtFxLJf8SgrzZ9slDjzDPemEnp6aqOzODEo5einCPprLB+VTa7bkq2h+sb5Da/LETQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lA17ILcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lA17ILcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDA2C433C7;
	Tue, 27 Feb 2024 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041671;
	bh=7EuEz0rD4LU9fjQN54SgpS1VBBd2m0F/pnHxoZwTKCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lA17ILcWtImaWwfVgsr17gUZOBfaD6rPPFwuJlRj0PiQ9j/FdxXNRMc0zlmowYIb2
	 m3Mb78tMe/lizwOTR1fFpHSKKkcBw8ptOkZWNPH4hclw9bbptxIuY5HztX2H4Dt4nt
	 YQhCjXUdiAVZtnmEjKTp2qV6NPjnOjsChOhi/i1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 003/299] riscv/efistub: Ensure GP-relative addressing is not used
Date: Tue, 27 Feb 2024 14:21:54 +0100
Message-ID: <20240227131625.958837652@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Jan Kiszka <jan.kiszka@siemens.com>

commit afb2a4fb84555ef9e61061f6ea63ed7087b295d5 upstream.

The cflags for the RISC-V efistub were missing -mno-relax, thus were
under the risk that the compiler could use GP-relative addressing. That
happened for _edata with binutils-2.41 and kernel 6.1, causing the
relocation to fail due to an invalid kernel_size in handle_kernel_image.
It was not yet observed with newer versions, but that may just be luck.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -28,7 +28,7 @@ cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRL
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
 				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
-cflags-$(CONFIG_RISCV)		+= -fpic
+cflags-$(CONFIG_RISCV)		+= -fpic -mno-relax
 cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt


