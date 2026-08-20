Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D9E361657;
	Thu, 20 Aug 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243310; cv=none; b=olOG6BuhKEUjqrClTq2xbxtDDwvMZ1SvTz3NCEVw1ba/YQFtlLwkm+2xxyFR25Xv5I9mXkeCurXPn0qCTIK1OqeugAgSh5x1SPXu3gx7cZgeFX28LHc+lL6gVwPN7EeqJygO0gUgkqPjbq1r3+Y540QWokrxnWaleYJf/Yr22Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243310; c=relaxed/simple;
	bh=wf0MItR8JymabHZ62IV3V3GnmPHrQN6RPAtkt6EwAoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGDH57Qd3+npBKt28G19zpoZpiamm3LfrYCj8DCK09G70wqClfqET1NPKvBp/EpSDrKM8CpO4TGUW7BHYr2cKyXEXQvXW689WnRoT34x+HTIu4EI8cbE9+u+MpGLpHR/sXA1JiIL6w6GFBdfZc/LBOw0zc2ZK2R+sQtZuCdCpqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntITyBi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntITyBi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D2A1F000E9;
	Thu, 20 Aug 2026 16:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243308;
	bh=wcYRStBgtmZAR3rkBk+mM952I91dLzj1AaRufaWJtEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntITyBi2o4nCNxRBB5VMxJHLSCYBDMZBMXqz7ZDGFl2EDFv2mqcLr/nQsbnewBHIJ
	 r3EeODNT8XVkH7YMHPF/UuIFWARy+hNxdY/CVL//pCRdoSpzxuLFnFtGfCVmOm1gXo
	 ynwseId9gBUWW3wLdeTVIXRChHdoT4uF/uMp+d+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/272] udmabuf: Do not create malformed scatterlists
Date: Thu, 20 Aug 2026 16:53:54 +0200
Message-ID: <20260820145232.720576934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5bf888673e0dda5a53220fa0c4956271a46c353c ]

Using a sg_set_folio() loop for every 4K results in a malformed scatterlist
because sg_set_folio() has an issue with offsets > PAGE_SIZE and because
scatterlist expects the creator to build a list which consolidates any
physical contiguity.

sg_alloc_table_from_pages() creates a valid scatterlist directly from a
struct page array, so go back to that.

Remove the offsets allocation and just store an array of tail pages as it
did before the below commit. Everything wants that anyhow.

Fixes: 0c8b91ef5100 ("udmabuf: add back support for mapping hugetlb pages")
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/20260308-scatterlist-v1-1-39c4566b0bba@gmail.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/0-v1-42779f29381a+4b9-udmabuf_sg_jgg@nvidia.com
Stable-dep-of: 504e2b4ab97a ("dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -72,14 +72,16 @@ static struct sg_table *get_sg_table(str
 					0, ubuf->pagecount << PAGE_SHIFT,
 					GFP_KERNEL);
 	if (ret < 0)
-		goto err;
+		goto err_alloc;
+
 	ret = dma_map_sgtable(dev, sg, direction, 0);
 	if (ret < 0)
-		goto err;
+		goto err_map;
 	return sg;
 
-err:
+err_map:
 	sg_free_table(sg);
+err_alloc:
 	kfree(sg);
 	return ERR_PTR(ret);
 }


