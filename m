Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489003BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBeda4f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39A0C433CC;
	Wed, 15 Nov 2023 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076320;
	bh=jpHPM3K2Z6X52x515AHgE+Mu+q6Y4mBoWM9wyqFsYOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBeda4f/RJjlP3phNDku2CmrZVrSBBKStJlrLj/ByEsjtBGugEUcu3+VQbf6fNojd
	 uqoQwUyRe9xmwD+uChz2+blEJfBApfHg5N01CI8IVN0XmU0hSPhJ7qpi1ZyCAcfMwS
	 DJGEeEMVZUNOeqjB+E/LLMMNNF3rUKBXV1w8exfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 216/550] x86/tdx: Zero out the missing RSI in TDX_HYPERCALL macro
Date: Wed, 15 Nov 2023 14:13:20 -0500
Message-ID: <20231115191615.725197649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit 5d092b66119d774853cc9308522620299048a662 ]

In the TDX_HYPERCALL asm, after the TDCALL instruction returns from the
untrusted VMM, the registers that the TDX guest shares to the VMM need
to be cleared to avoid speculative execution of VMM-provided values.

RSI is specified in the bitmap of those registers, but it is missing
when zeroing out those registers in the current TDX_HYPERCALL.

It was there when it was originally added in commit 752d13305c78
("x86/tdx: Expand __tdx_hypercall() to handle more arguments"), but was
later removed in commit 1e70c680375a ("x86/tdx: Do not corrupt
frame-pointer in __tdx_hypercall()"), which was correct because %rsi is
later restored in the "pop %rsi".  However a later commit 7a3a401874be
("x86/tdx: Drop flags from __tdx_hypercall()") removed that "pop %rsi"
but forgot to add the "xor %rsi, %rsi" back.

Fix by adding it back.

Fixes: 7a3a401874be ("x86/tdx: Drop flags from __tdx_hypercall()")
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/e7d1157074a0b45d34564d5f17f3e0ffee8115e9.1692096753.git.kai.huang%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdcall.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/coco/tdx/tdcall.S b/arch/x86/coco/tdx/tdcall.S
index b193c0a1d8db3..2eca5f43734fe 100644
--- a/arch/x86/coco/tdx/tdcall.S
+++ b/arch/x86/coco/tdx/tdcall.S
@@ -195,6 +195,7 @@ SYM_FUNC_END(__tdx_module_call)
 	xor %r10d, %r10d
 	xor %r11d, %r11d
 	xor %rdi,  %rdi
+	xor %rsi,  %rsi
 	xor %rdx,  %rdx
 
 	/* Restore callee-saved GPRs as mandated by the x86_64 ABI */
-- 
2.42.0



