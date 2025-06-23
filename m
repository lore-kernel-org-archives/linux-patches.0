Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EEB22422F;
	Mon, 23 Jun 2025 21:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715992; cv=none; b=VKfJxmE6qOlk/fkBxvXClm/XLL9P8TdUDkroh4bUpTUl2jKC9G1ffpU3far7+330ZnbRne/pFelR+YyyYdjlaZ0xliW3byZJrOZW1l6bqNUzYYh5+jpyIciBN20zCDSJjGcGClApcT04cEJ4S0c1cP0/O2sZZmDdaZjaii5sgXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715992; c=relaxed/simple;
	bh=EOfnMxlX+VkAyE69i3fsKv+2HRxIWZrlShMAf+LNvCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifMJdb1D+iKN8VhsF5wFfi0qyoz6TShFefZY8qLwInyQGgAuXJB/oe734IfdI6dfE7uj7AFCPJ/DAoj44fjjgarSKyA0NGvurqsMrgEvt7cEIh+ps6jZfJznUeghEiRXqSofbaQgjfwqMeBjGcj6BbBCfJyfgr7DLowGfXwrhlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRCLm3w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRCLm3w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C4DC4CEEA;
	Mon, 23 Jun 2025 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715992;
	bh=EOfnMxlX+VkAyE69i3fsKv+2HRxIWZrlShMAf+LNvCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRCLm3w2OKLcTsSo2uuUmxgPEuuGMK6D6J7ZoxK1SYyyYv62opWsPdbL3iQk+5Dmo
	 MdJ6lkz5VpGUMXYHtAWvVZZHrwz3fewi5QMKUyXBTg3iHmsIRHQnLWHZRiBocPNwIg
	 lb0mYSCPQsv4rUhgobIU2DxtjnMYq7csUwNNt0jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 273/508] kbuild: Add CLANG_FLAGS to as-instr
Date: Mon, 23 Jun 2025 15:05:18 +0200
Message-ID: <20250623130651.964286943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
 scripts/Makefile.compiler |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -38,7 +38,7 @@ as-option = $(call try-run,\
 # Usage: aflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) -Werror $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) -Werror $(CLANG_FLAGS) $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
 
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)


