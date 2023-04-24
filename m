Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDBD2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1024CC433D2;
	Mon, 24 Apr 2023 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343495;
	bh=1krLyJWlEkC0w8bP9ttf9TtWClkmu2n+U0oRuZRh5DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G889fX17T/UGu1vuClDmwaZCQp7XjMZdTe1JXOJca6lvwQMvhsPcGmi4pVurYoTXB
	 96/5lt4tPQipSSGh3JE3tzvgigkMk4UKQDPpp1U0Q/hba+K3cz0GkgPTI4xo2Lxn43
	 yKMZkaxZIT2bevKEIdVhGSf60X/jFPd1ZghRadrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pingfan Liu <kernelfans@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	Dave Young <dyoung@redhat.com>,
	Alyssa Ross <hi@alyssa.is>
Subject: [PATCH 4.19 18/29] x86/purgatory: Dont generate debug info for purgatory.ro
Date: Mon, 24 Apr 2023 15:18:45 +0200
Message-Id: <20230424131121.750282091@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pingfan Liu <kernelfans@gmail.com>

commit 52416ffcf823ee11aa19792715664ab94757f111 upstream.

Purgatory.ro is a standalone binary that is not linked against the rest of
the kernel.  Its image is copied into an array that is linked to the
kernel, and from there kexec relocates it wherever it desires.

Unlike the debug info for vmlinux, which can be used for analyzing crash
such info is useless in purgatory.ro. And discarding them can save about
200K space.

 Original:
   259080  kexec-purgatory.o
 Stripped debug info:
    29152  kexec-purgatory.o

Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Acked-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/r/1596433788-3784-1-git-send-email-kernelfans@gmail.com
[Alyssa: fixed for LLVM_IAS=1 by adding -g to AFLAGS_REMOVE_*]
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/purgatory/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -25,7 +25,7 @@ KCOV_INSTRUMENT := n
 # make up the standalone purgatory.ro
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
-PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss
+PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss -g0
 PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN) -DDISABLE_BRANCH_PROFILING
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
@@ -56,6 +56,9 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -g -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry64.o			+= -g -Wa,-gdwarf-2
+
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 


