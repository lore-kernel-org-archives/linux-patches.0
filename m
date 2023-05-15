Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3EFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A68C433D2;
	Mon, 15 May 2023 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169741;
	bh=/4Cmt3xNe5p47FhOZ2B3mNMwtPAWH2t44j6oe8ANPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr6IOwzWgxpUPyObQB398jnewTuh36u62g0prB/Vrn2G+6ecKyqJqDEl4fuAIOFxv
	 ZqRalilv2TOa9qx9uxgFwid25L2xYOclrHsP/X3lxvvdaFHqSHCb5zlOyTe55qfy9+
	 1NiXUTBuFdZTlDRkvKhZYC0AMxgg38rSDE3oaO1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.3 126/246] x86/retbleed: Fix return thunk alignment
Date: Mon, 15 May 2023 18:25:38 +0200
Message-Id: <20230515161726.343984343@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 9a48d604672220545d209e9996c2a1edbb5637f6 upstream.

SYM_FUNC_START_LOCAL_NOALIGN() adds an endbr leading to this layout
(leaving only the last 2 bytes of the address):

  3bff <zen_untrain_ret>:
  3bff:       f3 0f 1e fa             endbr64
  3c03:       f6                      test   $0xcc,%bl

  3c04 <__x86_return_thunk>:
  3c04:       c3                      ret
  3c05:       cc                      int3
  3c06:       0f ae e8                lfence

However, "the RET at __x86_return_thunk must be on a 64 byte boundary,
for alignment within the BTB."

Use SYM_START instead.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -144,8 +144,8 @@ SYM_CODE_END(__x86_indirect_jump_thunk_a
  */
 	.align 64
 	.skip 63, 0xcc
-SYM_FUNC_START_NOALIGN(zen_untrain_ret);
-
+SYM_START(zen_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
+	ANNOTATE_NOENDBR
 	/*
 	 * As executed from zen_untrain_ret, this is:
 	 *


