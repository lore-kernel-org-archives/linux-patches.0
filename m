Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1A41D1E69;
	Wed,  2 Oct 2024 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877796; cv=none; b=dF+50W217bCFjMMcXfyZgaGP+YRwQ4o+JEd221gs+dDAQmqYQ88mkrAbxabSMnl+aNjH7Z0dQUqUR9T4xfbJ1abFnE93wwTK9Xq1Rd4/qtk0+xcyzP7+m9vOIiwo/Xi1tfPw/6ud5BAwxrXJs5Pq5vVp6oBxe+pwEga5+KGvHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877796; c=relaxed/simple;
	bh=a3zxu2RdaTORcVwm8qhPT2zKsrv1jAgohChnpPDbyiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu6y+ZhKnhzg+gePl1MBjW0I47kgNA3zfSUcBUOKzhZMCgXX7vOrOtTIwhg6hoM1yP+OKacj6IhtzvqOY19Zf78L1+NS/hVu8fDgSOXLTv/SYrTE5ymznr2FpLesJ2d1edVR5CIXemgF5uliIt5Den76vadX3NJIVu/BHDdCBl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjYhAf0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjYhAf0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56828C4CEC2;
	Wed,  2 Oct 2024 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877796;
	bh=a3zxu2RdaTORcVwm8qhPT2zKsrv1jAgohChnpPDbyiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjYhAf0akWdBrLY89O8Yn7/yiVKqI0vMYAoPAx5fxhXTKuxXQ6wkOzcLeA+opKUs2
	 3LWYG1NOxiLsM2AXA0abZ0C79L7hHXuFDvs0168d5Sb9J4/wlehcZfST7FvVUaTddJ
	 vLcdoMBWmsTuBC83GnJWWX55AuZVjqStZnHy4LzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 196/634] powerpc/8xx: Fix initial memory mapping
Date: Wed,  2 Oct 2024 14:54:56 +0200
Message-ID: <20241002125818.841359422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d93433e26dedb..e5cc3b3a259f9 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -154,11 +154,11 @@ unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 
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



