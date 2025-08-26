Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777EE2AE68;
	Tue, 26 Aug 2025 14:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219294; cv=none; b=UNxQOx96WqFyUjZKypgLO9iikZ4nrnLQbIWGO1zNUZgaEExOGKpODXcoYBizo6J4g+EeUG2G2TNmLcoz6KDbNU0FaFURDNkejVl5FPMpnDoBr2RjV9EEvbL2kUWMZ7mgSEvlsTzQU6TE+y1Un1A6M4bAdwpFGdho0hcCI0AwU38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219294; c=relaxed/simple;
	bh=4yA9JNC+fUicaPcbh1feMTMCLXzAYJSzldel2PsxSyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3ymwAwVwhhJGEf3NcFcKyFzDGxIz+GWGbI/p/wmGmBu/zHi4+wy04ysFIhnfEbnpjUdp7mhYoTiNkI9Qh34e7NNPRlHkv6t/fiMA+f3cPRfeWPEBTdj+0UohbhsYz1JZRZc1TXqXzMcjQFncyx9JqNmgjja3D00oPc8t+oTi0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFhkMyw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFhkMyw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A135C4CEF1;
	Tue, 26 Aug 2025 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219294;
	bh=4yA9JNC+fUicaPcbh1feMTMCLXzAYJSzldel2PsxSyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFhkMyw+vM69CCFeHCU1q1WNtWqcuJyB5Q7Rj9ULftcmPcJKNINdwMWTaKRUqlXsd
	 IWLScAH/gbVyZTE3TlKrLuSo7pUSpNMqqnDtQ772uYtTihY5VWK7whvtriW/vKtzwy
	 En+Afa1fv658Rs2iEDGKh9KbMQRQUB9KjzLBAf9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rini <trini@konsulko.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 327/403] kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS
Date: Tue, 26 Aug 2025 13:10:53 +0200
Message-ID: <20250826110915.856476186@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit feb843a469fb0ab00d2d23cfb9bcc379791011bb upstream.

When preprocessing arch/*/kernel/vmlinux.lds.S, the target triple is
not passed to $(CPP) because we add it only to KBUILD_{C,A}FLAGS.

As a result, the linker script is preprocessed with predefined macros
for the build host instead of the target.

Assuming you use an x86 build machine, compare the following:

 $ clang -dM -E -x c /dev/null
 $ clang -dM -E -x c /dev/null -target aarch64-linux-gnu

There is no actual problem presumably because our linker scripts do not
rely on such predefined macros, but it is better to define correct ones.

Move $(CLANG_FLAGS) to KBUILD_CPPFLAGS, so that all *.c, *.S, *.lds.S
will be processed with the proper target triple.

[Note]
After the patch submission, we got an actual problem that needs this
commit. (CBL issue 1859)

Link: https://github.com/ClangBuiltLinux/linux/issues/1859
Reported-by: Tom Rini <trini@konsulko.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -568,8 +568,7 @@ ifneq ($(LLVM_IAS),1)
 CLANG_FLAGS	+= -no-integrated-as
 endif
 CLANG_FLAGS	+= -Werror=unknown-warning-option
-KBUILD_CFLAGS	+= $(CLANG_FLAGS)
-KBUILD_AFLAGS	+= $(CLANG_FLAGS)
+KBUILD_CPPFLAGS	+= $(CLANG_FLAGS)
 export CLANG_FLAGS
 endif
 


