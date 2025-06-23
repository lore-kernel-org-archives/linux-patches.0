Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2552C9D;
	Mon, 23 Jun 2025 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713624; cv=none; b=GwfbZ7MV/aUqgBXiVKdhCL5sC74fH9zAkTCeN9sc6hParF3c0bPyReWYozPxYZA6e9sMEuSI2RJj5rrhnYM3ZW9M/v9T+etrkFO9n+3YJKswqcOM2xCKVBKkcgECqxUZQQ76N310eTyD0iCiyC+fdcu4JiJp23w/6tooG/8LFiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713624; c=relaxed/simple;
	bh=Pa9um4kH1tl6GwIbPwIG7R8S7KZeBDM/JKqf/4rZa2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxqWBeN3/65tFi+kOU7ZVn85IhzRFpV5nvRj/556i1+CDfOkRVUgJ+J+HXKFaUraAxVZRXWA/BtbeKq6e3sreEyw3aDTDl1D+1pVQTsMLv8Jc7bC98onEc72D06hShY9ZLA1Z2QRpwvlVjl7J0/Z3WmgPA4gbB1LApExJ39fKnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXLyoTsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXLyoTsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03AAC4CEEA;
	Mon, 23 Jun 2025 21:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713623;
	bh=Pa9um4kH1tl6GwIbPwIG7R8S7KZeBDM/JKqf/4rZa2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXLyoTslT3++p2czIkXRHqAPSLdy+Kd7P3rQBs8FMxGwWGandGhf4UsUgug1kzZhR
	 feZm03LVGTfGgDea+z/mLJjXKjiJocbjC/P1WSndYbG1qtViQYG4R4EXRScRRGg9O7
	 8uvyZF+eLiaIYHOHpy93bZUSSlyU0gmIrApdJ1lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 156/355] kbuild: userprogs: fix bitsize and target detection on clang
Date: Mon, 23 Jun 2025 15:05:57 +0200
Message-ID: <20250623130631.394699732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 1b71c2fb04e7a713abc6edde4a412416ff3158f2 upstream.

scripts/Makefile.clang was changed in the linked commit to move --target from
KBUILD_CFLAGS to KBUILD_CPPFLAGS, as that generally has a broader scope.
However that variable is not inspected by the userprogs logic,
breaking cross compilation on clang.

Use both variables to detect bitsize and target arguments for userprogs.

Fixes: feb843a469fb ("kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1033,8 +1033,8 @@ LDFLAGS_vmlinux += --orphan-handling=war
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
 ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)


