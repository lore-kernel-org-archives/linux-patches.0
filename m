Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40ED44AB60;
	Tue, 21 Jul 2026 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669048; cv=none; b=MmUSMeyPo02+kSeNNBTCqNE2a5gc73tgTjoHoA66k6cD9tGWTmiJ/wDqZsU4Xyqd0rRQpLd/kDeoL+UetQYUPN0rs+0X0GP65MXt0WLlnSB0kPACsen1zyiF9Ir+CUY3hRhb9pv9Xxti94tSo7RbV3uSO6O89qaWKtoETSWYR/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669048; c=relaxed/simple;
	bh=GIYuGs7HzkLsWRjetNtIEQ0R65qiBdesb4JD/vmG14Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAFTpR7aEjEW7gldQDmFGtfqRAfBpg9AZWdA6q/Mv/W6myQ8kpMrrBnRyzIi/xf0JSs/Qx9BvfEoqYivjj67Vwxik8CAFpm8AZ07bos+OgvLz074UU3LTKBT/NiVlgLJNhpcc3FAmGcfPOQSBt+7+dCBqQ7jdTcqOuWnAmW7fX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o8ehztD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o8ehztD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383791F000E9;
	Tue, 21 Jul 2026 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669047;
	bh=6G5HO+3KI1dgczJrxpPVwDJ/4DqSYV2/kix0N9ReWgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o8ehztDFrBp3Kav6aQCUEQMzGKyhnv1iThn1Zq99gs3FdmBy4WJ09PKjaCoPOMgS
	 /P8P/1J+DL9isTdEX1pCEVrByw5PT7NnsGhm0zFtzsNr3BNtnK8qv3u/NjDGkwGBPs
	 o66GUNAZlEtCP6DQpQRUx3QIya2Xg9BwCOfKZk2E=
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
Subject: [PATCH 6.1 0406/1067] vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Tue, 21 Jul 2026 17:16:47 +0200
Message-ID: <20260721152433.713619530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07843967bc52f7..0a14c117c0fdb8 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -211,7 +211,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
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



