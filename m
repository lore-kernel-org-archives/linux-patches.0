Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4394E26F472;
	Tue,  8 Apr 2025 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117037; cv=none; b=LxQa//P0CYXtSzz/nZ++7lD7WavaRK/E+ZdPEo46JM2YW4P1rANXIhIh2EEp4hf9vHCVvkqVVLNYZQ8TU7Khg+fpZQ1OeWNyn13CUJ9ePARHBoDXodJ0kbBLdwXO3zm1TFB5TPtvfs0uhPic7RsmzEO2yOqRo/MX3VWq7SHAhHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117037; c=relaxed/simple;
	bh=zXfM+II0If8UCZ8py85sYSCQGKihGcw+6c2QYYafX9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjpBP8UG6TFzgiLFdasCC+PjeuJyClPjMs2YNytMggqZLl3pJRnaUa4mO1IgA6mzYkwEbxT10nqoNyVdJbVKrhKd+B02tBaZkV5HSG3ZEIB3JTswWeaILhC3Mzj3TqDWh7eeTqkh9tcci9T9pFTJxMNUGGPUSxsMNjG/o2LYLhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5iuZaRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5iuZaRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3315C4CEE5;
	Tue,  8 Apr 2025 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117037;
	bh=zXfM+II0If8UCZ8py85sYSCQGKihGcw+6c2QYYafX9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5iuZaRR4GHoA5LVY2wnLngh6Pz7H3gvhWVYeZ7ucy7pViOMGu1CF+Cmlqh7kFbzg
	 pq3FFBY/9xTinkgjY3bji5dDxvSwsPuaeYKAhCuLv8BE0uVuqOh8tLzFoGh9juyzlp
	 6rA+sykw+vJN9eozq7H7avB+zniB/nO7QGSW88KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 362/423] rust: Fix enabling Rust and building with GCC for LoongArch
Date: Tue,  8 Apr 2025 12:51:28 +0200
Message-ID: <20250408104854.291181208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: WANG Rui <wangrui@loongson.cn>

commit 13c23cb4ed09466d73f1beae8956810b95add6ef upstream.

This patch fixes a build issue on LoongArch when Rust is enabled and
compiled with GCC by explicitly setting the bindgen target and skipping
C flags that Clang doesn't support.

Cc: stable@vger.kernel.org
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -227,7 +227,8 @@ bindgen_skip_c_flags := -mno-fp-ret-in-3
 	-mfunction-return=thunk-extern -mrecord-mcount -mabi=lp64 \
 	-mindirect-branch-cs-prefix -mstack-protector-guard% -mtraceback=no \
 	-mno-pointers-to-nested-functions -mno-string \
-	-mno-strict-align -mstrict-align \
+	-mno-strict-align -mstrict-align -mdirect-extern-access \
+	-mexplicit-relocs -mno-check-zero-division \
 	-fconserve-stack -falign-jumps=% -falign-loops=% \
 	-femit-struct-debug-baseonly -fno-ipa-cp-clone -fno-ipa-sra \
 	-fno-partial-inlining -fplugin-arg-arm_ssp_per_task_plugin-% \
@@ -241,6 +242,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-3
 # Derived from `scripts/Makefile.clang`.
 BINDGEN_TARGET_x86	:= x86_64-linux-gnu
 BINDGEN_TARGET_arm64	:= aarch64-linux-gnu
+BINDGEN_TARGET_loongarch	:= loongarch64-linux-gnusf
 BINDGEN_TARGET		:= $(BINDGEN_TARGET_$(SRCARCH))
 
 # All warnings are inhibited since GCC builds are very experimental,


