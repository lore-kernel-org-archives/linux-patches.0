Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4916F17BB21;
	Sun,  7 Sep 2025 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276919; cv=none; b=fB7nTl+mOfkbhTFSUPm7EeugmpP2+fWtcsVshhwwBq0VTYmcJQ5x9Gmn2H4/GEitLBfo/VVr0J7h6Mrhu262v00IXU7rH+zfHEROJz6CtDgZ0sWXGuWH4PkKEkTE3zX20nEOxN58AgHMNfrvBXBSYaRdN7MnBQyh/9c7nBDpzXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276919; c=relaxed/simple;
	bh=ihPxzpFVJJmZt77xL9+LE/1+sTtheDB8lD0lzH0FH7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvcz/LfFteQnUoBUUQENnSQIfdmBjcVWaL3FrvWktY/Rc8lLfupNiPwb+kv10ZHf0NCps2jskaxEh0HXHUuzMgBZRTo5Zwo+hhtvh8/VygCB3vTpO4SRccmM+1bgwVOmJJ4N2NrjpG7vI8S/D6HIoIO/SJVYsP08MIei+5N9tUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7Jy0gZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7Jy0gZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B7EC4CEF0;
	Sun,  7 Sep 2025 20:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276917;
	bh=ihPxzpFVJJmZt77xL9+LE/1+sTtheDB8lD0lzH0FH7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7Jy0gZ4T5Csw6SYWEc2mEyZctYOCW1Fpf0Y0I81nzq9ZhjlXiGyUu7T7bp7C+eZa
	 52vMEkam/MrzAsh8N2LEwnJeWOK5D0/kERbsrZQgyFIIfEquqJAnytUr+i0+xi348u
	 EHq+ELbU5s/ut6ZzkUdQD6/PzUFiOkatu1Apmx/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/175] LoongArch: vDSO: Remove --hash-style=sysv
Date: Sun,  7 Sep 2025 21:57:04 +0200
Message-ID: <20250907195615.557507595@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit c271c86a4c72c771b313fd9c3b06db61ab8ab8bf ]

Glibc added support for .gnu.hash in 2006 and .hash has been obsoleted
far before the first LoongArch CPU was taped.  Using --hash-style=sysv
might imply unaddressed issues and confuse readers.

Some architectures use an explicit --hash-style=both for vDSO here, but
DT_GNU_HASH has already been supported by Glibc and Musl and become the
de-facto standard of the distros when the first LoongArch CPU was taped.
So DT_HASH seems just wasting storage space for LoongArch.

Just drop the option and rely on the linker default, which is likely
"gnu" (Arch, Debian, Gentoo, LFS) on all LoongArch distros (confirmed on
Arch, Debian, Gentoo, and LFS; AOSC now defaults to "both" but it seems
just an oversight).

Following the logic of commit 48f6430505c0b049 ("arm64/vdso: Remove
--hash-style=sysv").

Link: https://github.com/AOSC-Dev/aosc-os-abbs/pull/9796
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: d35ec48fa6c8 ("LoongArch: vDSO: Remove -nostdlib complier flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/vdso/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/loongarch/vdso/Makefile b/arch/loongarch/vdso/Makefile
index fdde1bcd4e266..cf6c41054396a 100644
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -36,8 +36,7 @@ endif
 
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
-	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared \
-	--hash-style=sysv --build-id -T
+	$(filter -E%,$(KBUILD_CFLAGS)) -nostdlib -shared --build-id -T
 
 #
 # Shared build commands.
-- 
2.50.1



