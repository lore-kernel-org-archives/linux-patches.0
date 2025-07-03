Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4C2E62CD;
	Thu,  3 Jul 2025 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553903; cv=none; b=UqS7XFlYNoI9OCXvn4ufDwQDW+6HPORBl7NaxFJWTLcd/Z0wvhMh2ki/7riHU/TVR0YRVlyHV8ogiA4BhR36S0GbJlhkuplTnPGDeGx5OzUHAWn+ohgAnlmVaXrqfKQr8XCOQ7anEv/KyKdk7OyDRSolseWIwOljYJhqC3gOzRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553903; c=relaxed/simple;
	bh=cMdVmCywmr8AMcHfBYfn5X0XGBKzndi3o8A55Ciwfl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e24+5A0ds3k+HXuU8+CeLcuAypfPdD2AdMi5hZ2+gxtT4E9Phb31FHYyrxWDttMd6nouuzA7YN10ALZGvj1CCqiog3EKZpFMMYhB9dwAEcU74bFCnuanp9udl5PBpRvfYrDzYvRWqqCr1Ub8u3eE1qBa290ysA2YKVmswpzx9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4iJuLD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4iJuLD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E21BC4CEED;
	Thu,  3 Jul 2025 14:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553903;
	bh=cMdVmCywmr8AMcHfBYfn5X0XGBKzndi3o8A55Ciwfl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4iJuLD9j0caN/KBHKMaGZ3/j6y7Nad3LKME3MCB/u/scnmIkCfQnsMpFox93/hqO
	 kwTju8B7MZh53YCJe7PVX8rPa9yUYbWdKst97nmPeztf9Tmch+rQhmZuaOVOnR1fxS
	 EDe+pV2KtxEhtU1Rz+ADli1fv87ojyUqgZwrhT+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Rudraksha Gupta <guptarud@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/218] rust: arm: fix unknown (to Clang) argument -mno-fdpic
Date: Thu,  3 Jul 2025 16:39:27 +0200
Message-ID: <20250703143956.727099591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rudraksha Gupta <guptarud@gmail.com>

[ Upstream commit 977c4308ee4270cf46e2c66b37de8e04670daa0c ]

Currently rust on arm fails to compile due to '-mno-fdpic'. This flag
disables a GCC feature that we don't want for kernel builds, so let's
skip it as it doesn't apply to Clang.

    UPD     include/generated/asm-offsets.h
    CALL    scripts/checksyscalls.sh
    RUSTC L rust/core.o
    BINDGEN rust/bindings/bindings_generated.rs
    BINDGEN rust/bindings/bindings_helpers_generated.rs
    CC      rust/helpers/helpers.o
    Unable to generate bindings: clang diagnosed error: error: unknown argument: '-mno-fdpic'
    make[2]: *** [rust/Makefile:369: rust/bindings/bindings_helpers_generated.rs] Error 1
    make[2]: *** Deleting file 'rust/bindings/bindings_helpers_generated.rs'
    make[2]: *** Waiting for unfinished jobs....
    Unable to generate bindings: clang diagnosed error: error: unknown argument: '-mno-fdpic'
    make[2]: *** [rust/Makefile:349: rust/bindings/bindings_generated.rs] Error 1
    make[2]: *** Deleting file 'rust/bindings/bindings_generated.rs'
    make[1]: *** [/home/pmos/build/src/linux-next-next-20250521/Makefile:1285: prepare] Error 2
    make: *** [Makefile:248: __sub-make] Error 2

[ Naresh provided the draft diff [1].

  Ben explained [2]:

    FDPIC is only relevant with no-MMU targets, and then only for userspace.
    When configured for the arm-*-uclinuxfdpiceabi target, GCC enables FDPIC
    by default to facilitate compiling userspace programs. FDPIC is never
    used for the kernel, and we pass -mno-fdpic when building the kernel to
    override the default and make sure FDPIC is disabled.

  and [3]:

    -mno-fdpic disables a GCC feature that we don't want for kernel builds.
    clang does not support this feature, so it always behaves as though
    -mno-fdpic is passed. Therefore, it should be fine to mix the two, at
    least as far as FDPIC is concerned.

  [1] https://lore.kernel.org/rust-for-linux/CA+G9fYt4otQK4pHv8pJBW9e28yHSGCDncKquwuJiJ_1ou0pq0w@mail.gmail.com/
  [2] https://lore.kernel.org/rust-for-linux/aAKrq2InExQk7f_k@dell-precision-5540/
  [3] https://lore.kernel.org/rust-for-linux/aAo_F_UP1Gd4jHlZ@dell-precision-5540/

    - Miguel ]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYvOanQBYXKSg7C6EU30k8sTRC0JRPJXYu7wWK51w38QUQ@mail.gmail.com/
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Rudraksha Gupta <guptarud@gmail.com>
Link: https://lore.kernel.org/r/20250522-rust-mno-fdpic-arm-fix-v2-1-a6f691d9c198@gmail.com
[ Reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 93650b2ee7d57..b8b7f817c48e4 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -238,7 +238,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-387 -mpreferred-stack-boundary=% \
 	-fzero-call-used-regs=% -fno-stack-clash-protection \
 	-fno-inline-functions-called-once -fsanitize=bounds-strict \
 	-fstrict-flex-arrays=% -fmin-function-alignment=% \
-	-fzero-init-padding-bits=% \
+	-fzero-init-padding-bits=% -mno-fdpic \
 	--param=% --param asan-%
 
 # Derived from `scripts/Makefile.clang`.
-- 
2.39.5



