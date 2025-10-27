Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE6B27978C;
	Mon, 27 Oct 2025 18:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591354; cv=none; b=b1Cin3eM7qaswyuUu0MNgOxXjpT23x3tKpYyJw1zcguDk/DfcM5O3mU2Oe5m0AWq+mDXy8uLOdSwsnStdIx1tqczWd4y8M30JcBEiYfRykvWG6cgmSvcV8PxaoBqTFQaDIHcTRBKRU0or7G6PAlPsYlWH5PkkIYiP7faSWWTapA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591354; c=relaxed/simple;
	bh=32xISfZiuIauxgjB43U4/YKrOcAymFXWfsNsuBk7V3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja3j+/8RAQ4T+Hxb0FbwMAA7/HcsurG47R26O6iG6uSYIjdDAmGr0gy9FaIJmSoG69R92RVrXG2Whkz1fkz3XmsFTqc7dRuF3hzaa3KH7FfWwsn0bVva6LC/Df1uSBmz6juytBUiBj0dhjPgpQxUy+wiLgmy7NQVfwt88XmOfEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6H6zwgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6H6zwgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFDCC4CEF1;
	Mon, 27 Oct 2025 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591353;
	bh=32xISfZiuIauxgjB43U4/YKrOcAymFXWfsNsuBk7V3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6H6zwgFIj493Nvv/9eLAatlt1oCAdhumYsg8+HhCdqQdrjS5XQ5uatOTKsdTqpS1
	 Yt8KyJqeXpAnKEKLZz/1CLcVPt1BFUlIwLaV/f88IXzyEJ2TaYEKefvoFzr7Q/EQZe
	 BHrYC2ZMC/hGQdQACIAqAkOW/2DB306/seNq7Jn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 165/332] x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)
Date: Mon, 27 Oct 2025 19:33:38 +0100
Message-ID: <20251027183528.984041451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 27b1fd62012dfe9d3eb8ecde344d7aa673695ecf upstream.

Filter out the register forms of 0F 01 when determining whether or not to
emulate in response to a potential UMIP violation #GP, as SGDT and SIDT only
accept memory operands.  The register variants of 0F 01 are used to encode
instructions for things like VMX and SGX, i.e. not checking the Mod field
would cause the kernel to incorrectly emulate on #GP, e.g. due to a CPL
violation on VMLAUNCH.

Fixes: 1e5db223696a ("x86/umip: Add emulation code for UMIP instructions")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/umip.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/umip.c
+++ b/arch/x86/kernel/umip.c
@@ -163,8 +163,19 @@ static int identify_insn(struct insn *in
 	if (insn->opcode.bytes[1] == 0x1) {
 		switch (X86_MODRM_REG(insn->modrm.value)) {
 		case 0:
+			/* The reg form of 0F 01 /0 encodes VMX instructions. */
+			if (X86_MODRM_MOD(insn->modrm.value) == 3)
+				return -EINVAL;
+
 			return UMIP_INST_SGDT;
 		case 1:
+			/*
+			 * The reg form of 0F 01 /1 encodes MONITOR/MWAIT,
+			 * STAC/CLAC, and ENCLS.
+			 */
+			if (X86_MODRM_MOD(insn->modrm.value) == 3)
+				return -EINVAL;
+
 			return UMIP_INST_SIDT;
 		case 4:
 			return UMIP_INST_SMSW;


