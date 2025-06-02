Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AACC22A4E9;
	Mon,  2 Jun 2025 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877524; cv=none; b=P/ILYjVBZI2OT34zIVvyjWS6TqydHozkCrFss0CEX06AKzMThlYk8erfuEhzp/4TAzlHplYvO97svc6Rh2DV9snBeYx7hWQZPq7VsyBN0q+fBG1seVWSBkqH+n6/vPepIIYq4eflx1A9yJHp7h+EHcglumJEh1/Xo9XdgXfhbIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877524; c=relaxed/simple;
	bh=yEn30p3UYNleOKijXeWcT4YvjJ/90cIbE/2YqjVKcgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATnFBEmMY/33N+ZgOcOzblMBl2tGmThMI55cX7Qoy7q4JP4bjfpCNIC+TfvU2AI2StPLPb0+8biRLIS44FoDEBSkfrHWWaqvdPr1stNFhIjjFYFK0eSuH2i81v85NkUvP1XHizZvSZBlQ+M+lCJivL3/FJVKYuRO3t7rx/0RyGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OixQT6Wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OixQT6Wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B66C4CEEB;
	Mon,  2 Jun 2025 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877524;
	bh=yEn30p3UYNleOKijXeWcT4YvjJ/90cIbE/2YqjVKcgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OixQT6WnSbJ7unsNi21XkFQCAe8WrstvpHUjOVDwZC/0Qh/7zKv/oaIbF+tTwYiGR
	 MpU3IS7E5KfWUVWv1FxHFa3o6pf96Lb1ouykh1bXmJUvV3Y350jtxJedC3dQT7bR/x
	 Zn1yBYpqka3wKuzd6lZrHw5JOvR2Fn/nAuc+1te4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 275/325] dmaengine: idxd: Fix passing freed memory in idxd_cdev_open()
Date: Mon,  2 Jun 2025 15:49:11 +0200
Message-ID: <20250602134330.940285003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 0642287e3ecdd0d1f88e6a2e63768e16153a990c upstream.

Smatch warns:
	drivers/dma/idxd/cdev.c:327:
		idxd_cdev_open() warn: 'sva' was already freed.

When idxd_wq_set_pasid() fails, the current code unbinds sva and then
goes to 'failed_set_pasid' where iommu_sva_unbind_device is called
again causing the above warning.
[ device_user_pasid_enabled(idxd) is still true when calling
failed_set_pasid ]

Fix this by removing additional unbind when idxd_wq_set_pasid() fails

Fixes: b022f59725f0 ("dmaengine: idxd: add idxd_copy_cr() to copy user completion record during page fault handling")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230509060716.2830630-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/cdev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -142,7 +142,6 @@ static int idxd_cdev_open(struct inode *
 		if (wq_dedicated(wq)) {
 			rc = idxd_wq_set_pasid(wq, pasid);
 			if (rc < 0) {
-				iommu_sva_unbind_device(sva);
 				dev_err(dev, "wq set pasid failed: %d\n", rc);
 				goto failed_set_pasid;
 			}


