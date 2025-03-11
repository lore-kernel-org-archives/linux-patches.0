Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3525D904;
	Tue, 11 Mar 2025 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707097; cv=none; b=M/s1YTOsFnzNSY2/w+vjiaNpbjjXCNISAssI7upFhN4qMGVcW7TjCIEt8f40Tm8W3TDSjHa8L8msDYqfK+K4vtbjZDKVNKC97qegSvEXKMNh2K3ZPI8ZN1I9diw7QfwpcyDSKVVrJOG+3qj7eUXQbj42kYGY+2wTTBDs9ifa3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707097; c=relaxed/simple;
	bh=ktbz6UzuH6HCfwzBbfWwzc1146HdKwumRwSfvV3ZzXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh3Dg+PPqm9hruZiIZq5T5s2YqcQmqGuqILbuMfO9BPJQtt3z6aZE3mFGCu7vVoD+VHMLiBoSd2Xy99OyBKeUsO9682O4XEpOkq9b7m9qi9dvMhoWW67pRTgCUA3wchae5vhyCgr5zd67rqlSoyPEAc/qtnPuU/OwnncIuBgPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llufXUuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llufXUuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C46C4CEE9;
	Tue, 11 Mar 2025 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707096;
	bh=ktbz6UzuH6HCfwzBbfWwzc1146HdKwumRwSfvV3ZzXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llufXUuctr13A6pqB2HhmsXstbNfbvA6bJKZRw+NxamicUrBqK0ZIYBMDReqe1RLW
	 0RrMh1rual+s8uxwo77C/xzGJYMM7A1ymsrY52aQKQk7IAL2MmmEumJL3a4Jzk4MsA
	 lnf3fAw6iwrTHV+q6XVynYoaHreAwykAAdSVTFv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 272/462] arm64: Handle .ARM.attributes section in linker scripts
Date: Tue, 11 Mar 2025 15:58:58 +0100
Message-ID: <20250311145809.110353590@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,6 +37,7 @@ SECTIONS
 	 */
 	/DISCARD/	: {
 		*(.note.GNU-stack .note.gnu.property)
+		*(.ARM.attributes)
 	}
 	.note		: { *(.note.*) }		:text	:note
 
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -113,6 +113,7 @@ SECTIONS
 	/DISCARD/ : {
 		*(.interp .dynamic)
 		*(.dynsym .dynstr .hash .gnu.hash)
+		*(.ARM.attributes)
 	}
 
 	. = KIMAGE_VADDR;


