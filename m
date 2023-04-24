Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075652108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A35C433D2;
	Mon, 24 Apr 2023 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343415;
	bh=/DqfXu+qW5izewF+kSfBLxoYDo52LAZ+ZZmDVF5XaoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pnzkzz8fWi2SSNMUsq4HzuGNLJaeVHJiHH2kt+zzOgBqFvU4KHhI3FzuKAGpvEI5u
	 0pmx8aphQo3sTpbyJXjPklDSMxnWTplD88QXNZytPTyUIEEMK59EJt9wjBlLSC4I2g
	 XbVSFnpkoJNMoCTMSrXiTirX/SxBlt6Vq4NrfgLc=
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
Subject: [PATCH 4.14 17/28] x86/purgatory: Dont generate debug info for purgatory.ro
Date: Mon, 24 Apr 2023 15:18:38 +0200
Message-Id: <20230424131121.889146262@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
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
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/purgatory/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,6 +20,9 @@ KBUILD_CFLAGS := -fno-strict-aliasing -W
 KBUILD_CFLAGS += -m$(BITS)
 KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
 
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
 


