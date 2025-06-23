Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991D01DF98B;
	Mon, 23 Jun 2025 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713138; cv=none; b=n5QEvYPM8zGlROd4k7iPn3Y3IrWAOgnmpPlysbTdCzPakHqPuYu8oiJY1Wt71TrvZNmoBSLxgNjUd/fZGPnCQSTz0Db+0BCmRpnIY5MB/LjoIenZAiuA9XEcWVodJi4wsinSFaWbZ9/SSV3pd6Mvygq3nhoqz7CoAvKQI3Vzj8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713138; c=relaxed/simple;
	bh=bH1vtAD20jMDp/KOwytvc7WS25YHHQ+oJTtR45qv3ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocqOgENiXQaPzSFznKG0FUPAyMMDS0IGztwzmN+0+OFjIcCKc7IpmmWi1ETz4h7HV+bRCJh4xbM/dI4aprBqe7jhJIG6QzXDtyhPFDVko6ex8VnE2dz85Lx/x6Z+eZfhngT1wf0VBqr5EOUkbtNkh2YP2FKOhoqMT6+k88rJjgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDYUBDqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDYUBDqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E477FC4CEEA;
	Mon, 23 Jun 2025 21:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713138;
	bh=bH1vtAD20jMDp/KOwytvc7WS25YHHQ+oJTtR45qv3ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDYUBDqV0poDHYQz3uzNLgkAwMy2UHrBdQl5GJoZi9lY9xJ2Tad8JLVDAkcMeMp8g
	 VsU9bzqOVMT1XttPi7KIJ8RW5UsaNkAmxy96rnwswv75My7giNik7RyZkQivLsI25M
	 PbOJ/Dvd1ZZg5/33a3nM8iI62SXQmU8AOvhMQwIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 147/355] kbuild: Add CLANG_FLAGS to as-instr
Date: Mon, 23 Jun 2025 15:05:48 +0200
Message-ID: <20250623130631.128775626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

commit cff6e7f50bd315e5b39c4e46c704ac587ceb965f upstream.

A future change will move CLANG_FLAGS from KBUILD_{A,C}FLAGS to
KBUILD_CPPFLAGS so that '--target' is available while preprocessing.
When that occurs, the following errors appear multiple times when
building ARCH=powerpc powernv_defconfig:

  ld.lld: error: vmlinux.a(arch/powerpc/kernel/head_64.o):(.text+0x12d4): relocation R_PPC64_ADDR16_HI out of range: -4611686018409717520 is not in [-2147483648, 2147483647]; references '__start___soft_mask_table'
  ld.lld: error: vmlinux.a(arch/powerpc/kernel/head_64.o):(.text+0x12e8): relocation R_PPC64_ADDR16_HI out of range: -4611686018409717392 is not in [-2147483648, 2147483647]; references '__stop___soft_mask_table'

Diffing the .o.cmd files reveals that -DHAVE_AS_ATHIGH=1 is not present
anymore, because as-instr only uses KBUILD_AFLAGS, which will no longer
contain '--target'.

Mirror Kconfig's as-instr and add CLANG_FLAGS explicitly to the
invocation to ensure the target information is always present.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -110,7 +110,7 @@ as-option = $(call try-run,\
 # Usage: aflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) -Werror $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) -Werror $(CLANG_FLAGS) $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
 
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)


