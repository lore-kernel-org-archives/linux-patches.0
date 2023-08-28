Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764FC11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2C1C433C8;
	Mon, 28 Aug 2023 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218123;
	bh=c/z+378YFyOobUQ48KCZIKKo4exuxDY1WbrnJZVMjkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL9WB0HPqARQy+VTGz46wfzUKLlJo0jWjgaE9vAzSOcebvd0WykEW591Erpd3IYmc
	 cSmO/5Bnp8gD4+DOLeKC7YH4ByOpVFcxigzYhg1PCeIV3jQ6D52g7RrYQ+nZC/CaSQ
	 6Q/y5Q5UUDAJyvZQlIsqTfpcy2Pzx0GK6ZPYmb1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.4 074/129] LoongArch: Fix hw_breakpoint_control() for watchpoints
Date: Mon, 28 Aug 2023 12:12:33 +0200
Message-ID: <20230828101159.795222857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 9730870b484e9de852b51df08a8b357b1129489e upstream.

In hw_breakpoint_control(), encode_ctrl_reg() has already encoded the
MWPnCFG3_LoadEn/MWPnCFG3_StoreEn bits in info->ctrl. We don't need to
add (1 << MWPnCFG3_LoadEn | 1 << MWPnCFG3_StoreEn) unconditionally.

Otherwise we can't set read watchpoint and write watchpoint separately.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/hw_breakpoint.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -207,8 +207,7 @@ static int hw_breakpoint_control(struct
 			write_wb_reg(CSR_CFG_CTRL, i, 0, CTRL_PLV_ENABLE);
 		} else {
 			ctrl = encode_ctrl_reg(info->ctrl);
-			write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl | CTRL_PLV_ENABLE |
-				     1 << MWPnCFG3_LoadEn | 1 << MWPnCFG3_StoreEn);
+			write_wb_reg(CSR_CFG_CTRL, i, 1, ctrl | CTRL_PLV_ENABLE);
 		}
 		enable = csr_read64(LOONGARCH_CSR_CRMD);
 		csr_write64(CSR_CRMD_WE | enable, LOONGARCH_CSR_CRMD);


