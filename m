Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0729337110;
	Fri, 17 Oct 2025 15:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713315; cv=none; b=UEmz0gJ+MQ1PWpjsuCVyO8fCO2nY1WlHjaZLdOdB9uHwP6iqv6r+iZXe8NWm8P14HlfbJMW02WSUZ8QHJdH8TBZEIX7EUhKc7+UWETmnlTNr3Lg3EhFz93jHP4L4EcsNZxjGH6hRV1wQHHWE9Cl2kjl+MincOw5KntQ5UkWppY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713315; c=relaxed/simple;
	bh=I2XROb0I+Ecp3pnIbPr/0z2oOdylK4w5DFL33inBJ2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEWs8Rru72PEgJ0N5WTOiw9p5wRYceVVz043eNUe2BTRuPA8jBlGU/Lg4RvN3rSWZHO22cjxqsf/UMKs0clBfb7pov5hfdM0eB5Lqz87acHCog+NXdCOJnh/1QeP4KU1RERMDkWfq0k/C04rpQt+lbrY5cPoytWs52NmdfnoxsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDUk52rO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDUk52rO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C289C4CEFE;
	Fri, 17 Oct 2025 15:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713314;
	bh=I2XROb0I+Ecp3pnIbPr/0z2oOdylK4w5DFL33inBJ2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDUk52rOMr58o6ZIz+ccfCRjuVmstKMaFBd4tebz7zfZf5WPJrJ1RORuQc5B7j2Ai
	 yk2iaziWGr4zZosqcZOuNXvNAbhM7KQIssuXzZ7Y3p77xmFqWRUHkvjIRHAkPCIu6R
	 5nSv1/NMFN5gfjNRSzCxSI6g8n6/dOBtXndpEw5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Snyder <dansnyder@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 121/168] x86/umip: Check that the instruction opcode is at least two bytes
Date: Fri, 17 Oct 2025 16:53:20 +0200
Message-ID: <20251017145133.483039113@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


