Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC223BF9F;
	Mon, 23 Jun 2025 13:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685085; cv=none; b=DTqyQk7EvO76bt5iIgjdIJrxjVkbtm4U8yo5L5VwSZj8FjISYb9K1U7EIuSow04MOn78uQpa9Ho91BsHHP1CXaU5/NOG0q15fRL1dcqpB0U4JT6DYyW6tYnVKm2fd5eCRZNIlEo1VJwwSarU6kkB3kWbSOz4SkrRDBnz+Q7l7I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685085; c=relaxed/simple;
	bh=7gW1HRrutcwferKOpT3Z8fFV2hDzUQvSLoNDGNagRLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpH+Y9kq+jonL21qojvtpuJTMauH227TWa1GGHWTCeCASy98ydghHsSqqMdtn8zrtvr91hXul7/rx6z6LMh9wzMznMBKIlf2NYVB5N9RyUuMEWuzPcNB+Qv/LpPy6Hn//yrCU3wg5RvgHYDpjbkqzbSBCX4yeG4wPoDcdo6zFfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5ZNEaUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5ZNEaUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E770BC4CEF0;
	Mon, 23 Jun 2025 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685085;
	bh=7gW1HRrutcwferKOpT3Z8fFV2hDzUQvSLoNDGNagRLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5ZNEaUsuXeOz3VOvkx9tMZoN3DxxMyXjUAX6i8YjkoOzzm6xW3X5m94iIpxyjA9C
	 bllfuOhaj0uss/7DqYhlktl5C+czWwmsmArHKq9oyR/TKtNsAPwdudBUR26VBIJ1fC
	 TZMsSuS9wVf8Ldoai0f82Ec8TPxeZzsMSZNJ3WzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 092/222] kbuild: Add CLANG_FLAGS to as-instr
Date: Mon, 23 Jun 2025 15:07:07 +0200
Message-ID: <20250623130614.866427232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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
@@ -108,7 +108,7 @@ as-option = $(call try-run,\
 # Usage: aflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) -Werror $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) -Werror $(CLANG_FLAGS) $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
 
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)


