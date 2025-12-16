Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A2739655A;
	Tue, 16 Dec 2025 12:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888312; cv=none; b=WiZIukLGrOqiHsQpuP4JqZkV4+1zrFOX3SeFaJyHXWvPkNhS0qhZdnMiCo+T+e6XSxunzSN1NK0jNH/w5Ec0brdHGoBRSiFNto4JGWIYwSOv9Uh/4AaStOCXuqHItiKo+hGheqw502Z+E3Z+mEMCZBnfAskwZLzbXa3KKlpwZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888312; c=relaxed/simple;
	bh=7nIhkmuRxgU/wsUtJJw2HQfqJY+CYfG8sLq+v1fKNbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qajboWm+DIIG3y/Gu3SuNOC59QHNJI+7Vv/b28IxCXnEwE6XraZDj282VAkochecb6C0EoU5HftmJDnpOZW+kpGOYsrcwKoy6+2SAzC1fag1DFIki+VEDVivftw61KWsu5C4ypFdG0M2jEJhxaNanmsYHUjjcRaqBJ2Fy6Ufhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYerjaXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYerjaXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E7EC4CEF1;
	Tue, 16 Dec 2025 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888311;
	bh=7nIhkmuRxgU/wsUtJJw2HQfqJY+CYfG8sLq+v1fKNbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYerjaXfuDn+l9SNz94Jd5zrNiAISS6RnlIECkKbfsDnO41ArKVrd1/mXvCOp7oCC
	 4YMKNIGAtPdQFnIYtYFek4Jr5z0zapb6fXfBSAiSud6uT69QRVBXCjepcmAdQhlHvN
	 YwfOChqSKJ2lQTk8dVxgD/0iUh5cjUF2/zmMf7RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dev Jain <dev.jain@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 489/614] arm64/pageattr: Propagate return value from __change_memory_common
Date: Tue, 16 Dec 2025 12:14:16 +0100
Message-ID: <20251216111419.086460633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Dev Jain <dev.jain@arm.com>

[ Upstream commit e5efd56fa157d2e7d789949d1d64eccbac18a897 ]

The rodata=on security measure requires that any code path which does
vmalloc -> set_memory_ro/set_memory_rox must protect the linear map alias
too. Therefore, if such a call fails, we must abort set_memory_* and caller
must take appropriate action; currently we are suppressing the error, and
there is a real chance of such an error arising post commit a166563e7ec3
("arm64: mm: support large block mapping when rodata=full"). Therefore,
propagate any error to the caller.

Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/pageattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 5135f2d66958d..b4ea86cd3a719 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -148,6 +148,7 @@ static int change_memory_common(unsigned long addr, int numpages,
 	unsigned long size = PAGE_SIZE * numpages;
 	unsigned long end = start + size;
 	struct vm_struct *area;
+	int ret;
 	int i;
 
 	if (!PAGE_ALIGNED(addr)) {
@@ -185,8 +186,10 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
 			    pgprot_val(clear_mask) == PTE_RDONLY)) {
 		for (i = 0; i < area->nr_pages; i++) {
-			__change_memory_common((u64)page_address(area->pages[i]),
+			ret = __change_memory_common((u64)page_address(area->pages[i]),
 					       PAGE_SIZE, set_mask, clear_mask);
+			if (ret)
+				return ret;
 		}
 	}
 
-- 
2.51.0



