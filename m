Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6E7330B21;
	Fri, 17 Oct 2025 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715683; cv=none; b=HNzfb21UhVpaxlF8tzeckljncYrr/I15PnRzqF4bOHPT2PIFksV2UDlzxLknE69F24M2yc3X7Y7SXehM91NT23xau7vdzXhxcJK83laUZ1Q3zpuYSoRYvpVV8utkFVWLym876egs1aqNc3CIU9bc9V0Tdn6Xe298CX7oa9lEW7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715683; c=relaxed/simple;
	bh=agoHfRWVX1Nvfu/m0Wz4yJV77PPUkugxVOzI/vuhmaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyTtfjBybUFkFiq0wquOUN+Ecvo2YZzSuPkDjIpTSUq2272Kzh7TnFfavG3r8HF/ZEtJQrSJcy8P0Adw/QPz7h35nML5sXwjskdfsb3SUJOAFsJLinbUAVMKRBJovpaAtMmjxZiup6isKVt+/nb6pZagjloXg+wY4dUrKoUT6kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F81MaSy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F81MaSy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377E4C116B1;
	Fri, 17 Oct 2025 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715683;
	bh=agoHfRWVX1Nvfu/m0Wz4yJV77PPUkugxVOzI/vuhmaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F81MaSy50Z2t62cUifxi8uij5lzg4mWC7DoPIHxu+YW7tYSpnPCCH9ddO1sejjY0G
	 LqZFUMIqGQAiUO0m1xTwAYzRtvll6PqwbzDGDYHDvHCF5rp36uh5dCmtNPWyshgl+c
	 qqv46G3+DulHVb/B/Fc0GyF++O0MN3z8V56609nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.17 300/371] x86/umip: Fix decoding of register forms of 0F 01 (SGDT and SIDT aliases)
Date: Fri, 17 Oct 2025 16:54:35 +0200
Message-ID: <20251017145212.928889941@linuxfoundation.org>
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


