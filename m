Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA19247290;
	Tue, 20 May 2025 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750639; cv=none; b=h7CTfd26m0hnP4vxfRkA3aZha5NbPSrtA6TaCFsBhKxDyyQQonRTweQfIszF2B22KL8SzZSW7LtZDvDkWf5WIu4W6Jt91XT8WO82pfuf2BtHsPt1/wWyGO8ovzKnJtRtPEKDMxXvXrDua1nPUxZ4yDDc4bINYHKm/5chcMXjchA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750639; c=relaxed/simple;
	bh=+w8ykACRlPJyWeRAFKjXS/y0snKiCdEN7yL1gFd8rRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/olwRbkpCT067nQGeDLZtf3Eq9NF+UqZqnik53b7IPeUWBJab0z2irQyYGgE6nzIL2DbiLiEsIXygj4u4eNSAo2tKzxNtHXBs2YF7EeLKnw976ItXPR2yNXCHZ1KqjwCoUz51lLsi/q6G2Kmog/h2vFF/n5a+YM/IF2WOEfCTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbrPypJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbrPypJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9B3C4CEE9;
	Tue, 20 May 2025 14:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750639;
	bh=+w8ykACRlPJyWeRAFKjXS/y0snKiCdEN7yL1gFd8rRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbrPypJORfVgQBnStx+zG5WTJhXFw+2hPiRzEVLOlS9vOgK48531Ve9WX+BYjhFot
	 a1rlZ4Pas3bpEOX29q+Nx/yq1ZVeWxdAqe0iSnOzLXtOW1NcwadpcSb8E5tq9WWE1F
	 C1oOMeqsUlRI8UWfeU7AvqaGFoHeMbNTCFBxVTQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 072/145] LoongArch: Fix MAX_REG_OFFSET calculation
Date: Tue, 20 May 2025 15:50:42 +0200
Message-ID: <20250520125813.406988942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 90436d234230e9a950ccd87831108b688b27a234 upstream.

Fix MAX_REG_OFFSET calculation, make it point to the last register
in 'struct pt_regs' and not to the marker itself, which could allow
regs_get_register() to return an invalid offset.

Cc: stable@vger.kernel.org
Fixes: 803b0fc5c3f2baa6e5 ("LoongArch: Add process management")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/ptrace.h
+++ b/arch/loongarch/include/asm/ptrace.h
@@ -55,7 +55,7 @@ static inline void instruction_pointer_s
 
 /* Query offset/name of register from its name/offset */
 extern int regs_query_register_offset(const char *name);
-#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last))
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, __last) - sizeof(unsigned long))
 
 /**
  * regs_get_register() - get register value from its offset


