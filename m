Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12532584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2986EC433EF;
	Thu, 23 Feb 2023 13:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157805;
	bh=aNuDsi64DQXSou422APszZ8LlYS5mmSYl2i1XbUlqUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCJ0+D/0gzYPTfpLSKticT5VbZ+j00ml+MwpOLryHv2661ljvzoASCd+F7/UhUMsF
	 2Hjkoxuj1d3x4hNI8qnQU22sa8h80LCpcRHgYC6xFjMWVg1NPhuE5Zo957YMHejGyt
	 nZ9G31xLoVFL6Cg+akltJ+VFbb5GVnAXGrQgVH3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 46/46] randstruct: disable Clang 15 support
Date: Thu, 23 Feb 2023 14:06:53 +0100
Message-Id: <20230223130433.725408323@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 78f7a3fd6dc66cb788c21d7705977ed13c879351 upstream.

The randstruct support released in Clang 15 is unsafe to use due to a
bug that can cause miscompilations: "-frandomize-layout-seed
inconsistently randomizes all-function-pointers structs"
(https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
on the Clang 16 release branch, so add a Clang version check.

Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Bill Wendling <morbo@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230208065133.220589-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/Kconfig.hardening |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -281,6 +281,9 @@ endmenu
 
 config CC_HAS_RANDSTRUCT
 	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
+	# Randstruct was first added in Clang 15, but it isn't safe to use until
+	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
 
 choice
 	prompt "Randomize layout of sensitive kernel structures"


