Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE198612D7;
	Tue, 20 Feb 2024 21:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465255; cv=none; b=k0sJgVdGX52GWP6WQRlCTub1qE2pXidJ6CYWGOCTDiztwFlVETSm78k01wIsPJYnbM9EkBM08SoIhVScKdW18yfGKKAscjZdmMbD8sM2JU+OKCbkTf/GMMmaGYXC7LrCp21k4+GjUeavX5e2/8KLQ5kQ7ukN4KFkBk+Fv5AEl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465255; c=relaxed/simple;
	bh=/HwEm60A63PIL141jsOG1Lbd741Su1RPqxdR9DjKK44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV/TWHdKgeoU108kz84wY52aNas89UPnOVlelixVuNih/XonI2qB9h3vrJJrDY8IQdPy3qJGquDHf6xk7JtYPD0OWn861gpWPZiPVT6AdcSO8JPoX4PySaWiaqRU+/6M4LGfpx1hiWkEWd1ZX5euUWWNYY+GNyRKOCSoWkpE+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s46VO1ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s46VO1ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484CAC433F1;
	Tue, 20 Feb 2024 21:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465255;
	bh=/HwEm60A63PIL141jsOG1Lbd741Su1RPqxdR9DjKK44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s46VO1ZKNZs2ocQa3HfaVH2Jf5oL220DvRUk88jIhc6i+WdTAf/ivmyzsb2asW8Pj
	 1qBgIRxaFJGhSVGSKh4UWjlMAw7ofLfmD9YhIrZ9WYCmPAjbZKJYjISfnppyeUXRMh
	 socmjV6rhk+DUgdeaDhF3qZ7eSM4vTQELbiF2B7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.7 284/309] riscv/efistub: Ensure GP-relative addressing is not used
Date: Tue, 20 Feb 2024 21:57:23 +0100
Message-ID: <20240220205642.008137951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
-cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE
+cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
 cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt


