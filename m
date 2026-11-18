Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046866;
	b=y4/Ga9C348EY0IQXObq7umWxwCjSddlgDjuZYURWJVaot5NqDM17kPhSJjyWtfhHEJJK
	 9ZNoRv8yAADRYhMTgheGI8MpXwLZplXHuCtc/m/ly8Mcu9AP29XMyHCEgyCHE/e8ErUwZ
	 fxKGF1FeTDTYRlho/54KpezmxGXPYspS/p/s3YS8FD/r0rVV9VojD9ng2/DU+Ynra3MCY
	 96g2ERYc38iuK0trWFZIIFohh9KReBufv6saZXisxfK9ciXLXlwNDHHeokv1o2AgybYd3
	 kPelBeIIFNmtv6Y6KMcQ674fTHqzilN5az9jaevv5k6LgdSFCCt5f11Ku8FPIdAkD7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h9rJuRHSrkg/ciA4gs4oNoR21Je3goRFmE8z4hxQTME=;
	b=MQV1oMlGe1URYEhl6Ov4hkmHHiMgKMbIVoR47R6hQssNnIMaMM+EQFGXAZZqPblhrHoI
	 s/fLDIA3wRv3bvAVGgHypY4dTmKttyx3mscP+KdYO783H1rUzxgGI373gdw3ffxT4BKJ2
	 dKXNewyNuKtwILl5QODcQGZA0D56LQNNqWHcVpYuUpiZddUuMJPR2TthgDi/SEWrMmF6x
	 N4gXFY24r2Aiab8/ez01nS4kUATR/8Yd1UaTHVvaDfEkWL2n+azGvrlIAeLXtmjWK4dA+
	 go6vQkwJ4+J3TaI2QncHBK7IIbjiglrBYV2oh/wS2M01I6skVWiFJ5Ea1ImtLxDEWQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1TC+Kpw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB422606A31C;
	Thu, 19 Nov 2026 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1TC+Kpw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B7D1F000C7;
	Thu, 19 Nov 2026 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046865;
	bh=h9rJuRHSrkg/ciA4gs4oNoR21Je3goRFmE8z4hxQTME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1TC+KpwMVKifWPmLDY2oyOW9+sphzbZ1VikhTTz4cgWu/PVqaviKyHnVw4Juj+Jp
	 dyl/uyVqHJ5pl3JTRKxSgKDec6psFsmf59qvO1IqMrpb7VtsS9LwQVlj/G1UQ0V8It
	 HLGdU2Qs8Z8y6wzX5ax0uvPiCyseKJd/+bsxOxT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mina Almasry <almasrymina@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1435/2857] mm/hugetlb_cgroup: convert hugetlb_cgroup_migrate to folios
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118150252.981644069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit 29f394304f624b06fafb3cc9c3da8779f71f4bee ]

Cleans up intermediate page to folio conversion code in
hugetlb_cgroup_migrate() by changing its arguments from pages to folios.

Link: https://lkml.kernel.org/r/20221101223059.460937-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 23fac055c211 ("mm/hugetlb_cgroup: move per-node usage on cgroup reparenting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 8 ++++----
 mm/hugetlb.c                   | 2 +-
 mm/hugetlb_cgroup.c            | 8 +++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index f0d9f295413be..c70f92fe493ef 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -177,8 +177,8 @@ extern void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
 						bool region_del);
 
 extern void hugetlb_cgroup_file_init(void) __init;
-extern void hugetlb_cgroup_migrate(struct page *oldhpage,
-				   struct page *newhpage);
+extern void hugetlb_cgroup_migrate(struct folio *old_folio,
+				   struct folio *new_folio);
 
 #else
 static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
@@ -286,8 +286,8 @@ static inline void hugetlb_cgroup_file_init(void)
 {
 }
 
-static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
-					  struct page *newhpage)
+static inline void hugetlb_cgroup_migrate(struct folio *old_folio,
+					  struct folio *new_folio)
 {
 }
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 28c6a6c4120cc..ec557c2b1ab63 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7555,7 +7555,7 @@ void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason)
 {
 	struct hstate *h = page_hstate(oldpage);
 
-	hugetlb_cgroup_migrate(oldpage, newpage);
+	hugetlb_cgroup_migrate(page_folio(oldpage), page_folio(newpage));
 	set_page_owner_migrate_reason(newpage, reason);
 
 	/*
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 001828b062d43..4cd57f979245f 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -884,13 +884,11 @@ void __init hugetlb_cgroup_file_init(void)
  * hugetlb_lock will make sure a parallel cgroup rmdir won't happen
  * when we migrate hugepages
  */
-void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
+void hugetlb_cgroup_migrate(struct folio *old_folio, struct folio *new_folio)
 {
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
-	struct hstate *h = page_hstate(oldhpage);
-	struct folio *old_folio = page_folio(oldhpage);
-	struct folio *new_folio = page_folio(newhpage);
+	struct hstate *h = folio_hstate(old_folio);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -904,7 +902,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(new_folio, h_cg);
 	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
-	list_move(&newhpage->lru, &h->hugepage_activelist);
+	list_move(&new_folio->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 	return;
 }
-- 
2.53.0



