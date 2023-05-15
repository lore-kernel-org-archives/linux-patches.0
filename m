Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB54DFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42107C433D2;
	Mon, 15 May 2023 17:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170365;
	bh=dlZQR2ODUpACpeUlsqH8SzLbdY/QnnMtdjRgzVaEX5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYeJ4EFruorGeSCLA/yDswiJo3C4PJm3SzlMCgl0PK5UX11BwjmzVIFwXpKnTYD0C
	 NVeCQCIghGrZprIw5VD0w/wvuHz+Js7hiEjOQ8Rcqd9E0hY+/juxP6AFeTB5iMzneA
	 h/LMplWlTG0AuQYmGI9Yz/0bXQW9P+Y2ofIDTPtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 108/239] x86/retbleed: Fix return thunk alignment
Date: Mon, 15 May 2023 18:26:11 +0200
Message-Id: <20230515161724.939385888@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
@@ -87,8 +87,8 @@ SYM_CODE_END(__x86_indirect_thunk_array)
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


