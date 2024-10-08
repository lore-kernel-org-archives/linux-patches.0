Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC11DF722;
	Tue,  8 Oct 2024 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393930; cv=none; b=uS4YUH7EUaTzvHCJcp/8SGpdRGTN2GjTpU8A15yUh83Ne1z8SZSeJ/rkXt/ruQ5qKzSzODRkOkae3kENhxIEhDFLU8cn6CdyoAsjztLnanDlfnQkbGPVt5TskC5GcLxlCTym8scJYK5eAJUhmSRAkfP+SurRtqdF72R5T/aybmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393930; c=relaxed/simple;
	bh=Ee4XHyNCE/wG47qWagWibGBZPWUZKdwKj6Nauxn5T6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI9bfjhErQnFvT/bXWUp28DDxT0NFGrG49E4kfAKoYaMLBspMwthRpXxVNzEHV7+br4o4u+0CzcTVup5Ihlj6thXxCWfcKxu/D+ER/6y5WiLYa6zhqplWsDYXHLxJ7cLRHxrSbGokv0vWC1C2cnudfPE3WlAWQ6fOTqeK75Ukxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOne0AsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOne0AsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F413CC4CEC7;
	Tue,  8 Oct 2024 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393930;
	bh=Ee4XHyNCE/wG47qWagWibGBZPWUZKdwKj6Nauxn5T6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOne0AsIkrmP/bgKYyHYzAOGjLmlVKBHaf7vnmoZlGa5dWgIBapsGwikF/OiPeENy
	 HAJ9hnTncZRZDg1pfIjA8fgdOiUyDfe6IP8a+Kj+DQFmrgLUbdOqGAbr0Y3fxlHJu9
	 G7DgHTMgQ0JXqLWklP+2EgFuuaCPMw46qXW+z+Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 266/386] arm64: fix selection of HAVE_DYNAMIC_FTRACE_WITH_ARGS
Date: Tue,  8 Oct 2024 14:08:31 +0200
Message-ID: <20241008115639.858795949@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit b3d6121eaeb22aee8a02f46706745b1968cc0292 upstream.

The Kconfig logic to select HAVE_DYNAMIC_FTRACE_WITH_ARGS is incorrect,
and HAVE_DYNAMIC_FTRACE_WITH_ARGS may be selected when it is not
supported by the combination of clang and GNU LD, resulting in link-time
errors:

  aarch64-linux-gnu-ld: .init.data has both ordered [`__patchable_function_entries' in init/main.o] and unordered [`.meminit.data' in mm/sparse.o] sections
  aarch64-linux-gnu-ld: final link failed: bad value

... which can be seen when building with CC=clang using a binutils
version older than 2.36.

We originally fixed that in commit:

  45bd8951806eb5e8 ("arm64: Improve HAVE_DYNAMIC_FTRACE_WITH_REGS selection for clang")

... by splitting the "select HAVE_DYNAMIC_FTRACE_WITH_ARGS" statement
into separete CLANG_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS and
GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS options which individually select
HAVE_DYNAMIC_FTRACE_WITH_ARGS.

Subsequently we accidentally re-introduced the common "select
HAVE_DYNAMIC_FTRACE_WITH_ARGS" statement in commit:

  26299b3f6ba26bfc ("ftrace: arm64: move from REGS to ARGS")

... then we removed it again in commit:

  68a63a412d18bd2e ("arm64: Fix build with CC=clang, CONFIG_FTRACE=y and CONFIG_STACK_TRACER=y")

... then we accidentally re-introduced it again in commit:

  2aa6ac03516d078c ("arm64: ftrace: Add direct call support")

Fix this for the third time by keeping the unified select statement and
making this depend onf either GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS or
CLANG_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS. This is more consistent with
usual style and less likely to go wrong in future.

Fixes: 2aa6ac03516d ("arm64: ftrace: Add direct call support")
Cc: <stable@vger.kernel.org> # 6.4.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240930120448.3352564-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -191,7 +191,8 @@ config ARM64
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_DYNAMIC_FTRACE_WITH_ARGS \
-		if $(cc-option,-fpatchable-function-entry=2)
+		if (GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS || \
+		    CLANG_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS)
 	select HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS \
 		if DYNAMIC_FTRACE_WITH_ARGS && DYNAMIC_FTRACE_WITH_CALL_OPS
 	select HAVE_DYNAMIC_FTRACE_WITH_CALL_OPS \
@@ -262,12 +263,10 @@ config CLANG_SUPPORTS_DYNAMIC_FTRACE_WIT
 	def_bool CC_IS_CLANG
 	# https://github.com/ClangBuiltLinux/linux/issues/1507
 	depends on AS_IS_GNU || (AS_IS_LLVM && (LD_IS_LLD || LD_VERSION >= 23600))
-	select HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
 config GCC_SUPPORTS_DYNAMIC_FTRACE_WITH_ARGS
 	def_bool CC_IS_GCC
 	depends on $(cc-option,-fpatchable-function-entry=2)
-	select HAVE_DYNAMIC_FTRACE_WITH_ARGS
 
 config 64BIT
 	def_bool y


