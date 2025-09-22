Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952902F2909;
	Mon, 22 Sep 2025 19:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570221; cv=none; b=sxEEx7crxFhmUH8ucG6nEvu2jB+wDizn8bUFG56aDb58zPMnJ9cLpU6xpbQ9CRUnAgF9E7++kYEImwyGXY6M9r8Y0cazOyhHo1MpDkigUFt+94uhIraTKJCD8+JvlZW3Nm7hbqr4NrR1092/SCs52GKhqjOagwbIc8c4yI7cYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570221; c=relaxed/simple;
	bh=Pf9jYeKEZxUFH0X0HZqUR7YhWbHMmk9r+n3btA6NSCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2GDAHInep4/bTi/x84wdVMvQXTNYBiPRV+SqO1flLbdzFLyZezTtpnlYZwEjO/YVskqMhAUUoYkjndqoCC0ul9//wxhVSxhO3zkfGvD6AIuYnxUuNbveTgSO46U37K5jqeBaKRXHj6pWJVFAmjdyngSkW8G7JA09vnCytP2mDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnIMMU4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnIMMU4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF1AC4CEF0;
	Mon, 22 Sep 2025 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570221;
	bh=Pf9jYeKEZxUFH0X0HZqUR7YhWbHMmk9r+n3btA6NSCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnIMMU4V3whtzjYnYzpswTLU+I+9uc4KwG+BB/pb2oHgTAIMFe4mlDR1BBYrISzHd
	 dy7WF0MH0u1dTGu6LEZiIeKV2sayzk7fXxTZQ0CuGcdsx7JROfQDH/m5/ZTDBMJ1El
	 YqgZgpMrhWXmHz4EZrEw5hCj2Oc73Q7nitXnDXT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 065/149] objtool/LoongArch: Mark types based on break immediate code
Date: Mon, 22 Sep 2025 21:29:25 +0200
Message-ID: <20250922192414.522254731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit baad7830ee9a56756b3857348452fe756cb0a702 upstream.

If the break immediate code is 0, it should mark the type as
INSN_TRAP. If the break immediate code is 1, it should mark the
type as INSN_BUG.

While at it, format the code style and add the code comment for nop.

Cc: stable@vger.kernel.org
Suggested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/arch/loongarch/decode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -310,10 +310,16 @@ int arch_decode_instruction(struct objto
 	if (decode_insn_reg2i16_fomat(inst, insn))
 		return 0;
 
-	if (inst.word == 0)
+	if (inst.word == 0) {
+		/* andi $zero, $zero, 0x0 */
 		insn->type = INSN_NOP;
-	else if (inst.reg0i15_format.opcode == break_op) {
-		/* break */
+	} else if (inst.reg0i15_format.opcode == break_op &&
+		   inst.reg0i15_format.immediate == 0x0) {
+		/* break 0x0 */
+		insn->type = INSN_TRAP;
+	} else if (inst.reg0i15_format.opcode == break_op &&
+		   inst.reg0i15_format.immediate == 0x1) {
+		/* break 0x1 */
 		insn->type = INSN_BUG;
 	} else if (inst.reg2_format.opcode == ertn_op) {
 		/* ertn */


