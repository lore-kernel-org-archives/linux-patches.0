Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D303328EE;
	Fri, 17 Oct 2025 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713843; cv=none; b=ZD26JmTLA0rMewWs2KAuXHbgZSzcxZVHj1aP60YAzt/vUDvn22rP97m5SM0XWbUV8BU5N8ZlB7/uy1qOGFhmEUjUIlHruuSQbdQxPJ8jrbpU+Dat0gR6fhB1e6FU55UkSAtgn6phl4UdpprCFVcNOidn0LObOth5achKxFszZ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713843; c=relaxed/simple;
	bh=Z48An+sFSpjUxoFkyrNfamoTOygVS6J50AvalY4/lp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyvd0Qc2rdGtOOhnMEKJn9OshHQued0TiAjTEPhpIS/Dvh/HrGBMYZ43M2JTaN0Ty0HdjiDNo4as/NM5Jo6VaHxrSu58y6NVEBL04PsZJaCFOlQNp+TLVZ2AC9jgIuUIZSwctNFRgF67inzYe5d1yc84O5WSnuaC7Px9yprO3ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyMEbJyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyMEbJyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CBFC4CEE7;
	Fri, 17 Oct 2025 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713843;
	bh=Z48An+sFSpjUxoFkyrNfamoTOygVS6J50AvalY4/lp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xyMEbJyTzh5x3vHQRtHX0or8eYor3DGmtJl+jbespxtOzU2yL+od19YdGfBMGWb0X
	 qA/7y+wT7BLl7Ie601M6Zcnzhm1C9Ui0jwClEbneiMORL+7DuY5HUegtebuEY+E4Bm
	 t4kUrwGF6hBEPUCKb8EX2A3J6hV3GM7+GKK4l6n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 139/201] x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)
Date: Fri, 17 Oct 2025 16:53:20 +0200
Message-ID: <20251017145139.842300583@linuxfoundation.org>
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


