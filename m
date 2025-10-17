Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78EC23EA9E;
	Fri, 17 Oct 2025 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714579; cv=none; b=fj9Tg1bYprOk03BiA26TRPPYs700NHfvI+rXamIkjziudsSnOOJ8/NP7KqKKFSwZ4LQGW3lMFdg2NIwQllHVi6mFXtNsg8y3nkzdBnE3lpSIo1B5Bms78Lid0XdGi9ykbHxwDEJKQPRjdVc4gywhTfe1CKk8TtKfYWe4AhENOkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714579; c=relaxed/simple;
	bh=+P3+/LSxenvSyjWk2ZLyFlXLMh81Jx6M3gCB8bYOPmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQJZK+fzNJfLsFi/D7vbwFigfrOgJnLDI/DCPWaxQxPe4ADCofJZcuj9yzCKvDFmxvYrLKrGyE2gQTyxw1bjk9nu3Ipdxit35+nqlzj3YotuU8hMhniyZcFZbEKpxiZ9n44kOag1GJ2sZcLmu+qZOVIPYSNOdw2+2FFzbhC/sBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI8VSxHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI8VSxHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE48C4CEFE;
	Fri, 17 Oct 2025 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714579;
	bh=+P3+/LSxenvSyjWk2ZLyFlXLMh81Jx6M3gCB8bYOPmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI8VSxHPBjT6ix/bAmO0Wt7KcKzGoDUL0prD4T588UGauzHHm4qApgVI0ZanCjC09
	 bBjQ5b9hfkQnXo46TMXmewC6fiiAa1FdIBd/sLtIuaw9ev5AqZIUnW1NpvrX6uzEU+
	 iWeZJ38n4kfebXS30dtvKXRchozoCbQyg5DbvZDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Snyder <dansnyder@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 194/277] x86/umip: Check that the instruction opcode is at least two bytes
Date: Fri, 17 Oct 2025 16:53:21 +0200
Message-ID: <20251017145154.204953080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sean Christopherson <seanjc@google.com>

commit 32278c677947ae2f042c9535674a7fff9a245dd3 upstream.

When checking for a potential UMIP violation on #GP, verify the decoder found
at least two opcode bytes to avoid false positives when the kernel encounters
an unknown instruction that starts with 0f.  Because the array of opcode.bytes
is zero-initialized by insn_init(), peeking at bytes[1] will misinterpret
garbage as a potential SLDT or STR instruction, and can incorrectly trigger
emulation.

E.g. if a VPALIGNR instruction

   62 83 c5 05 0f 08 ff     vpalignr xmm17{k5},xmm23,XMMWORD PTR [r8],0xff

hits a #GP, the kernel emulates it as STR and squashes the #GP (and corrupts
the userspace code stream).

Arguably the check should look for exactly two bytes, but no three byte
opcodes use '0f 00 xx' or '0f 01 xx' as an escape, i.e. it should be
impossible to get a false positive if the first two opcode bytes match '0f 00'
or '0f 01'.  Go with a more conservative check with respect to the existing
code to minimize the chances of breaking userspace, e.g. due to decoder
weirdness.

Analyzed by Nick Bray <ncbray@google.com>.

Fixes: 1e5db223696a ("x86/umip: Add emulation code for UMIP instructions")
Reported-by: Dan Snyder <dansnyder@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/umip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -156,8 +156,8 @@ static int identify_insn(struct insn *in
 	if (!insn->modrm.nbytes)
 		return -EINVAL;
 
-	/* All the instructions of interest start with 0x0f. */
-	if (insn->opcode.bytes[0] != 0xf)
+	/* The instructions of interest have 2-byte opcodes: 0F 00 or 0F 01. */
+	if (insn->opcode.nbytes < 2 || insn->opcode.bytes[0] != 0xf)
 		return -EINVAL;
 
 	if (insn->opcode.bytes[1] == 0x1) {


