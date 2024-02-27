Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122B114690D;
	Tue, 27 Feb 2024 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044159; cv=none; b=l1tZlwz+TU16u3Vzv3Gypz6hallSS0oa2gXOBQ3kSaOE64vx6pRydmZXq6ViwIwgOKVgzDdyVsHB5e1N+XGfBIHxscUJipuYTs8QFLTeN3xx4cN106PiF1HfGJoTv27Yhg1Rt1FZHSnM+4rUhZmrsTnHmerSRJvPktl5FVh5XjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044159; c=relaxed/simple;
	bh=/cxfsjS9ce0xZwu+utZq6moiUwkbDiuCMrxRByO67Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcVMud8aNfcgY3cyByXSzZNyaMJAzPTaqjek1CAOgjdblXTEMNX2SjkzgRsrNOLrl0E/Cpm8veSoZGGonFpLGEZXsIhGOZohEBkJyCC3QQbtaaqH0T2gAk3JljuKnT8jnfnEyixD/04dpaZn/LSodYNV1MUsuFnB32NYBuuCRY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVIMIEt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVIMIEt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1DEC43390;
	Tue, 27 Feb 2024 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044158;
	bh=/cxfsjS9ce0xZwu+utZq6moiUwkbDiuCMrxRByO67Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVIMIEt5WNK6CKS4sqsx9IXNURxtrPoSJKDYCQNmSXXV5x7eSYBvy7xn7sB18IDmH
	 Ri9cbAELSUifpnDIA0Rugdn5EUTkqrbFnH04fOEwlDueJVIDjZNg2K9qjUNuEKAsgT
	 Ib9lTpRRrXfdAHrjVx1AqpEb5ZZQ5tGtdq96lWp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 084/122] x86/text-patching: Make text_gen_insn() play nice with ANNOTATE_NOENDBR
Date: Tue, 27 Feb 2024 14:27:25 +0100
Message-ID: <20240227131601.455452544@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

Upstream commit: bbf92368b0b1fe472d489e62d3340d7897e9c697

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.638561109@infradead.org
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -101,13 +101,21 @@ void *text_gen_insn(u8 opcode, const voi
 	static union text_poke_insn insn; /* per instance */
 	int size = text_opcode_size(opcode);
 
+	/*
+	 * Hide the addresses to avoid the compiler folding in constants when
+	 * referencing code, these can mess up annotations like
+	 * ANNOTATE_NOENDBR.
+	 */
+	OPTIMIZER_HIDE_VAR(addr);
+	OPTIMIZER_HIDE_VAR(dest);
+
 	insn.opcode = opcode;
 
 	if (size > 1) {
 		insn.disp = (long)dest - (long)(addr + size);
 		if (size == 2) {
 			/*
-			 * Ensure that for JMP9 the displacement
+			 * Ensure that for JMP8 the displacement
 			 * actually fits the signed byte.
 			 */
 			BUG_ON((insn.disp >> 31) != (insn.disp >> 7));


