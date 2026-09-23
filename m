Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C375350B429;
	Wed, 23 Sep 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174390; cv=none; b=EDNN1xTFPnSX9rzo+QZDEH3FaqDv1vZXswX8RDyi4kd9MBxEMQ5qBolU4wWXEVHL27HQti96+HnP4hl5WZrB3fvJzXBf6b/Qqjuywbx0NTsFYAlONywTQJWaR5xUEGymR2y65n3n6G72fpGiLP38chO0w9budPrUuYP6tFLyy5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174390; c=relaxed/simple;
	bh=ELECzpTZ/+YEIn7WkbGabmKgj3+qfpUYhDC3hSjf/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WD/p4WB1UHi6n7kWSFoCTdvDUJiR5wi5TfOShvD28RBbb5p5jEgxCNptu9e96wXZvf5tCQkEeCH/0a3FX5H5H211I730lwb0M2fisKb8pmT40GrGwn9ZSvjnzLFQI3anQYWHKjVl4jKwPmzn+q2rGRVmEXHRsYfwG8Qz7x+niyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqFjZHTL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqFjZHTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89061F000FF;
	Wed, 23 Sep 2026 14:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174389;
	bh=TgwTZ5AkhfBy/8327QPegFIUertMcPTa9n2IAtf+38w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqFjZHTLJedUfGhVB1n70g+I4MUQgl0QbQurY4NRi8bZCWO6J/9cbTxygwW9T8Qfw
	 alvHsDkErzggQc22CmjkE3l6r2l0h0mVy/ybMUn8xipuZlPM6/LZQY94iEIFH6Tmnd
	 rCvDi/P60W82bR31xWqy/D4yF3bG9ujFOtxikW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/398] arm64: hibernate: clone only the linear map that exists at runtime
Date: Wed, 23 Sep 2026 16:02:51 +0200
Message-ID: <20260923140645.953278382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e4a6f57d22e079e23fafac51057fad534160b269 ]

This is similar to commit 1537e55728ec2 ("arm64: trans_pgd: clone only
the linear map that exists at runtime"), but in a different place.

swsusp_arch_resume() clones the kernel linear map with
trans_pgd_create_copy(..., PAGE_OFFSET, PAGE_END). PAGE_OFFSET comes
from the compile-time VA_BITS, so a CONFIG_ARM64_VA_BITS_52 kernel
booting on hardware without LPA2 -- vabits_actual is 48 and the fifth
level is folded -- hands the walk a 3.9PB window while its linear map
only spans the top 128TB.

On a VA_BITS_52 4k kernel with CONFIG_KASAN_GENERIC in a 4GB VM, I see:

  swapper/0: page allocation failure: order:0, mode:0x920(GFP_ATOMIC|__GFP_ZERO)
   hibernate_page_alloc+0x10/0x1c
   swsusp_arch_resume+0x70/0x320
   hibernation_restore+0xa4/0x138
   software_resume+0x15c/0x270
  PM: hibernation: Failed to load image, recovering.
  PM: hibernation: resume failed (-12)

Fix it by copying the linear map that is the actual one, not the
compiled one.

Fixes: a6bbf5d4d9d1 ("arm64: mm: Add definitions to support 5 levels of paging")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 7bf1174277772..424291c547f02 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -423,8 +423,8 @@ int __nocfi swsusp_arch_resume(void)
 	 * Create a second copy of just the linear map, and use this when
 	 * restoring.
 	 */
-	rc = trans_pgd_create_copy(&trans_info, &tmp_pg_dir, PAGE_OFFSET,
-				   PAGE_END);
+	rc = trans_pgd_create_copy(&trans_info, &tmp_pg_dir,
+				   _PAGE_OFFSET(vabits_actual), PAGE_END);
 	if (rc)
 		return rc;
 
-- 
2.53.0



