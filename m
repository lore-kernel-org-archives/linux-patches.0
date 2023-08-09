Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E817AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861F8C433C7;
	Wed,  9 Aug 2023 11:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581226;
	bh=y1UW9pLC2EB6CuBGzUqVmpUPEDYuH/w884/kObIcfPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h68ANreqngkS1V+6MZHRNaXIGygnOMWhc47vqke2LbjgQ+JyBhK34OcEUVnj3f6xQ
	 RgAJGwmoi8M5G3Q/a4BtKGjOOPmfk+pQw9NSaaVyQuq9xl96Y1D3JKy3DCW2TxhIfk
	 sU4C/RgDhn7ZZ9DMIoBu/58Waukj7ad/MLn1wHA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nadav Amit <namit@vmware.com>,
	Ingo Molnar <mingo@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 121/201] x86/kprobes: Fix JNG/JNLE emulation
Date: Wed,  9 Aug 2023 12:42:03 +0200
Message-ID: <20230809103647.807568780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 8924779df820c53875abaeb10c648e9cb75b46d4 ]

When kprobes emulates JNG/JNLE instructions on x86 it uses the wrong
condition. For JNG (opcode: 0F 8E), according to Intel SDM, the jump is
performed if (ZF == 1 or SF != OF). However the kernel emulation
currently uses 'and' instead of 'or'.

As a result, setting a kprobe on JNG/JNLE might cause the kernel to
behave incorrectly whenever the kprobe is hit.

Fix by changing the 'and' to 'or'.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220813225943.143767-1-namit@vmware.com
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -505,7 +505,7 @@ static void kprobe_emulate_jcc(struct kp
 		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
 			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (p->ainsn.jcc.type >= 0xe)
-			match = match && (regs->flags & X86_EFLAGS_ZF);
+			match = match || (regs->flags & X86_EFLAGS_ZF);
 	}
 	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
 }


