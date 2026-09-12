Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1374D4BEE32;
	Sat, 12 Sep 2026 11:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212185; cv=none; b=Cu6XD+frHgjFbavf+JGT+9avUmiLfJB3BM8AM//FCEhNgDo35FzfY5dB07ntOs7wc7NICuHUTCqoYqgTeIgeih3uK+6mEUxeczJomWFG/dsmzYeEBMD3bveQobtYbkqYhzRUNQlC9/m99r2coqgJ2LK/EE4KDSVCk2uPX+nJiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212185; c=relaxed/simple;
	bh=6EvIR7BD64THznDGPraQX+9RMVkQcERLvuxvCk+oSno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBR5dnvBMKk2mNETDftsQNP1ng86SL4x8I0vMYXsK1JtfxrtXuQfp5gZStWD6FVEyDmYqPRBpzu4vPUkZKwJ0WJEAyaZdKKQGLLW45ZK7K+Hwxzirr2ZC4nP7lOEfiIyAYBgcO4Ly3Igxh+am3pSg/I/CwBGig0BzFBzu2N0jlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqvRWAUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqvRWAUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA911F000FF;
	Sat, 12 Sep 2026 11:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212184;
	bh=2wmKFgm8/b31MV5EjgVBLiFh40WDl6BOryesmyWR9Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqvRWAUqH4Ssn4VfMjchhIk5VnMcqdRvL5CW2RSXeGWY4gavMH9gcf4uHo2aG6LRZ
	 zVqkyzGGEd2DGtV8mK7xr5qrd5BX9nwco9lWWDV1yRDx6kgCl4aVGbJmNGI7heQV+j
	 nQq8kp/Ok1rJPJVLcA3zqgcK2chhRh4rjtkd/lGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1386/1518] arm64: process: Fix context switching MTE store-only tag check
Date: Sat, 12 Sep 2026 08:59:15 +0200
Message-ID: <20260912065654.901432846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit b8f070ac3167595069feb1f794c127b805115645 ]

SCTLR_EL1.TCSO0 is set when user opt-in for MTE store-only tag check
mode. However, it is not part of SCTLR_USER_MASK which imply that on
context switch we never clear SCTLR_EL1.TCSO0, so we are leaking that
setting into another task.

Fix that by including SCTLR_EL1_TCSO0_MASK into SCTLR_USER_MASK

Fixes: 4d51ff5bba00 ("arm64/kernel: Support store-only mte tag check")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 61d62bfd5a7bf..ba0517d80fa56 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -256,7 +256,7 @@ static inline void task_set_sve_vl_onexec(struct task_struct *task,
 
 #define SCTLR_USER_MASK                                                        \
 	(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCTLR_ELx_ENDB |   \
-	 SCTLR_EL1_TCF0_MASK)
+	 SCTLR_EL1_TCF0_MASK | SCTLR_EL1_TCSO0_MASK)
 
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
-- 
2.53.0



