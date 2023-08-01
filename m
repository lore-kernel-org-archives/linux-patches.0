Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5391ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D21EC433CD;
	Tue,  1 Aug 2023 09:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883374;
	bh=NLli36TJx8pQ+5qTtBvNh2FTsHiO9559tMY+n1/ITeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUg5yy3NCBLpTxu1FWkBx/xb4HVGfM/EhNh+WqeZkezeyl5cJN/Yd/xVJ0PQA4FoE
	 SbQNp+GNAhfERyY6BJ4IEK5Jo8Julzsc2up8RuLNw/rXHSG9JCa86XSdZflyU2cqYQ
	 A2l2YLSO/EQSYVzoHepWongpnzEVHj+xHW99j1ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weihao Li <liweihao@loongson.cn>,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.4 213/239] LoongArch: Fix return value underflow in exception path
Date: Tue,  1 Aug 2023 11:21:17 +0200
Message-ID: <20230801091933.543476763@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: WANG Rui <wangrui@loongson.cn>

commit e66d511fc92201ba481392e54896f1aeadfcf0e9 upstream.

This patch fixes an underflow issue in the return value within the
exception path, specifically at .Llt8 when the remaining length is less
than 8 bytes.

Cc: stable@vger.kernel.org
Fixes: 8941e93ca590 ("LoongArch: Optimize memory ops (memset/memcpy/memmove)")
Reported-by: Weihao Li <liweihao@loongson.cn>
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/lib/clear_user.S | 3 ++-
 arch/loongarch/lib/copy_user.S  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/lib/clear_user.S b/arch/loongarch/lib/clear_user.S
index fd1d62b244f2..9dcf71719387 100644
--- a/arch/loongarch/lib/clear_user.S
+++ b/arch/loongarch/lib/clear_user.S
@@ -108,6 +108,7 @@ SYM_FUNC_START(__clear_user_fast)
 	addi.d	a3, a2, -8
 	bgeu	a0, a3, .Llt8
 15:	st.d	zero, a0, 0
+	addi.d	a0, a0, 8
 
 .Llt8:
 16:	st.d	zero, a2, -8
@@ -188,7 +189,7 @@ SYM_FUNC_START(__clear_user_fast)
 	_asm_extable 13b, .L_fixup_handle_0
 	_asm_extable 14b, .L_fixup_handle_1
 	_asm_extable 15b, .L_fixup_handle_0
-	_asm_extable 16b, .L_fixup_handle_1
+	_asm_extable 16b, .L_fixup_handle_0
 	_asm_extable 17b, .L_fixup_handle_s0
 	_asm_extable 18b, .L_fixup_handle_s0
 	_asm_extable 19b, .L_fixup_handle_s0
diff --git a/arch/loongarch/lib/copy_user.S b/arch/loongarch/lib/copy_user.S
index b21f6d5d38f5..fecd08cad702 100644
--- a/arch/loongarch/lib/copy_user.S
+++ b/arch/loongarch/lib/copy_user.S
@@ -136,6 +136,7 @@ SYM_FUNC_START(__copy_user_fast)
 	bgeu	a1, a4, .Llt8
 30:	ld.d	t0, a1, 0
 31:	st.d	t0, a0, 0
+	addi.d	a0, a0, 8
 
 .Llt8:
 32:	ld.d	t0, a3, -8
@@ -246,7 +247,7 @@ SYM_FUNC_START(__copy_user_fast)
 	_asm_extable 30b, .L_fixup_handle_0
 	_asm_extable 31b, .L_fixup_handle_0
 	_asm_extable 32b, .L_fixup_handle_0
-	_asm_extable 33b, .L_fixup_handle_1
+	_asm_extable 33b, .L_fixup_handle_0
 	_asm_extable 34b, .L_fixup_handle_s0
 	_asm_extable 35b, .L_fixup_handle_s0
 	_asm_extable 36b, .L_fixup_handle_s0
-- 
2.41.0



