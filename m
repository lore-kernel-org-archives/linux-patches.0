Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518FE1E5B71;
	Mon, 23 Jun 2025 21:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714128; cv=none; b=lK4oT7d7n78cndMO4kMMSbhQX8R49yZk8E4PZN6owm3JkRROeDyJe/X1U48Ce/LvBUNZkSBjxf8KzV8GleaQY8CJeFzskXghjR7ok7LCJipCIa4Cmr+Z5CWblqwXAgGLZ3of36u1tFHv/Ph+eeHo6as/fRf9FQRSbG509N6FTTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714128; c=relaxed/simple;
	bh=0ZS06SFxjmXDVuMfsClmXcgNEEcXcaMvC1Q9+7woO1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TL566wKZQAFHFQ15zYDY/5+b9v2IB0+6tW7Gmsy6Bj1GL1ds+Q/f/mb1AaGPXiZ34wM1sIPIMmFS121sp0idIXnBIMjJvwISkwsqpQOj23UDA/ljda3uHsZB5uWwDbev6grtA9EkNgxWCC6CWNDpuIfl7ScF/boS2eYIkCpW7kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qe9ENvLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qe9ENvLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0338C4CEEA;
	Mon, 23 Jun 2025 21:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714128;
	bh=0ZS06SFxjmXDVuMfsClmXcgNEEcXcaMvC1Q9+7woO1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe9ENvLf2gsDZQ80+Uh0A3DSIFoRbYS06bwJygj8xSTkygvgw7AYco0LLLlQa0s7/
	 PX8v1kc6i4VCcyoUyQBe9VhrPdqoCWQTJttRt8IoHQSjSN1FKVQ58hHgKEx0oEMdAg
	 GAPeGxfS70/Hp60EXuwcGUWFYOpisap05Obk++Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 189/411] kbuild: userprogs: fix bitsize and target detection on clang
Date: Mon, 23 Jun 2025 15:05:33 +0200
Message-ID: <20250623130638.438265181@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1126,8 +1126,8 @@ LDFLAGS_vmlinux += --orphan-handling=war
 endif
 
 # Align the bit size of userspace programs with the kernel
-KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
-KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
+KBUILD_USERCFLAGS  += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
+KBUILD_USERLDFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS))
 
 # userspace programs are linked via the compiler, use the correct linker
 ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_LD_IS_LLD),yy)


