Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC55401A21;
	Tue, 21 Jul 2026 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654513; cv=none; b=V9UM+TV82PIlk5M5MyTf6t+AoA4Wz9ZKr40bzOsdAI1mvPIOu+MOgFLwoRntog8JwY3vBWddtxzVLWXR5LUqF/uCFazUhlVSR2bMBOLRtGPU0FHXO/vkbCZR5NiWc9SuJcuDy4FSMQIPD2Jb203paegYPYRoTzii2ca6Xke6W8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654513; c=relaxed/simple;
	bh=IaKeAboFr9o+0IASHzc8Z4VanasMUq2FOIULdCK3+oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9w3RkFX6Q/ARV0rDDfKq2ewMjBdqTJdNG7lY6ztZxE5xvTGQsRn6af3fAZVd/PkrjktbImuRrKZZdraDI4Es0S8NWm9d3cg6iA5Hyvxp6rB1iE6avYjxkZj0EQ28PFyI6V/WgCW3Qh4tr4JVPgf8X6h7jkfAx556+Y22rAbEZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dV3ow0gS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV3ow0gS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90091F000E9;
	Tue, 21 Jul 2026 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654512;
	bh=DeMXRisDPdsR0gcJdb+waNd4or7iCAo0qWm7o+UEnO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV3ow0gSLYRALCqDx5f7oRrZ+8ziEUjhasKDqYpourRR1TF6qa/3f8ABucY3gk/Wj
	 jfdP8Ozo1KqD/H6AJADKlQDFqpibwhe8dchmXC0ItOEHExIWyUdRr5GoVISmNGzajJ
	 jVhJ5UE3fWslF0Y8ZSggYhiAZHQvpGOTe4tMgRTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Svetly Todorov <svetly.todorov@memverge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1733/2077] fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Tue, 21 Jul 2026 17:23:26 +0200
Message-ID: <20260721152633.625546380@linuxfoundation.org>
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

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 81401cebfc1598306b0a981b5f9ee5b58c1aac52 upstream.

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use.  As a result, tools misclassify all anonymous
pages as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all anonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Link: https://lore.kernel.org/20260629033122.774318-1-tujinjiang@huawei.com
Link: https://lore.kernel.org/20260626013252.2846774-1-tujinjiang@huawei.com
Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
 			u |= 1 << KPF_KSM;
 	}
 


