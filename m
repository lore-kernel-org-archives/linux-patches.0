Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0783192B75;
	Tue, 11 Nov 2025 00:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822127; cv=none; b=oFbF0q1GrkdZ8Hgr/8mS/MaCJbDFAFGruHCaEiN4LdqahGgFcdwpVM4FTpcpXyxCs/qC8Dq1jHWelxdVWJEjiWzK3KPTezkvfus3u+6UBtELKkf3028Bl+FDxWLWgsFHgSGQBR8Tq718rKByKZKmmQ55qQlA2TeB9ZumkvNJeG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822127; c=relaxed/simple;
	bh=+q3bzsKvXonT3pBO205ImkzRs7+alfJAr0H+6RdkaAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tiNivt5125NRHZzRwGlUHcdX8kgpsAn94IuCTenO3JVKoIvNloxO5TNDbGAlHndvBZ3KSJ9ryquQIczf7gNNdJDe1nI99kkZ1A+dovGrpzWqLbFWQ2VYb5FTIargUd3Tvs38CelZQA7OvUFQcoNWHrLbW+XMMG/U7kLXP073IAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3Z0oX5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3Z0oX5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8048DC4CEFB;
	Tue, 11 Nov 2025 00:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822126;
	bh=+q3bzsKvXonT3pBO205ImkzRs7+alfJAr0H+6RdkaAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3Z0oX5AJWPY0v+kDSGFBfx0gNBXzmQKT78SEkmTWLo2XMlRraBn7ug/GNPZG9G8d
	 kEYidQLbix3oeeLUrt8gIF0X8Mj6BdN9qn9eFKe99N5CMBQ/VEIp6Ey1kYuhNdUpHm
	 QRlotX3CzU56kMcJ9Krn7GPAVc59ApLUHAtzXOj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Arisu Tachibana <arisu.tachibana@miraclelinux.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.17 026/849] x86/build: Disable SSE4a
Date: Tue, 11 Nov 2025 09:33:16 +0900
Message-ID: <20251111004537.082742050@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 0d6e9ec80cebf9b378a1d3a01144e576d731c397 upstream.

Leyvi Rose reported that his X86_NATIVE_CPU=y build is failing because our
instruction decoder doesn't support SSE4a and the AMDGPU code seems to be
generating those with his compiler of choice (CLANG+LTO).

Now, our normal build flags disable SSE MMX SSE2 3DNOW AVX, but then
CC_FLAGS_FPU re-enable SSE SSE2.

Since nothing mentions SSE3 or SSE4, I'm assuming that -msse (or its negative)
control all SSE variants -- but why then explicitly enumerate SSE2 ?

Anyway, until the instruction decoder gets fixed, explicitly disallow SSE4a
(an AMD specific SSE4 extension).

Fixes: ea1dcca1de12 ("x86/kbuild/64: Add the CONFIG_X86_NATIVE_CPU option to locally optimize the kernel with '-march=native'")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Arisu Tachibana <arisu.tachibana@miraclelinux.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -74,7 +74,7 @@ export BITS
 #
 #    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53383
 #
-KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
+KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -mno-sse4a
 KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
 


