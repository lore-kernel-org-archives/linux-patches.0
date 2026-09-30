Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AB836A37E;
	Wed, 30 Sep 2026 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788338; cv=none; b=L0bTT1f+fqjLGY2GZ/plqUA5+j0BjEV1RNAPMYAfo8NQOiR3VygD+uD26vPt9/5KeFmdUGyplzUMAmb/i3guKC+h2UfpraCwiwg+uNKgyUvp2qtQNpeHXlW36UrY4+S0Iv3S8KRHkGytKFBjj8VC+PRGaGNWasNDWnrtqx3OKS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788338; c=relaxed/simple;
	bh=weF+emfsBStsULA41RyXSttvMazxbfeoycCxkPDAMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVkvFnudmescMLHJjvXTCF8eKrzyUo+NI/I82LbEbfp34P2Si4l5TUiGfaRZmHZvf9VlMm7xBpduVM9J0FYcAM6bbH41NiEUzsc+DPxkPsQKMJK7JROUlf3/2W8DFspQdoaE14VTwcAaop/6Tn5MW8aAA2UjDmZjB4jbjd/9U+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H96ijsj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H96ijsj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4AA1F000FF;
	Wed, 30 Sep 2026 17:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788336;
	bh=/cKmn04GJ2+ebD+j5/Y1qixpkTFWgFA+xZYin2k6F/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H96ijsj4M1vq74k50K9oIkSweqq5NHbvTJTJSdgs3A2fEADxCQ9+9KnUiN9FTSnb9
	 eLRz21st5abKrQoI6WXXCTvhDiRijG9UbnLgoGcUW0i+RI94zn5Xs0Zwah65etQhqs
	 CPCmz9p0AViMTsj4bFakSYqdUdVkEJbvaUHeOlRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/877] arm64: hibernate: clone only the linear map that exists at runtime
Date: Wed, 30 Sep 2026 17:16:40 +0200
Message-ID: <20260930152416.659425707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44d31b019efd5..b883f6d833b6b 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -417,8 +417,8 @@ int __nocfi swsusp_arch_resume(void)
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



