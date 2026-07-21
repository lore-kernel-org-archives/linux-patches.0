Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B9846D2A4;
	Tue, 21 Jul 2026 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658832; cv=none; b=HbCUvwtPNQ6UB5HU2WMLTTwC1zoi6qD0hxtG+G2STXgvi0fFbXZnJNIrBRtk1B5HxmFHTMKfTU3+G+pu9IXcT/5mPWtbGO48lKeWeBffOhuyC50bSHk9dnq/9fIaERHKiCACmSbzGLcdAEhRu11fUv4aoRF/GUhDMy4Dhystvas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658832; c=relaxed/simple;
	bh=Kc1DkKizvOVhr2OQQu2Nv6Gg1x0Y7YxzmCUoRojvn+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUG7qWtBpdbSk6HIwpJOaZFKRuCUavLDZ/XYbNMIauLZOcTf4UQpE2zusZbAgVZbKL5hTh25zPjp2aNADqXFxcE3umILvg+8bucoE0DgQtqqbBvNft3/CflS2v2kw4WDTY4UCfkDFAufZT/pNQ7zBdiosk3aKFu81AL+9qF+Rco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmmyB41l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmmyB41l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36971F000E9;
	Tue, 21 Jul 2026 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658830;
	bh=CpmbrZsUi8pjvScQoseBjbGxUetgt8qyMrQKXTnRwis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmmyB41lQM0fu18vcBTacijOYNBHLKowovTv6UArGGLGM//tMTxsPOLwbyeRhwMmX
	 /OOg+3R19VjimbUbTSp3IcWrXtpH5HHmMdSpS0MiihMIUcV4EYspcxDoEfunorf20a
	 msTJXU+PI/pchVp6mFNLgHclUNp7bsN+rVB0Q5ws=
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
Subject: [PATCH 6.18 1255/1611] fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Tue, 21 Jul 2026 17:22:51 +0200
Message-ID: <20260721152543.676913966@linuxfoundation.org>
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
@@ -174,7 +174,7 @@ u64 stable_page_flags(const struct page
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
 			u |= 1 << KPF_KSM;
 	}
 


