Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD61E0E16;
	Wed, 19 Feb 2025 09:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957453; cv=none; b=Cl7d/IYJ6uiLfEGo+wEwEY/j6dcnDeryzwO8Y0plb4SGHUhZ/u1aAMeHuxT1J9NfeIjiue1Bm8r8WAueQYZNUPlXRWpOHAqDwbxQSBcCtAMbXAm80iW4C7aRAeyDd823pJlKxr6K1PJP+4ceKvasCJq8hTyEPPrJPa2xnfnYDlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957453; c=relaxed/simple;
	bh=GuIR4CC29JOQSohVJMsbtABaoL0TsFupxmYHP0FAAqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUa0tT3p5ADEk3eIIjIGC9Jb0VXySqPyy4GeFrojwlNwR/JbYf+Zu71mz49xGT0s1WmXnsHoAk1kkUhDe/xoZO/1hFSNZC6m1gCsYyby/nL8KXx5Ftj6YoRj/SCrnEzYG4YaxfZ2Y+ppSja7Pkfew0LC/FwptIBccfhnk77z9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzkZhd91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzkZhd91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B181C4CED1;
	Wed, 19 Feb 2025 09:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957453;
	bh=GuIR4CC29JOQSohVJMsbtABaoL0TsFupxmYHP0FAAqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzkZhd91xi0Tq7VrSXYgz7jK8t26Lhn2iAjOLtAqhtLO28/Bj3QNfvQKJGLTR3eLk
	 dFY5AEWlgL0Iejgri9h5t4PoDYXsaZR/5rseQpnmxRlDdFIFBGHzw8u1xjHvgBvMvG
	 Vo+tELVtsfASaYAahUXyBLtKrDVVkg4sSxQTA4Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 532/578] arm64: Handle .ARM.attributes section in linker scripts
Date: Wed, 19 Feb 2025 09:28:56 +0100
Message-ID: <20250219082713.906353876@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit ca0f4fe7cf7183bfbdc67ca2de56ae1fc3a8db2b upstream.

A recent LLVM commit [1] started generating an .ARM.attributes section
similar to the one that exists for 32-bit, which results in orphan
section warnings (or errors if CONFIG_WERROR is enabled) from the linker
because it is not handled in the arm64 linker scripts.

  ld.lld: error: arch/arm64/kernel/vdso/vgettimeofday.o:(.ARM.attributes) is being placed in '.ARM.attributes'
  ld.lld: error: arch/arm64/kernel/vdso/vgetrandom.o:(.ARM.attributes) is being placed in '.ARM.attributes'

  ld.lld: error: vmlinux.a(lib/vsprintf.o):(.ARM.attributes) is being placed in '.ARM.attributes'
  ld.lld: error: vmlinux.a(lib/win_minmax.o):(.ARM.attributes) is being placed in '.ARM.attributes'
  ld.lld: error: vmlinux.a(lib/xarray.o):(.ARM.attributes) is being placed in '.ARM.attributes'

Discard the new sections in the necessary linker scripts to resolve the
warnings, as the kernel and vDSO do not need to retain it, similar to
the .note.gnu.property section.

Cc: stable@vger.kernel.org
Fixes: b3e5d80d0c48 ("arm64/build: Warn on orphan section placement")
Link: https://github.com/llvm/llvm-project/commit/ee99c4d4845db66c4daa2373352133f4b237c942 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250206-arm64-handle-arm-attributes-in-linker-script-v3-1-d53d169913eb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/vdso/vdso.lds.S |    1 +
 arch/arm64/kernel/vmlinux.lds.S   |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -38,6 +38,7 @@ SECTIONS
 	 */
 	/DISCARD/	: {
 		*(.note.GNU-stack .note.gnu.property)
+		*(.ARM.attributes)
 	}
 	.note		: { *(.note.*) }		:text	:note
 
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -149,6 +149,7 @@ SECTIONS
 	/DISCARD/ : {
 		*(.interp .dynamic)
 		*(.dynsym .dynstr .hash .gnu.hash)
+		*(.ARM.attributes)
 	}
 
 	. = KIMAGE_VADDR;


