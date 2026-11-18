Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053284;
	b=sBdowHZmp76YoP+a+17DB90uOu7a7GdIDAfTTYtJVw8rK1Gq8GPPpaMOa/05hklq8A3H
	 TVmfQ071wgoFVWAcX/LKNfjzgPpwuEDEQyrOn6VZcXT3NqLnfQocKd+ywSr10NBBnTKOj
	 k+eAdhxJ/DJbUAeUNL130PYaUHuPxL1Yok1DDnEdNs8lR9J/N/FS8VmWCS0FKxAQ0Xw+l
	 yvDtczuMbFqLrXrkfTgAGV/qKZh+h4rWqkUqtjIXYNUCihgqEzxeh8T2UDNPmDlgEEVYg
	 FRj4Mc5ajSuXp+lBI8d9tAumW8qvdA4UF2B8rI8va/0Tzza94o0VmOwTyXIh/G1Pgcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8sIih1MBZJGyiQEMR2UDXxG3pAAt7kT2s5gsojBuxKY=;
	b=z5gAWu1bNTb18zz04Lh7tyfhnmAbG5dDbJ1gSk0yqLzlXpFfvdj6/snTug/yOG5gHWgS
	 x64ezUR7rf1BOW9lhwlOu/EragJl9Xl5G+Wzu/p1q91jn7zXKmUhZUuPEt+0m4StHFeep
	 JSjXcor8OQjR0720m2hjhucvYfHbx+ZrbCZQMzUvJUmH9oaHjNoP7EPpnnXyS2gPP/LrP
	 C2KrN1MO9izbvY6JBWg8SCYpc0G3Xb00E9B/uFb8a9JuImqm3ruRI7GyeifDB15Gdidqx
	 r0L5ZRgXHPXb6U6kUY7S9/M3jkSOf56yfkndnck6T5cWydeXzSjmcMmfh3MT3ld2vjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ka1X0og8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E5D606A32F;
	Thu, 19 Nov 2026 01:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ka1X0og8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4801F000C4;
	Thu, 19 Nov 2026 01:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053284;
	bh=8sIih1MBZJGyiQEMR2UDXxG3pAAt7kT2s5gsojBuxKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka1X0og8yNXpav20kbcCMdsrv4xb/x7YBd2sO7UQopf4hCpnIYIG74qXe4AOCHlWb
	 irhFnbeNwCy2C+YcTw2iIpCtiMl1EcC9N9eGb1FJdZ1/cCUnDaoYtcnRFU758oQvmq
	 fwKdKwaM2lk2cIKeMlOoMO7Kt9YGqWsEpuX9Dy7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0865/2214] vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118150046.747269044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 08aaaaf488199..c94cf6dcb79fd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -712,7 +712,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long lock_limit, sz2pin, i;
 	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
@@ -748,7 +748,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
-	nchunks = 0;
 
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
@@ -763,7 +762,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			}
 			goto out;
 		}
-		nchunks++;
 
 		if (!last_pfn)
 			map_pfn = page_to_pfn(page_list[0]);
@@ -794,7 +792,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 				map_pfn = this_pfn;
 				iova += csize;
-				nchunks = 0;
 			}
 
 			last_pfn = this_pfn;
@@ -809,7 +806,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			     PFN_PHYS(map_pfn), perm, NULL);
 out:
 	if (ret) {
-		if (nchunks) {
+		if (last_pfn) {
 			unsigned long pfn;
 
 			/*
@@ -821,7 +818,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			 * the corresponding unpinning will be handled by
 			 * vdpa_unmap().
 			 */
-			WARN_ON(!last_pfn);
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-- 
2.53.0



