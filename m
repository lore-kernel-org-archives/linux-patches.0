Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9803328FA;
	Fri, 17 Oct 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713840; cv=none; b=MluDyH/z7/NWFN8sUn68XO7/gV5VaS6+c77H3XDwo7Iub+ZPzBfDqO4OUFAkGsDTl2fzjW/hTt0lRW0BQxvQxfc+Z+FIx7olcGop9nqH2XsRwbTXYHF+GW1WHJqE9PTZZx16AQT/av/xLRlDArUhhU5HY/4E3M4aUtiHBxGYuWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713840; c=relaxed/simple;
	bh=s4vUtHLfPiS3rucQZNeP8UDDNqHMYGRMPvApL5ESWw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI9ZqSjgZcL3N9J3oM4PhnQ1WozwZtfJTcBboLI9sj+q9Xb4UynO+TIH4KXo35VUI3vY4CmPR2ENcXMtouTn59xPI7doR8PnNyAbrhzfvICKjYLew/fiRw5KI+nA0JEFhDrTckjU1HT+JqBoDM5VtjaKNJnJDm2ftR+o9N2QtL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w0a782w0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w0a782w0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E35C4CEFE;
	Fri, 17 Oct 2025 15:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713840;
	bh=s4vUtHLfPiS3rucQZNeP8UDDNqHMYGRMPvApL5ESWw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w0a782w0kUDZfTwj2e6HRkyMNi/m3vCkZ5LkMOMO9kxDQ+UbcjjemzPMEEy4WATux
	 xhuxyilw1kXSYYQXyR9+0BqiKypTYTbDlNaiJJPCoqaqt4N6xpRaZeb638q9e3g4xc
	 1cI1t4O7xRb630vGZekWF4kIGn/WfwtNqwFIy+zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Snyder <dansnyder@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 138/201] x86/umip: Check that the instruction opcode is at least two bytes
Date: Fri, 17 Oct 2025 16:53:19 +0200
Message-ID: <20251017145139.805977895@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


