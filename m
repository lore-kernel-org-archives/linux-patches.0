Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037591;
	b=OogUsHI4Ay6HgIcAyupkdiKDLSfQDnjHb80GKgir+yrqkEFLU87Cmh6OKPoOWX3sA9m7
	 HnqwI3SNfE0RN4mNURtihnn2gRDDEfa/qNgqcNd/TknO6JzAwkjZ0jXwbXZidewoe0XiV
	 hKl81k581xa8tig0DUCIWpvTMAQfqPb/qSEBHmjohDClalszgdrw/gD9zSokySMjLL0XU
	 /yWEQ2EOFwtc/36lC0JMIuBq7NXpHP7dgjvkZbdfQffRjVpm0/MqHGUCYf7TCZYIsIiYT
	 YYk1P/0RatkqDac5TDsvc4eWIW4KRP9efBiEkzimtLXiGb8d1WCMbTiW5JBb1MRZXkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXR9eNyjxMPzhTNZbTF2S0IPuqkOXGwU/SMAi6T99SY=;
	b=3v2rWHlyAMJXp9ypdt3S6E2WjWudB6arD8ogqFNH0v9NeR5We/sEiPp3WXhN7oupEHwS
	 qzIepD6Q8qDsO+soW/JNUt7A2KcE0RXchsR+G0crgHNYX3atL7Wks2W5cb3Ak5tTrPus9
	 ybOTUdl6DQzxtL3RcwAXZUd2qEKkqrnJvAxC765U9txDSwrw8I+GjIIHtjqac07u4hnlS
	 787nzzKBgKs77NH5eLil120hDkdTz5s5eDzsYbS1nhkeeRHYO4iZFKscrze4guOoVzuFG
	 /RYsB5x/1sKMqL8HSHV6a7oauoibYeam/uBTmUCCtOzRcZUG4JXY0BfP7+zpHiBSUqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YIvGIsyI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44525606A31C;
	Wed, 18 Nov 2026 21:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YIvGIsyI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAAE1F000C4;
	Wed, 18 Nov 2026 21:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037591;
	bh=SXR9eNyjxMPzhTNZbTF2S0IPuqkOXGwU/SMAi6T99SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YIvGIsyIhWzVUALctoaNIQ9F8eL8IJQWBJBNTRyEuq0HUP/5scInvSaWPVvUVBJNg
	 wlJEd2X+8iJaQD4BMFcBctgB2e/dyL/Mctbp1ps7DJ5co8l911QKOVEKJeJxtvXmyk
	 qnqf6NJI+YDifvTB9LhIVQhQyQLrmKXSgw+bL+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1451/3318] vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118150404.384139011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d408f830364a8..72a60ab7465e4 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1090,7 +1090,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long lock_limit, sz2pin, i;
 	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
@@ -1126,7 +1126,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
-	nchunks = 0;
 
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
@@ -1141,7 +1140,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			}
 			goto out;
 		}
-		nchunks++;
 
 		if (!last_pfn)
 			map_pfn = page_to_pfn(page_list[0]);
@@ -1172,7 +1170,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 				map_pfn = this_pfn;
 				iova += csize;
-				nchunks = 0;
 			}
 
 			last_pfn = this_pfn;
@@ -1187,7 +1184,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			     PFN_PHYS(map_pfn), perm, NULL);
 out:
 	if (ret) {
-		if (nchunks) {
+		if (last_pfn) {
 			unsigned long pfn;
 
 			/*
@@ -1199,7 +1196,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			 * the corresponding unpinning will be handled by
 			 * vdpa_unmap().
 			 */
-			WARN_ON(!last_pfn);
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-- 
2.53.0



