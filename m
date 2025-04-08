Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569D7266583;
	Tue,  8 Apr 2025 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112064; cv=none; b=L/0e8wkKFZ/opB4f5Ki26USbyUOY46D00stKT/jhx0VhcbJwUw1TaUKyxUUb5l3p2c2xeoH7C3NEf7RddcxPbPr2o3tKw1xYV3JZs1n32ibrzrN+UeqVT/raOKB9qM6L9Z61xVbL3WcVg8A+uk8HLSptCUklid7ofQaqngX0AFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112064; c=relaxed/simple;
	bh=By1irPhWeC6IM+eP8idOACIVEbRfV5d5EDKmIqskLiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFAzAXDZJ+Y+e34vgNNOq0PUZq1/qH7duz5jud3MY8vrh07UhDxBVf9EzfK9rCGf/Pl/nlA9fe8+hTKZzOzY1nP/zEb94vyDrmXwCAd9g64/HDGYAGbG6LuI4vGTOpgCH70BPNlPs+2CNvBz5/OPdofQkz5DklNXr4BYQsHHUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx/3Idem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx/3Idem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB482C4CEE5;
	Tue,  8 Apr 2025 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112064;
	bh=By1irPhWeC6IM+eP8idOACIVEbRfV5d5EDKmIqskLiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xx/3Idem1UY7yMM4djDRX3jY5MWrfpvYSxRy4oUry/BBJRj4N2M5DDDaVKZHYelkM
	 xF+ovdrHMcWxFlnmZSN0YvFL/zMrE+Doz2JiY/DXDe7Sglgamr1XuB9JCmd7NBrPI6
	 uAckzz9kYphE3as0GPN+jOiachLPlJ9uZ3xOEymY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 662/731] rust: Fix enabling Rust and building with GCC for LoongArch
Date: Tue,  8 Apr 2025 12:49:19 +0200
Message-ID: <20250408104929.665233855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -232,7 +232,8 @@ bindgen_skip_c_flags := -mno-fp-ret-in-3
 	-mfunction-return=thunk-extern -mrecord-mcount -mabi=lp64 \
 	-mindirect-branch-cs-prefix -mstack-protector-guard% -mtraceback=no \
 	-mno-pointers-to-nested-functions -mno-string \
-	-mno-strict-align -mstrict-align \
+	-mno-strict-align -mstrict-align -mdirect-extern-access \
+	-mexplicit-relocs -mno-check-zero-division \
 	-fconserve-stack -falign-jumps=% -falign-loops=% \
 	-femit-struct-debug-baseonly -fno-ipa-cp-clone -fno-ipa-sra \
 	-fno-partial-inlining -fplugin-arg-arm_ssp_per_task_plugin-% \
@@ -246,6 +247,7 @@ bindgen_skip_c_flags := -mno-fp-ret-in-3
 # Derived from `scripts/Makefile.clang`.
 BINDGEN_TARGET_x86	:= x86_64-linux-gnu
 BINDGEN_TARGET_arm64	:= aarch64-linux-gnu
+BINDGEN_TARGET_loongarch	:= loongarch64-linux-gnusf
 BINDGEN_TARGET		:= $(BINDGEN_TARGET_$(SRCARCH))
 
 # All warnings are inhibited since GCC builds are very experimental,


