Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051851419B3;
	Tue, 27 Feb 2024 14:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042807; cv=none; b=scVQnAtQ67qf6OvWR28Vzsmxb0a/5IQhv4sPX4i0vskGoIV0Wjo9dkMfCwqc/KLX2tJzrnKwg7O7Yckkzew7b8jiFNwKD7PFGbkVR9C64O38GS9ZTIKkJpAmLy+D7vluQ9ZZgIKsaqqdQcQXpUV7LZjV5pLKHX6/y0ZVYEshvTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042807; c=relaxed/simple;
	bh=yc5VoNL/76+UTiByLQnELsSxGAKlVZ36T2TlA1j1F0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRizUs7XCwssWjdgzU4+v0VLHbgLQ8mBVUHwDFOBflleHaHen1AHji2QXS3o/rc4iWOn4RmQQtscDcCO4A1iUKjGU4+1RAgSD/REtRuJe2h6HonBHCz/14gEgUay0khF8Ok0H9lJFdToL1eveVOkTjRYWBZVaBIzq1tvaz1dQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plyggh/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plyggh/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D810C433F1;
	Tue, 27 Feb 2024 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042806;
	bh=yc5VoNL/76+UTiByLQnELsSxGAKlVZ36T2TlA1j1F0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plyggh/fR5zu7Cv5gIewUX6nqocfDpK5BFnO9hIjupj/V0xjG0eHbnBMRUlvRklXG
	 rqtm8Z2+LbauC91SL+yKi1xn7UqApkye5mngFyPyiEa9xOAVQNaCsqA7aNlXY18Kvz
	 tfilLH1h6trSQndzbtcpmWT8Ss+01SfKjnKS5pJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 089/245] x86/text-patching: Make text_gen_insn() play nice with ANNOTATE_NOENDBR
Date: Tue, 27 Feb 2024 14:24:37 +0100
Message-ID: <20240227131618.120165542@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


