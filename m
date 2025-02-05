Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1CF1DA617;
	Wed,  5 Feb 2025 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767680; cv=none; b=Cj1DvvBFqz4e4vNNiBOcEv4jJPfx1rCiqhNI828s10A560gHL7mWYWhP0YuHAACTM+V5r5O0113siiwJ0Bx4ZOj8GDcqVpC1wfozBqYE3ZnGumwLwTmONdPACPuEnJIhFA+fgQZjSEFId65hIVBlFJf4tBhl6bHI467ZVlzY1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767680; c=relaxed/simple;
	bh=PEK5DiB1Cm6kNLipXGXArlaCmIpCXUC/kxJDRGp6bWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVU8KuMrLMpa9VogD/slqZhu9/jptrmMBcn5qb/wPD0NM7QlzstO0kTg2B2UlCP9GTWgS6hc745ge652QdW+SohkTNGKO7+uTTUFIfVuLfyDpRgG6iMKrUrLxNrKEb8S+BPcP8MvOtqygu6v/lEu0qFHBfo3J4g+eHJxrwCEy1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBJkUbH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBJkUbH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80394C4CEE2;
	Wed,  5 Feb 2025 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767679;
	bh=PEK5DiB1Cm6kNLipXGXArlaCmIpCXUC/kxJDRGp6bWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBJkUbH8pa0caS7u/9AcUSihBQBC1J65DglxPOBfZrGhC0oqxS8rbTK8faOWIEk1H
	 uf1+seDezSQS9JPaGkdiIJkrkP904wkgLpA+Zk+jpBG90luZtYOqkt+dUjuNn8AhlC
	 HX9LONsIewwhL0RHZHjRViPN3Wv+rcyAendp16o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 491/590] s390/mm: Allow large pages for KASAN shadow mapping
Date: Wed,  5 Feb 2025 14:44:06 +0100
Message-ID: <20250205134514.054482919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit ff123eb7741638d55abf82fac090bb3a543c1e74 ]

Commit c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address
spaces") introduced a large_allowed() helper that restricts which mapping
modes can use large pages. This change unintentionally prevented KASAN
shadow mappings from using large pages, despite there being no reason
to avoid them. In fact, large pages are preferred for performance.

Add POPULATE_KASAN_MAP_SHADOW to the allowed list in large_allowed()
to restore large page mappings for KASAN shadows.

While large_allowed() isn't strictly necessary with current mapping
modes since disallowed modes either don't map anything or fail alignment
and size checks, keep it for clarity.

Fixes: c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address spaces")
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/vmem.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index 3fa28db2fe59f..824690427b61a 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -264,7 +264,17 @@ static unsigned long _pa(unsigned long addr, unsigned long size, enum populate_m
 
 static bool large_allowed(enum populate_mode mode)
 {
-	return (mode == POPULATE_DIRECT) || (mode == POPULATE_IDENTITY) || (mode == POPULATE_KERNEL);
+	switch (mode) {
+	case POPULATE_DIRECT:
+	case POPULATE_IDENTITY:
+	case POPULATE_KERNEL:
+#ifdef CONFIG_KASAN
+	case POPULATE_KASAN_MAP_SHADOW:
+#endif
+		return true;
+	default:
+		return false;
+	}
 }
 
 static bool can_large_pud(pud_t *pu_dir, unsigned long addr, unsigned long end,
-- 
2.39.5



