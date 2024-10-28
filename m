Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF9318D65C;
	Mon, 28 Oct 2024 06:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097985; cv=none; b=Jej6Z5KUhbRarJ4YN3oHLUlqFTRt8Wg8G5VGDXTXQ1DhwhEJJA8Luwrm9lO8uaCbBhklBV4PpEdzPjTP2mIMp8usUm1VmmecbBcwkKxaiDJjYp1pFpJwcUg3UeCq03LKIV/mylRSOsHXnqifmgmYHxeTThrG8FP9ULM0lVMbE+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097985; c=relaxed/simple;
	bh=pDjZ2UXNt4SzsO6h7t2Eomn23eJnw40kxVgwAThOpM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8Qhol5HKJT/eGnQ5d3WHs8UU47qbDAV4eDJtoodEJgIxkukjJUFqyWFMzHNek5sZBPv1OaaEkpS8nw/PgKvIw0iDOp9yCLXFvWOn1B7Dxe/5r0r7ClyqlFB6YR0gaqN4PUP9zmLD1ZVsG2hcjZvUZsopbE6UGX4v9eIAucZzCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzV1KOLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzV1KOLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C228AC4CEC3;
	Mon, 28 Oct 2024 06:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097985;
	bh=pDjZ2UXNt4SzsO6h7t2Eomn23eJnw40kxVgwAThOpM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzV1KOLVZT3aXnjOqGm24u+5vKNhl0t7ne5KFODR8ZnEH+F9IHiJCAWyUamx9+nlb
	 btMVoQ6MFwROc4BpEk0p9s45laEc0KBIVTLaiXTN8R+oiAH3/ruXMsYuDd3ffNOPvs
	 YS9E58MWzEtQ+Lgx2YjgSn2rSFv8DHMwkcYQN55A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/261] selftests/bpf: Fix cross-compiling urandom_read
Date: Mon, 28 Oct 2024 07:22:49 +0100
Message-ID: <20241028062312.697044221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit fd526e121c4d6f71aed82d21a8b8277b03e60b43 ]

Linking of urandom_read and liburandom_read.so prefers LLVM's 'ld.lld' but
falls back to using 'ld' if unsupported. However, this fallback discards
any existing makefile macro for LD and can break cross-compilation.

Fix by changing the fallback to use the target linker $(LD), passed via
'-fuse-ld=' using an absolute path rather than a linker "flavour".

Fixes: 08c79c9cd67f ("selftests/bpf: Don't force lld on non-x86 architectures")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241009040720.635260-1-tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 848fffa250227..555fd34c6e1fc 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -221,7 +221,7 @@ $(OUTPUT)/%:%.c
 ifeq ($(SRCARCH),$(filter $(SRCARCH),x86 riscv))
 LLD := lld
 else
-LLD := ld
+LLD := $(shell command -v $(LD))
 endif
 
 # Filter out -static for liburandom_read.so and its dependent targets so that static builds
-- 
2.43.0



