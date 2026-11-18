Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046306;
	b=ZrbfP2RH3kIQhIRbDlItPjzw6mtROub5P8fqHKvojp/JcldZmV4pK/4Zw6H0OIlDTzZ1
	 6vdN+j9Yi004G+wJi5YpmWxxCTULbNuPDactSXIPri3IwZzVF5meyicF+/cs9CJg70uGh
	 +CiskI8lU52uOTsOPRYYjHt6ZNXYbEK5P70vIoHEVH9kEhyqiUCYcJLkiD7EnMQILTq3A
	 GpNPKLHUz24a/7Jokmx2RfQe3+58rmS17OSOGuzm3VEF/xJcrHWbi5XEGxEwPSO5GPbJM
	 Kh3rCmetd2x4HEZbMwROJTcs6ZHfNXkEY9vz0g0hO/gcicFYoAifedzpEfB6Wcx9VOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBIS6QZHO9TnwFYnUqIIlzTStbm56xqhFK0ah1gj4MU=;
	b=1jgj52YkJuTajyLEZd3m5UJS36OznCU+TaJXzA/qdhexwtOrJcbMkE9uzM5+5OBmUxA5
	 wO/Kg6KjZkLKVC6QHqemAfhdxijw4hFOXouaqVVguJPmegCIPwC5uXB0+LN79/ApmUCX/
	 Tqo43a4Zr7dM0QVLF7lgxGol2szfp+AowvcoB6BI47XWjXbzEc9MkrQGYJc81+WbhbZ6P
	 UzUzCvEeLtwWWWq6ZIylq1I84FWgbaGWj5kb+VNZ1W/ATGfiltEIktvoRVOVr/LC4sBhV
	 5EFCCE+fpXf6ZcvXQUVaIvbVIG5711bADTxkdn5cvHTBGYXBCjLH6sH1t9j9IbQyIQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4PpYLVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16A4606A320;
	Wed, 18 Nov 2026 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4PpYLVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059101F000C4;
	Wed, 18 Nov 2026 23:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046306;
	bh=vBIS6QZHO9TnwFYnUqIIlzTStbm56xqhFK0ah1gj4MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4PpYLVr7pDSr4emTvq9iG+ZuB54AQjiREpeA6gNvc8UV3R6Y4SUv5iri4Y1NUynf
	 3rDFgRs7sI2ngExCYth15c6cgOkddq+7+rP8irzT22Fj4vNCAEWEMp+Oq4CzHb/vA5
	 Src2c+hH63dgpBvGsLxL/boDVKy+wLZvNORyzLIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1233/2857] vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path
Date: Wed, 18 Nov 2026 15:37:47 +0100
Message-ID: <20261118150245.953388205@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit fd1462c96bafe2cb14e88c837b270f8990b717b5 ]

When pin_user_pages() or vhost_vdpa_map() fails, vhost_vdpa_pa_map()
is supposed to unpin the pages pinned after the last successfully
mapped chunk, i.e. the range [map_pfn, last_pfn]. The unpin is guarded
by nchunks, but nchunks is reset to 0 every time a chunk is mapped from
inside the current page list, so a failure after any such boundary
leaves that pending range pinned forever. With physically scattered
memory nearly every page list contains a boundary, so the leak happens
on practically every failed IOTLB update.

The pending range is non-empty exactly when a page has been pinned,
which last_pfn already tells us, so drop nchunks and test last_pfn.

Fixes: ad89653f79f1 ("vhost-vdpa: fix page pinning leakage in error path (rework)")
Cc: stable@vger.kernel.org
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reported-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261031-vhost-vdpa-unpin-v1-1-94ffc9683256@columbia.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 03bc085358ad3..98f410a67bc99 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -922,7 +922,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long lock_limit, sz2pin, i;
 	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
@@ -958,7 +958,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
-	nchunks = 0;
 
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
@@ -973,7 +972,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			}
 			goto out;
 		}
-		nchunks++;
 
 		if (!last_pfn)
 			map_pfn = page_to_pfn(page_list[0]);
@@ -1004,7 +1002,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 				map_pfn = this_pfn;
 				iova += csize;
-				nchunks = 0;
 			}
 
 			last_pfn = this_pfn;
@@ -1019,7 +1016,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			     PFN_PHYS(map_pfn), perm, NULL);
 out:
 	if (ret) {
-		if (nchunks) {
+		if (last_pfn) {
 			unsigned long pfn;
 
 			/*
@@ -1031,7 +1028,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			 * the corresponding unpinning will be handled by
 			 * vdpa_unmap().
 			 */
-			WARN_ON(!last_pfn);
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-- 
2.53.0



