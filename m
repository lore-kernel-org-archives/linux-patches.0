Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AF4E4302;
	Tue, 13 Oct 2026 11:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892723; cv=none; b=oCTWk0SJ3US06AEin+2cCKlDgAjX80Bg2VPChlS9Wn8fExlfLaZOc1l1Gu1uF3Awlq3WSKEZ5QUXrlFGLs4k30pZ7rTUYdz8T0ErNM72PXCtl5YL2wdTlrQpTraf5RyGvGuMjqdS1ShGeqTYFnsYG9OdB7FVNwzXlwLLjAh4bG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892723; c=relaxed/simple;
	bh=ayq7wAD6ISR5fm/BSFG4CD1gOuqwOwzNmxvUTyYmjK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYHTM2FLxIWQ2DIImjzMPuzyqaWu1oFhZs2E0Qzdr+ATUddkEwWvFnTbVs5U4xpLCwhUJT1lhxId5XcQJ3eF02xEbK5vKq9qzaxP4+tm+m0aR+puz4vpxKrrdCUJOKMbIPEHQFP2IWobNLQ+HrUbD0IoBW2RsfdU+CIz8mNnDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM9/XQRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM9/XQRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D081F008A2;
	Tue, 13 Oct 2026 11:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892722;
	bh=uaSQMKpz4QWux+CD72ZMlOrcokS/PpNhcJmwgwJUeGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CM9/XQRAZlM/OT3dgsiZh9HHst9vzI1TrkH5sGgAVc6VBirzug1enQmKRb6KGmt9h
	 NGy24jHWcufHrrj0mKENE+yyvFqvLdS2RM+mQLVgXTHrGTPkFu9APgiHVPvmiPW3Op
	 JDOjH9Zo5OSkGpyyxamHBTbRlNWFRMPDcGRmA5s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	"GUO Ren (XuanTie)" <guoren@kernel.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Andy Chiu <tchiu@tenstorrent.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 224/281] riscv: vector: Fix data pointer constraints in context save/restore
Date: Tue, 13 Oct 2026 13:39:00 +0200
Message-ID: <20261013112900.591369103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.dev>

[ Upstream commit 572b25f3a6453d8e7fc28cc0cefe41ed15be166c ]

The standard vector save/restore asm advances datap but declares it as
input-only. An inlined caller reusing the original pointer may therefore
use the advanced address instead.

Declare datap as read-write so the compiler can preserve the original
pointer when needed.

Fixes: 03c3fcd9941a ("riscv: Introduce struct/helpers to save/restore per-task Vector state")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.dev>
Reviewed-by: GUO Ren (XuanTie) <guoren@kernel.org>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Andy Chiu <tchiu@tenstorrent.com>
Link: https://patch.msgid.link/20260908-riscv-vector-asm-fix-v1-1-147f314efb2b@linux.dev
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/vector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 00cb9c0982b1a..e94f81cedda56 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -225,7 +225,7 @@ static inline void __riscv_v_vstate_save(struct __riscv_v_ext_state *save_to,
 			"add		%1, %1, %0\n\t"
 			"vse8.v		v24, (%1)\n\t"
 			".option pop\n\t"
-			: "=&r" (vl) : "r" (datap) : "memory");
+			: "=&r" (vl), "+r" (datap) : : "memory");
 	}
 	riscv_v_disable();
 }
@@ -261,7 +261,7 @@ static inline void __riscv_v_vstate_restore(struct __riscv_v_ext_state *restore_
 			"add		%1, %1, %0\n\t"
 			"vle8.v		v24, (%1)\n\t"
 			".option pop\n\t"
-			: "=&r" (vl) : "r" (datap) : "memory");
+			: "=&r" (vl), "+r" (datap) : : "memory");
 	}
 	__vstate_csr_restore(restore_from);
 	riscv_v_disable();
-- 
2.53.0



