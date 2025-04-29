Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E89F215060;
	Tue, 29 Apr 2025 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945441; cv=none; b=R2nC6sBKBk3Rt+qWy4i98oKx5FeN3jrE1+hrf7AbTaO2UVFoLLXOK8AH8g4TUt2nq8pTjTNIYXBzh1pV3y+CvgLatjlGYSiaaluBN8bzQ2jZNjSy0hT69+kPeaNL18ffkBRoef9DW4qRnQk5zCcUhe8qutfSbJxQLM99tLxO7VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945441; c=relaxed/simple;
	bh=VpkalxLZsGgvIMANy0Q5UGoBRz+a4Gsq6/zpQXVrI+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcHVM3Phfgt43QsfC4oC1y2iDbeZ4WNZ56R0AJ/pc++zI/vEwL4cCA5+ozq9HnzHUfvVOcvmZ7zn578qB8j6b/iDQL+QV8O/l8ae1KpLilyXH+Pf7gjZjyXky9ZWTneCLZYCI98iecks+oCRm4WmKKk3G9eWxF8fhtNQjp7n8ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFL7OTgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFL7OTgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB445C4CEE3;
	Tue, 29 Apr 2025 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945441;
	bh=VpkalxLZsGgvIMANy0Q5UGoBRz+a4Gsq6/zpQXVrI+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFL7OTgM9Et6A5jiwZU7j0rw+fdEsGslnQ3QShmiQlv+jZEMRqcLcofOciaoWoxW3
	 wsmz3ETYdxuZGerqDWhvucxb2UA5B0PE7VmYO/tZj4RGsxzlz0Ys0ZT2Sdcd3HZcma
	 q6J0QBhCspzipri6yOuwNt+oxm7zrlQZdRDtN5v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulneris <ndesaulniers@google.com>,
	Nathan Chancellor <natechancellor@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 113/179] powerpc/prom_init: Use -ffreestanding to avoid a reference to bcmp
Date: Tue, 29 Apr 2025 18:40:54 +0200
Message-ID: <20250429161053.978458168@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <natechancellor@gmail.com>

commit 8dcd71b45df34d9b903450fab147ee8c1e6c16b5 upstream.

LLVM revision r374662 gives LLVM the ability to convert certain loops
into a reference to bcmp as an optimization; this breaks
prom_init_check.sh:

    CALL    arch/powerpc/kernel/prom_init_check.sh
  Error: External symbol 'bcmp' referenced from prom_init.c
  make[2]: *** [arch/powerpc/kernel/Makefile:196: prom_init_check] Error 1

bcmp is defined in lib/string.c as a wrapper for memcmp so this could
be added to the whitelist. However, commit
450e7dd4001f ("powerpc/prom_init: don't use string functions from
lib/") copied memcmp as prom_memcmp to avoid KASAN instrumentation so
having bcmp be resolved to regular memcmp would break that assumption.
Furthermore, because the compiler is the one that inserted bcmp, we
cannot provide something like prom_bcmp.

To prevent LLVM from being clever with optimizations like this, use
-ffreestanding to tell LLVM we are not hosted so it is not free to
make transformations like this.

Reviewed-by: Nick Desaulneris <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191119045712.39633-4-natechancellor@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -21,6 +21,7 @@ CFLAGS_prom.o += $(DISABLE_LATENT_ENTROP
 
 CFLAGS_prom_init.o += $(call cc-option, -fno-stack-protector)
 CFLAGS_prom_init.o += -DDISABLE_BRANCH_PROFILING
+CFLAGS_prom_init.o += -ffreestanding
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace early boot code


