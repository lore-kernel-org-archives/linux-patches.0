Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704113;
	b=u7E45yDSr7r16yr/hz1yYxdjhdtI7WEcxcarg8apBAgKIVrYwhVao+eDXc4V6onByVgU
	 gUPwrhO17KSqOxopeIHE7CfzsZQZCYxuUFafidv5yvdAvRc6EDCpDhQBH6UgIhO1ZFzog
	 fcVP50DjOAIwzqfRsq7k5aMRkGNjdwaGXY2rgX594G7zvTLRLVZDcZ29UymFeorqfHJDS
	 pYBbIsqIrBPTmjcHr0SFMqcpi+ZQCWAJXuo7qQUPMnurDxk0VizHsFOF/hxeSqXW1DNjN
	 QjCEYKBkU24ANN1ACHnfzuZ3M3OQrhg/u0QlB3mUP3cpu5pVZOvdGL9XKqeWYrc9KwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mdfzs4K+m8MzYlD/6WOjCyaBbDp3r+kVEgt4+9zSvHg=;
	b=WrfUxaGmRapFQORJ3qt/QZ8XAHL4qITwgBg40o32qAkHqJqK8h3+O46HzDlhub8TXcFP
	 52A1/eun7xHOtajRpriw8h9bjEd+N0qmkOjoZ8Gs8F8T9pZttyt33HvqSdsK9CGYYehkB
	 wa94CLEjFkGEm8+IRYS8yp7IwWdseF59gHysKk9SunA7lazje3MRLUXjCntAPCmHbTCq2
	 uTkRz71EV4NGV/QDKnY3PdxgyAXGH/bGfldGLKWQCI/qVoCK4B6E0wDlV+tlR75OaDina
	 S8NAx7u8yVhHBIFe/xqV2Tq/hZVxRe0hk2xL+f94ZI6mgw0OzeHeuQg4WalUUkkAJBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gH4qrwBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E052606A31C;
	Thu, 26 Nov 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gH4qrwBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C081F000C4;
	Thu, 26 Nov 2026 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704112;
	bh=Mdfzs4K+m8MzYlD/6WOjCyaBbDp3r+kVEgt4+9zSvHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gH4qrwBD3TByjVXBXD9fEnOMKQ6JaVCsOuYVzkMnsy6dz3d78mBHYl5E6KfLTLz9Q
	 X0SuTpX4naCy+9SPvPZPHsFPcSfuc84UFc1cUM7vBVs237sc44i94S0SbZLbZYFGSh
	 cejCenwvnnjIK1fAhSx4pIxMUvd+1tXNIN5BPrlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/265] vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path
Date: Thu, 26 Nov 2026 15:35:41 +0100
Message-ID: <20261126143605.858149379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 32dde456a181a..cfe3bf958f318 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -632,7 +632,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
-	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long lock_limit, sz2pin, i;
 	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
@@ -668,7 +668,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 	cur_base = uaddr & PAGE_MASK;
 	iova &= PAGE_MASK;
-	nchunks = 0;
 
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
@@ -683,7 +682,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			}
 			goto out;
 		}
-		nchunks++;
 
 		if (!last_pfn)
 			map_pfn = page_to_pfn(page_list[0]);
@@ -714,7 +712,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 
 				map_pfn = this_pfn;
 				iova += csize;
-				nchunks = 0;
 			}
 
 			last_pfn = this_pfn;
@@ -729,7 +726,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			     PFN_PHYS(map_pfn), perm);
 out:
 	if (ret) {
-		if (nchunks) {
+		if (last_pfn) {
 			unsigned long pfn;
 
 			/*
@@ -741,7 +738,6 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 			 * the corresponding unpinning will be handled by
 			 * vdpa_unmap().
 			 */
-			WARN_ON(!last_pfn);
 			for (pfn = map_pfn; pfn <= last_pfn; pfn++)
 				unpin_user_page(pfn_to_page(pfn));
 		}
-- 
2.53.0



