Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704109;
	b=g1RAjbjwLu7+iBUta7ywJBG6z9tXnKC4zHfIS2B6l0IGxAP63P7byDiNJOItAeH4+Mf/
	 vQX+NJyGSaG7y1rPWDVIvt61y3CFlOkwVl2SSs3+tSrJtUCalQXUil5x+x8FrFxKMd3fq
	 sl/TTu/2B55hdjzavbH8VVMzeB6xX6JMz1Fp03ZWUmbIyalKVueq50nynHabSeJAE2hvF
	 RH1veo/nFWUYdNjAbqir2IzXtowK20gMWg2CooWe9+ZOe3V2apJWVFxaw0JcpAPc4xeTk
	 VWz0TGN8MeDB2zQ1Pzr9pWX1IQiBtMKJwoO9Qr1+OOSi9RWTd7pfoHNh4ZjwBX4u7WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CiAVki+thDWmxbAHdOBuxFsn7meLfucpGgUkwAIAonE=;
	b=tA+Qdb/i5StfLMRfxfLnz8HrVPbhhP+FRv4HxNMSbiyT6niELdsyfUCpXz4YW1cT7O0k
	 ZFtpOC3acoFbn+sCRo9aF8b+sXAYsbPceocLwCrR8+hflqkWJZLb3D+Bd0pn/nwFoII3N
	 PSUlYnwAB/G7Npc+goxMud5siRwNaRw8oVobmECPQFFIjEMoodrQUYtICx9D2+4QIbZq2
	 X98C3RmaYKkFtE06m7WEMds92fBnCBFLH5xFAubLrYsk+gemfY25bzGoTh0TkUie8a0Em
	 xZPejavax+nWVjG1uG1bik5dJPeuVKaLN6dQIOvmwCTdj4lnRrMhZ3niV7c7Zrru3uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLtJ5qUl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA23E606A31C;
	Thu, 26 Nov 2026 14:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLtJ5qUl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21731F000C0;
	Thu, 26 Nov 2026 14:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704109;
	bh=CiAVki+thDWmxbAHdOBuxFsn7meLfucpGgUkwAIAonE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLtJ5qUlyqjx+SQPDvahOs6QRgSAV5mAwADkvOR1xCN78TvhQOv7EQJJ0A64scqXj
	 SdeBiL2yWs9dT41dFOYRMFrN9/hIM6ffptEFyQTU6Ky1e97aW2ux9huHwAuyEZ/wdK
	 SMhKS2pbA/92jNVE0+Jrq42gVjaw8aMIVjNKji+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/265] vhost/vdpa: reject overflowing PA map page counts on 32-bit
Date: Thu, 26 Nov 2026 15:35:40 +0100
Message-ID: <20261126143605.786440588@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 0619aaa34c0c2a2dcb07f0e9c8a34e7efb8c4cdf ]

vhost_vdpa_pa_map() adds the IOVA page offset to the user-controlled map
size before computing the number of pages to pin. On 32-bit systems,
where unsigned long is narrower than u64, that addition can overflow and
the code can pin and map fewer pages than the requested IOTLB range.

Reject sizes that overflow the unsigned long page-count calculation.

Fixes: 22af48cf91aa ("vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <CAMuQ4bX-iDvcUOPPY+NLz95tkRJYwWqvzAr=U48uNaub_HZLGw@mail.gmail.com>
Stable-dep-of: fd1462c96baf ("vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 43e7528b8fa03..32dde456a181a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -633,6 +633,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
 	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
 	int ret = 0;
@@ -645,7 +646,13 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	if (perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PFN_UP(size + (iova & ~PAGE_MASK));
+	page_offset = iova & ~PAGE_MASK;
+	if (size > ULONG_MAX - page_offset) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	npages = PFN_UP(size + page_offset);
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
-- 
2.53.0



