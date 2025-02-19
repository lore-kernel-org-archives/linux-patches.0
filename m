Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C291E0DFE;
	Wed, 19 Feb 2025 08:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955183; cv=none; b=OQBX/dp4aXksV1uzHwlmJB4tjTeUk2vce5vDfAdLovGKKHC5AU0cnMB0FO87xSnOC0cJp/Qndl7Lr0igZdCkVod0jneRlbrEMM1oQHYLfFe4v10zwgvsvZsZj7nBiKTZOSp+lPSVtunTDxq6wnGpBHPXxyI2KTNDWpW+r/YBtvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955183; c=relaxed/simple;
	bh=VrGsTDJCBpxRU/ngtXcnVwt/XRFkHc8Dlr+ySmF4yeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fhd8c2DkSKSwAVn70ghNzTrNfRrGeFU5ODtf/fZznClSSPI0yJH2pCHLb7KQfVOu5obe8HBSsLKGmvOK4/a5sGvvUyCxpNaY/AuoXl0u37z6Tjru5ahwL/BmkY7Kyo64ml95/UWaODPdyoT/Lk1Ut99Rc05oMBbdz/sz8/BYmkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g19Soog/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g19Soog/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB70DC4CED1;
	Wed, 19 Feb 2025 08:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955183;
	bh=VrGsTDJCBpxRU/ngtXcnVwt/XRFkHc8Dlr+ySmF4yeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g19Soog/BBeNLANaMvrdJZTXbJ5U6cjCc7ZDJrgOUcR+NIujp1PVNbgWaBjg/7084
	 hxBfiLfK2aPOmdgCAxdM4ZRtlmYkI7eJce9HkY2Me9vsY40Zc1ReaMiJE5LUJzIJEZ
	 KEJpZPVFCcgtTEszMRJvC67Ddbp2KfuVMNZc8Z24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 157/230] arm64: Handle .ARM.attributes section in linker scripts
Date: Wed, 19 Feb 2025 09:27:54 +0100
Message-ID: <20250219082607.836795394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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
@@ -41,6 +41,7 @@ SECTIONS
 	 */
 	/DISCARD/	: {
 		*(.note.GNU-stack .note.gnu.property)
+		*(.ARM.attributes)
 	}
 	.note		: { *(.note.*) }		:text	:note
 
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -162,6 +162,7 @@ SECTIONS
 	/DISCARD/ : {
 		*(.interp .dynamic)
 		*(.dynsym .dynstr .hash .gnu.hash)
+		*(.ARM.attributes)
 	}
 
 	. = KIMAGE_VADDR;


