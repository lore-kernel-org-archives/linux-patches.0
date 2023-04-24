Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31F7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62C9C4339E;
	Mon, 24 Apr 2023 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342914;
	bh=5YtbPC1B/po0Q8vfP7wcPCCXtg3GFxfQU22h32K5xiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTPd+Qon3FYYl7VDWCA94SXQMT2NvjerW7rEU2JNKCAomD8hq+zWGkUxuGvl22Lio
	 qhr1Qv4jiJW8Wl38y+t+5fViPvptCvpkxIZd4HQdCleQobTJmBhEH+ysCxg/pX4LN+
	 Uo6ytSa1fNtMNqUPGODzknZM952IGldWW+Y77Zrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alyssa Ross <hi@alyssa.is>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 86/98] purgatory: fix disabling debug info
Date: Mon, 24 Apr 2023 15:17:49 +0200
Message-Id: <20230424131137.216210319@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alyssa Ross <hi@alyssa.is>

commit d83806c4c0cccc0d6d3c3581a11983a9c186a138 upstream.

Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
-Wa versions of both of those if building with Clang and GNU as.  As a
result, debug info was being generated for the purgatory objects, even
though the intention was that it not be.

Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Cc: stable@vger.kernel.org
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/purgatory/Makefile |    4 +---
 arch/x86/purgatory/Makefile   |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -74,9 +74,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)


