Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6656B81ADA;
	Tue,  3 Dec 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242385; cv=none; b=oj1RcmN34bR3zS7IsvlrMI3/SeuGlV+9XNmd68Mlmwm12As5cAQXAGiD26KJIILwitp6PkwH1UxwYFuLPbHYneoTq7DiDJxA/exNLnnugpBSugtsnEoSQ8ox7A6uMLBtyDmnSfv4GfJiUpEXj2nPPDN38n6umB8HOcGjsQQ5UMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242385; c=relaxed/simple;
	bh=z+i1Lhfma7exl5Hw5WDUyvghWTmnmQWbCdL/8yUWb/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTAS/tsBTgFHgVBPG5ZTSV0OrP3lio937vn/DDNV6INQKNeOeidEYh/UrKmvEBKJ3w7HSi/X4Zrc1kEItNHbuT8/I9CuiOcHrJifjkTEWMdkYxwZ0K5nDOI9AUl5SnKsO2deBQjuft1FUSPwznZ9QeEprya0j4V75369fC/u3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPRh2RJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPRh2RJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73661C4CECF;
	Tue,  3 Dec 2024 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242384;
	bh=z+i1Lhfma7exl5Hw5WDUyvghWTmnmQWbCdL/8yUWb/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPRh2RJs+eJJeXgjCLwPvG62NtsxLeRLMWu/FnOaufXHfSa0THYo3lglSgydANE7W
	 qAhYOz4URbm/4NtW7wi7zNLEGFJj78ByT3TpYD2qmryx8eevuZoA/UZOd23TrxOz+Z
	 F82dqNb7k3+uobqs2sI+TXCfCd2rZ5tj+2XvzcSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyong Sun <sunhaiyong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 655/826] LoongArch: Explicitly specify code model in Makefile
Date: Tue,  3 Dec 2024 15:46:22 +0100
Message-ID: <20241203144809.305758035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit e67e0eb6a98b261caf45048f9eb95fd7609289c0 upstream.

LoongArch's toolchain may change the default code model from normal to
medium. This is unnecessary for kernel, and generates some relocations
which cannot be handled by the module loader. So explicitly specify the
code model to normal in Makefile (for Rust 'normal' is 'small').

Cc: stable@vger.kernel.org
Tested-by: Haiyong Sun <sunhaiyong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -59,7 +59,7 @@ endif
 
 ifdef CONFIG_64BIT
 ld-emul			= $(64bit-emul)
-cflags-y		+= -mabi=lp64s
+cflags-y		+= -mabi=lp64s -mcmodel=normal
 endif
 
 cflags-y			+= -pipe $(CC_FLAGS_NO_FPU)
@@ -104,7 +104,7 @@ ifdef CONFIG_OBJTOOL
 KBUILD_CFLAGS			+= -fno-jump-tables
 endif
 
-KBUILD_RUSTFLAGS		+= --target=loongarch64-unknown-none-softfloat
+KBUILD_RUSTFLAGS		+= --target=loongarch64-unknown-none-softfloat -Ccode-model=small
 KBUILD_RUSTFLAGS_KERNEL		+= -Zdirect-access-external-data=yes
 KBUILD_RUSTFLAGS_MODULE		+= -Zdirect-access-external-data=no
 


