Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792D43F660B;
	Wed, 20 May 2026 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301875; cv=none; b=geQdfErssxkdSclyDcu8SKg1yW0HGo85XAMi+FQ4O2XzsO/1OK2pORO50Bem7QJPXual7ghmgw0LvSV5nhIt9XIr5ZnofqzRvEX6o5ajd0sB8/SJIZHAL3XMwM4d+T8QIzyEMaYISK9/PqIGqEC5bwDpYs43Pbw8gKuKn9oB54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301875; c=relaxed/simple;
	bh=ctq6gEY4DQiMAkUS/rCMQ7nKA+y5xg1a3cxhSRQY170=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3qEIo4BZlvVqVJX7AAY3cKMySgxn7FHbb8qYgTsGiZxgeMMrbNlIyenl7msgavZX+zsmD9bmiaknlLhq7TiEXe+Xpw/f5PYQipKz1xfBg90NJ3zLLubavquB/w4zL4Ic07cSqhlV8tEOymCL/3iXn16cQ60GEjnOnkoQcPMA9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NB2Mertw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB2Mertw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF55C1F000E9;
	Wed, 20 May 2026 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301874;
	bh=rlxNzf4Qll8DcIxf4koH85wB3gFBWiWDFq9D9YGl06w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NB2MertwGn2/lArIkM5adksUUgmIWXWMfUJ43w/byW8bWLTt4of3hqetgDG6TOs1/
	 YY6SAmnjPgXT6OMs4wAhHj53I8gJkANd3gxdi/Xu6mVkxWwYEB1yl8M/icsaHdVHZ5
	 PlgVz4eqhAihgngdaBRbq9t1/Q0k4P6qwC7UX2O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Wensheng <wsw9603@163.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/508] arm64: kexec: Remove duplicate allocation for trans_pgd
Date: Wed, 20 May 2026 18:17:56 +0200
Message-ID: <20260520162059.747345629@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Wensheng <wsw9603@163.com>

[ Upstream commit ee020bf6f14094c9ae434bb37e6957a1fdad513c ]

trans_pgd would be allocated in trans_pgd_create_copy(), so remove the
duplicate allocation before calling trans_pgd_create_copy().

Fixes: 3744b5280e67 ("arm64: kexec: install a copy of the linear-map")
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 078910db77a41..9307a1421d67e 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -143,9 +143,6 @@ int machine_kexec_post_load(struct kimage *kimage)
 	}
 
 	/* Create a copy of the linear map */
-	trans_pgd = kexec_page_alloc(kimage);
-	if (!trans_pgd)
-		return -ENOMEM;
 	rc = trans_pgd_create_copy(&info, &trans_pgd, PAGE_OFFSET, PAGE_END);
 	if (rc)
 		return rc;
-- 
2.53.0



