Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C8C1C1ADB;
	Mon, 22 Sep 2025 19:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569904; cv=none; b=sZiCs3/on1jOoWnNK6I+6Bum0r7YWli2qnLAnKYKroXjH0wthniwSZd9fp5j2Q1mqJnd4isdNFVJLYUd6j8ynm8gQDJbGkaws7wrqdedsJBgh9uuPeli0kYFj67yfNCWCDNAubn28/oq/w1wcqWGFxgvX6FNySZpwKRQglLBHCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569904; c=relaxed/simple;
	bh=DfX/ERQPFljgTtUMIuui5HKGClzYFa2otPEaRqtJhTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghlY9pgUfiqbzcBuNl4GV/TZHqYBnHD2yYMPPenuobhRtRy7DDfSnOgTW0lu1gayAsQ6zynCZbL89CFHP70pUhfFpdsCC/Tl9CJ2RMR/Sog8xEOWHTS27giIDwUshCFY3kkTUd0H0La7pmUtrVBM0Hjw5zJCpOOELg8pq+eSQ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/QggWxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/QggWxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034A3C4CEF0;
	Mon, 22 Sep 2025 19:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569904;
	bh=DfX/ERQPFljgTtUMIuui5HKGClzYFa2otPEaRqtJhTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/QggWxYnVkkhnx3e25mTzUgFNrORMEVRAXB+p5wQV9o0uqYkU/8mYmsmGAZLfQw5
	 m6zCfpgvg6+FxrgxXkMAPCeLHUMgv3ha3k8pimnhcBT8zM1xzayYXBFif1qpollDoZ
	 cNJIaRC79rDSWko7hWC+SXYolSFJpbv5LRgXogSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 045/105] objtool/LoongArch: Mark types based on break immediate code
Date: Mon, 22 Sep 2025 21:29:28 +0200
Message-ID: <20250922192410.097890670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -313,10 +313,16 @@ int arch_decode_instruction(struct objto
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


