Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C98415F0C;
	Tue, 21 Jul 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656462; cv=none; b=Rg/I1+m/Q2mqbhiyIrgg6ctNsF4slyvUNzVcuTImEPc8mBL2S5PIl+GDr+yIdwBPQ8U6QrDsp6YdCfIteAxgb+7Ks7n+xFTpdwTQUMgBJ2eOYoBFN1afY8eb+rSjzki5SGzcElJWR7cG6g+FtsmcuuOJrShW9ZNfJG/04zhi2Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656462; c=relaxed/simple;
	bh=rAtNjsriTEaHGPCcEnXKJ0lWTCWtNkHSDSiJgCvIFhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdBiaQlIOzv5E20i7ou4NPKdYfJK+NYU0d0q/vwsg2WGnvfZVjsPDybi7vUAcMVhN+mgZ8iIGSCqV6XUu6OTTxilrABeA7k6EI2Yi4Lr7XGr1dvFnOC3+mkQOJBg0ZyaL7RI05UdiEpPoXgYNnI0+uJM5ukSqmX5qVrvrthcl2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgTYFCRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgTYFCRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CDF1F000E9;
	Tue, 21 Jul 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656460;
	bh=q96zj2ebd3NviGTWot0pTelawRW1V2zyN40Fn96y4yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgTYFCRtqj9MA8zMkZJWufoi9+vhqnNtu5EZCuMEq/zPdKxfqY7J6KX9mBIjPa+pZ
	 XB8ZnOtrxCrBLAjbB8NohD3iMSGd59ntjztE92LunKSIwqOv/rgyf8cCAJybREoDgk
	 lbgc4VWU9dovxrloZArSJr1TnAWW73QMlMv9l790=
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
Subject: [PATCH 6.18 0396/1611] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:08:32 +0200
Message-ID: <20260721152524.135696689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index eb54b7b3202f4f..380dcc5a470e81 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -261,7 +261,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
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



