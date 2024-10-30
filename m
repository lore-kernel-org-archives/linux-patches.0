Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390B7214411;
	Wed, 30 Oct 2024 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304903; cv=none; b=mY4KXe7m+SKW6Uj/e+XeFhD05G3rspt42sCYYThywNrqkLXjx+J5XT0ABlaILvhU0G8eJsHMSFarhr20yNg38qlUemoYZprYmqih6hcf5IRaVds60MDFl3F57zxsY6zguAEdrDg3e2n0aMOwnDomn0BDjPnZCPrunVmvJcjctuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304903; c=relaxed/simple;
	bh=QA5Hm6zU7DWvsI9d6sL319bCBzh/lWPyKSYFlfm55iY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Spmu+1G/xihgpedHsIdq+N/TyBTMKPqArzZijR+DUKulpQwbxFUwSwgbMWLl1PAc1b8s3GF2CUEVBYqXZIcirP4Ymbd49E7akPbds/eCHVjQolfPynHnuB/Wz7jsCvmueWtrWnM2jPFPFzOyJd7FqJpyMhkELs5r2cuoLOeoFqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EDCK9r8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EDCK9r8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CABBC4CECE;
	Wed, 30 Oct 2024 16:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730304903;
	bh=QA5Hm6zU7DWvsI9d6sL319bCBzh/lWPyKSYFlfm55iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EDCK9r8MTIP6/VyhTQ5cgm26nN38X3omQjia5LzaZ0KLHo56S9OMmuKRCwXmrQjb0
	 c56FQf2eyTMrHBk1amu1STt+57zJtEw/5ajvivLsiii2Visdv9Da40CHUYOIWtugfD
	 g11G/kk6h7Ww3QhjEbFlwwp3tjEXHSMEQ0vPK6gTdWWlkotwG55JhsLnI14qljbo+i
	 IDnxLoEjC5v8SuKblj5uZgg0qOxXtRd4ijW1uY3+tjiby5t7uw2ci7j/mSwiSwM/L/
	 PMz3Afcdi48IGL1FLvDw+LBOcGKGj5Br8ZEi9XVwLWrL754LHDdOUQMynbrzO7uIzw
	 ER5ow6GuhIYBg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 30 Oct 2024 09:14:49 -0700
Subject: [PATCH 2/2] kprobes: Use struct_size() in __get_insn_slot()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-kprobes-fix-counted-by-annotation-v1-2-8f266001fad0@kernel.org>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
In-Reply-To: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
To: Masami Hiramatsu <mhiramat@kernel.org>, 
 Naveen N Rao <naveen@kernel.org>, 
 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1430; i=nathan@kernel.org;
 h=from:subject:message-id; bh=QA5Hm6zU7DWvsI9d6sL319bCBzh/lWPyKSYFlfm55iY=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlK0S0nN/Z2XxY/Yzk7jr12etBidvvko9OiGLQfHvYv3
 rFzVdi1jlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRbAmG/4XJa7/VvBJpLlvm
 18GZ8C7ulhpjSfnPawnsCg1eTI0P+Rj+GeiLnzqdLDWpQz1rio3uxL4Ps9z8v/S+ZXxgGpAvezC
 dFQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

__get_insn_slot() allocates 'struct kprobe_insn_page' using a custom
structure size calculation macro, KPROBE_INSN_PAGE_SIZE. Replace
KPROBE_INSN_PAGE_SIZE with the struct_size() macro, which is the
preferred way to calculate the size of flexible structures in the kernel
because it handles overflow and makes it easier to change and audit how
flexible structures are allocated across the entire tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 kernel/kprobes.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 2cf4628bc97ce2ae18547b513cd75b6350e9cc9c..d452e784b31fa69042229ce0f5ffff9d8b671e92 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -95,10 +95,6 @@ struct kprobe_insn_page {
 	char slot_used[] __counted_by(nused);
 };
 
-#define KPROBE_INSN_PAGE_SIZE(slots)			\
-	(offsetof(struct kprobe_insn_page, slot_used) +	\
-	 (sizeof(char) * (slots)))
-
 static int slots_per_page(struct kprobe_insn_cache *c)
 {
 	return PAGE_SIZE/(c->insn_size * sizeof(kprobe_opcode_t));
@@ -177,7 +173,7 @@ kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c)
 		goto retry;
 
 	/* All out of space.  Need to allocate a new page. */
-	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(num_slots), GFP_KERNEL);
+	kip = kmalloc(struct_size(kip, slot_used, num_slots), GFP_KERNEL);
 	if (!kip)
 		goto out;
 

-- 
2.47.0

