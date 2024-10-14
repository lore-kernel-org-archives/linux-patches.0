Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249241AAE27;
	Mon, 14 Oct 2024 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917771; cv=none; b=u1WEysyoEa8uGHfDzQh/lBcm5/ZA4Nhg0PkuHuWJtaMKC4fOpfpmit1KMNGtCpSFsq22HfiktVvio0tH72HjUzyaDeitrItlUZspQNue7ZLXl8OYCt6Seh1SBXxQ1vKvaDOW1Ar8JMQXW2d7c0tJlfo5pDZc52WOtyJe4slm56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917771; c=relaxed/simple;
	bh=LWJya6Xt1APev4tbyEgex3tBAVRgStxU4zeXYrtbW6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKSRFMiyXH4lRtVLpVezRwpg6VQm8H1AR4CyKn9vTItfNSfHEIWSS2XXAqhq3lAdjcER4KwgNncNc20kMb8dCcPX4KVm3ZOxMDfC5gYZFzLlsovHvh9cZmrZkY6X6IfXF1899+IcNsPC6+xeGQxbkUXmvOD1KbZwzF0GzY/lOgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvOVkoRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvOVkoRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F51CC4CEC3;
	Mon, 14 Oct 2024 14:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917771;
	bh=LWJya6Xt1APev4tbyEgex3tBAVRgStxU4zeXYrtbW6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvOVkoRG3tYrrq2JpGmKWGNmt3SxQiTcWNjCL9IfUlNvrG4WEYjOFISvfCBwqkSiq
	 QhioiNK/pekldifL/S6OYzSQz5QdAgz3KqXWh1tqQMPqKM2HxOGtFyOgnCL49vx+6g
	 A5FhQUElhXWFdy6ENziW1wm20I+20kwKW87v2BOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/798] powerpc/8xx: Fix initial memory mapping
Date: Mon, 14 Oct 2024 16:11:16 +0200
Message-ID: <20241014141222.714138300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit f9f2bff64c2f0dbee57be3d8c2741357ad3d05e6 ]

Commit cf209951fa7f ("powerpc/8xx: Map linear memory with huge pages")
introduced an initial mapping of kernel TEXT using PAGE_KERNEL_TEXT,
but the pages that contain kernel TEXT may also contain kernel RODATA,
and depending on selected debug options PAGE_KERNEL_TEXT may be either
RWX or ROX. RODATA must be writable during init because it also
contains ro_after_init data.

So use PAGE_KERNEL_X instead to be sure it is RWX.

Fixes: cf209951fa7f ("powerpc/8xx: Map linear memory with huge pages")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/dac7a828d8497c4548c91840575a706657baa4f1.1724173828.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index dbbfe897455dc..52f24fda2d5f6 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -147,11 +147,11 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 
 	mmu_mapin_immr();
 
-	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_TEXT, true);
+	mmu_mapin_ram_chunk(0, boundary, PAGE_KERNEL_X, true);
 	if (debug_pagealloc_enabled_or_kfence()) {
 		top = boundary;
 	} else {
-		mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL_TEXT, true);
+		mmu_mapin_ram_chunk(boundary, einittext8, PAGE_KERNEL_X, true);
 		mmu_mapin_ram_chunk(einittext8, top, PAGE_KERNEL, true);
 	}
 
-- 
2.43.0



