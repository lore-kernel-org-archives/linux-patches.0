Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA302330B16;
	Fri, 17 Oct 2025 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715681; cv=none; b=StP3aj+onlH9/Q+A/ig0VFFcUvNWzY3StN+e0tsPQU6/3xx+l4Lg/QbUcrx4tBmf/Yi/yj4sTVdaO3trIPGmh2/GfSbqNjvp23NPJLUt20sp8EyIiDfzMETSqroI1EZHWMgJrTF4zshg8MHOgk9CxBKhz34nfZMm4oPghmvpBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715681; c=relaxed/simple;
	bh=mx0p3lHdAJXxGYkQop027kXvS72EfBV7Y/SFGExBV9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txklrszjoTLvdDJnuVlgXuC5rKRgj1eYoJX9gXJ/emJt6OaPIV0lFOb6OJkLSSuyhC+j2gkbdZAb6G36y7HrrCWkhGoq8T4TdA/jxOmJrNV3iCXd4ziO9spWRms9wA1SlnEPLB1y/rRpeypnarUr231GC03mVo7nbamTLHqcja0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CseDtQgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CseDtQgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7E0C4CEE7;
	Fri, 17 Oct 2025 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715680;
	bh=mx0p3lHdAJXxGYkQop027kXvS72EfBV7Y/SFGExBV9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CseDtQgnpVafAXGTsfN+oHEj092NmbeWMShYNDr5/3YvKQVlGtIkG0zNAcjLxzBsF
	 U49lUcVmHL99EUJZgr+WNtDg7i+iNhWX619T3g7aI8XbTKFglv44R47F/IQcau9i/z
	 poK0yL1O/TXVrTk7Pj4MABIxTynqV7z0YwwhDySw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Snyder <dansnyder@google.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.17 299/371] x86/umip: Check that the instruction opcode is at least two bytes
Date: Fri, 17 Oct 2025 16:54:34 +0200
Message-ID: <20251017145212.892573612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


