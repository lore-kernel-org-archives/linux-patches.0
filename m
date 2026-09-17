Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4075049D587;
	Thu, 17 Sep 2026 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670544; cv=none; b=upzJPyqxanm/kAZxzTxZn9mzxN/2VIiGpSdsopmDL8F0mRmA1GfyLU8vtZpH0SaoqT27phbLYhyA7T3i41/VM29xiP+OWcztRicPHogsudE24xuwkp2wdD6JNyZQf2khcCsKniFRC+mNlQrhksiVtyLnkEdt5FNGIo/oClILrt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670544; c=relaxed/simple;
	bh=dwSPjAo/3hLZOxbJkan9Dn6UDrlHQzVvjg9kocghzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7j8eZRKVqKK0WTpDyZ5BnfmYNC57JR/iZxKzUM2M0vjnhE2bN3PM7l8CW5h0eOdJwUlKUVV8oAUc9eDM0Wqk2ABrDdvQFAsPDmFLcx/mV2ZV4PROe+rucdw/YaDvsuP+PggMXXifH3in2OIje8vRXXAHmV2ln1hO/Bqnu9AgEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1ITtDsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1ITtDsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEF81F000FF;
	Thu, 17 Sep 2026 18:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670543;
	bh=jSvobYaQ0H3g5w5PCTrOPEeS6jHfX9AwDMQy3rzv46U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1ITtDsIl0ToNFOdO4ZpX9FkczxlwHAEBtXgT5h9KTwbr4JXJTAHuHFUmWMB+1hdz
	 0okCkiuZ+H/p4Xfx2n88iu9sLdh6XskppqHFzynyTUkU4vbwRs1LT/mNCML1S4ZQOl
	 lnr/peyzfaUCVtHuKMefNh7TRv5aueTOxnpqvmq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0678/1102] s390/ism: folio_put() after error
Date: Thu, 17 Sep 2026 16:10:21 +0100
Message-ID: <20260917151557.259640048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 907a56ab3eb8a58500a58daa76087f17bb2b6826 ]

dmb->cpu_addr was allocated via folio_alloc(). Use folio_put() instead of
kfree() in the error exit of ism_alloc_dmb() to avoid slab allocator
corruption.

While at it, reset dmb->cpu_addr after folio_put to avoid unintentional UAF
by future callers.

Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20260902143733.433574-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 7cfc4f9862977..f2264cf6f40d8 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -297,6 +297,7 @@ static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
 		       DMA_FROM_DEVICE);
 	folio_put(virt_to_folio(dmb->cpu_addr));
+	dmb->cpu_addr = NULL;
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
@@ -340,7 +341,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	return 0;
 
 out_free:
-	kfree(dmb->cpu_addr);
+	folio_put(folio);
+	dmb->cpu_addr = NULL;
 out_bit:
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
 	return rc;
-- 
2.53.0



