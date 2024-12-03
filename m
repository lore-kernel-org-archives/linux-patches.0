Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4B1F75B3;
	Tue,  3 Dec 2024 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240292; cv=none; b=dCeqv4RkhTyKB8K064it1tTbIuufyZhJsK0ctM/1FOmlveEzoXrrwxIAevO56BBYVbchadRqGITOh8hQihGZgHNLDlUQtJN7yNKbdTI40TCvFJFDD5XnkCC8q2tQLCU2q5oDVAAXAdM7YlokLSSaaJvXMdUp7E94iyHZSrG//f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240292; c=relaxed/simple;
	bh=MLbYuqojmIMyjw3NIm7/+xAAS8Hk8gZREAjmgNtRg7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laJy9RHaWPEg+ltbixNbQiQj9/lX8Q67Wwic1r0Tk+rXfs4eHB2pA1m61m7fWa68xFlnPDja7VaW0vmRRD9QNBRY2SvDZ7g21rMmc4v//1naQLCrtBiXn01KHDkkpB1CrXnJn3ZcyZnad0Fpq1qnPesvpEuNtl+P8K16LFgVbWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ugd/EVcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ugd/EVcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCE0C4CECF;
	Tue,  3 Dec 2024 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240292;
	bh=MLbYuqojmIMyjw3NIm7/+xAAS8Hk8gZREAjmgNtRg7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ugd/EVclBOS6lXjWvNvX/Eo6ld9lbzXFvQuc3cbm6EIiskquqsleEg17dfBzP3GTt
	 6QozjnRNgpKBa3stb+BdIGwAgX8dg3T7L5VaY4OCAEeMBwkTBgBEzPWNsXlqgrrKUV
	 TgLMO6zxKWxVXl36+G1tkjCSVLq/kwdiD1bFHoGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/826] locking/atomic/x86: Use ALT_OUTPUT_SP() for __alternative_atomic64()
Date: Tue,  3 Dec 2024 15:36:56 +0100
Message-ID: <20241203144747.202996971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit 8b64db9733c2e4d30fd068d0b9dcef7b4424b035 ]

CONFIG_X86_CMPXCHG64 variant of x86_32 __alternative_atomic64()
macro uses CALL instruction inside asm statement. Use
ALT_OUTPUT_SP() macro to add required dependence on %esp register.

Fixes: 819165fb34b9 ("x86: Adjust asm constraints in atomic64 wrappers")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241103160954.3329-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/atomic64_32.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 1f650b4dde509..6c6e9b9f98a45 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -51,7 +51,8 @@ static __always_inline s64 arch_atomic64_read_nonatomic(const atomic64_t *v)
 #ifdef CONFIG_X86_CMPXCHG64
 #define __alternative_atomic64(f, g, out, in...) \
 	asm volatile("call %c[func]" \
-		     : out : [func] "i" (atomic64_##g##_cx8), ## in)
+		     : ALT_OUTPUT_SP(out) \
+		     : [func] "i" (atomic64_##g##_cx8), ## in)
 
 #define ATOMIC64_DECL(sym) ATOMIC64_DECL_ONE(sym##_cx8)
 #else
-- 
2.43.0



