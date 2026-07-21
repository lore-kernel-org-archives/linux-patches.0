Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8662746C4BD;
	Tue, 21 Jul 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649424; cv=none; b=h1NoReV0oiSS1dcMxrUPaPvoC9AM+If9nWyCeWrHqpPDFpUXrC8B5bP6UZ0jn56f7auWQkpy4wgLlfubFixx8tKydiKQOcJsHnAaO/OY7AO3h6HbG7GAxiuOAUTMtvn7efSoqBG4XYIgBthwSvAsbsTv+cjvoUXMmEyAPofSXJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649424; c=relaxed/simple;
	bh=Zy071qLjmq3GD42N24G8L6VUA9C2NJMeaeQ66ahJhpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrHL4LEZY87oceN0YC1G8mLUKCcgcrBK6WIaBAqP5d/GHlOw+EU0bDNS1TrBhqlTNfgUBe8sZtikZzohmLbWDIruCm2ut9VQfDEyVWHKroUSkWlOaTo/cJT7PYeT8M/FmYoPJ+v2RYeXkBm+1wWrmN3qXGm5HU3pPSno3r8QC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU2Eh+3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU2Eh+3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0019F1F000E9;
	Tue, 21 Jul 2026 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649421;
	bh=u6A5O2kI5VpXQmNXl9poCL78/qtB8Rr5fspCM5Lux7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RU2Eh+3pHkRi2de9y/D6mgr4SwIKbRlH6XqtsadTlX8/wd6ACnFbqHTo1QXN8d52D
	 fmF9HFDs394nQI7+ALzB7KUCxjsWTetZ27VpLB+f0IoE2oYijeGPFrIvtfUKdgPdsS
	 DsKMWlqrzplWUEmR5+Rn3e4zY3hgLCIgULW+PATQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhu <zhuhui@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0572/2077] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:04:05 +0200
Message-ID: <20260721152606.299739246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Zhu <zhuhui@kylinos.cn>

[ Upstream commit c55dd3b46c1208d6d2ea737a8aefef4aa4c70cb8 ]

find_vm_area() can return NULL if the given address is not a valid vmalloc
area.  Check the return value before dereferencing it to avoid a kernel
crash.

Link: https://lore.kernel.org/20260529014130.671291-1-hui.zhu@linux.dev
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmalloc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b37187..d87dc7f77f4e8a 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -265,7 +265,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
-- 
2.53.0



