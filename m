Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C07378B61;
	Tue, 27 Feb 2024 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043202; cv=none; b=YTUcQpn4NjM/1pMkGBbs33uM2ygCtiv7v44rBLckB+4eKdNwEkd8tESZcvc1JjemkEyO+7PZ4xnJgx4kwcEmHuNL12lQsR6gAzRu2Bxhl6uwtHpPeGygSEUS1ie4DYBwrL7RkXFyVsPVsciqLyrmi4OubruNulle/vNaqkrQCKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043202; c=relaxed/simple;
	bh=RkkeFGxE44mfSTWi/PhWy3JCexcBOC9nll9Zqt+H1rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6PMN63whNDhBVeJQ0XANpDaa/p/OzFlckJoiUSHzU03cE8x3XmvV9HjDtYHX/RnmaedvqpKRlPfmnXpWFsQnLqcVncJ7J6WIxX83KL76mv7HRYHk+VuAEbX2ZFtpo9MgA7YDQEvn3KjjPaHhSYXktDsHJIDR6WuIAFlgOw5NVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuIETrqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuIETrqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15219C433F1;
	Tue, 27 Feb 2024 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043202;
	bh=RkkeFGxE44mfSTWi/PhWy3JCexcBOC9nll9Zqt+H1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuIETrqJCqqha1ci1vLghdMoYKqakoxzuGrSkRki8aDcA+A2fqn6YjEIyFrJ9iIf2
	 ArXfQoaA8y5wVuhNSk4nYfAaeHMpqUBzyuO7DtEj+VUmpujdZpbOPoh7m46KxUugEJ
	 gnZOGp43Kc0hD8YNsmTLW/Cy4RqJ1Oq5IAwi35WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 007/195] riscv/efistub: Ensure GP-relative addressing is not used
Date: Tue, 27 Feb 2024 14:24:28 +0100
Message-ID: <20240227131610.647407373@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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
@@ -25,7 +25,7 @@ cflags-$(CONFIG_ARM)		:= $(subst $(CC_FL
 				   -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
 cflags-$(CONFIG_RISCV)		:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
-				   -fpic
+				   -fpic -mno-relax
 cflags-$(CONFIG_LOONGARCH)	:= $(subst $(CC_FLAGS_FTRACE),,$(KBUILD_CFLAGS)) \
 				   -fpie
 


