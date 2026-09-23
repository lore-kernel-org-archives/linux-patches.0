Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF4C5326DD;
	Wed, 23 Sep 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174214; cv=none; b=bbXaEDypwcxpLqddEFnZfBxnm+p+yLxDwcV/R+50Z/aA7taajNaFDb2voiPbtC5d17gUgDgCz2tvzHM0pjjp8i4IegE2ZYdv5pob20Pl4XV8FPMoCcwo+re+o8JCyfuuwQwQd/IooSrrY2nGOeCPfsc39kIPe+9WcFWKX7FncQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174214; c=relaxed/simple;
	bh=Gfcv94jAdkzImcx0SV0jtCEfwYnbsjThn389foBlSvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGSyD6PP0fXEWBEM+CtxnZXfozbBpA52bAaJO/CXaae6iwq5dD3I91z7qve6UGIJGP9i4N0k3w3SDH6U6Zy5/XlkzGkZSwBeUNRXDxeJmSr/FP9V9KX8irXG2A02FVqrEwVQPX9FZyNdDf7N2vOE5FvgMqhVnScY1t3xe4PMSFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NraM6pdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NraM6pdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A51F000FF;
	Wed, 23 Sep 2026 14:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174213;
	bh=UWkZpDDuWu4EyyhWKx3d48k+NJH8lsBkbFjhK1daEHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NraM6pdMLmfLRL8RPsUj6MI3fBcMNSI6RE/2WR1f/LzfV0d7b5EcfD81aCHu+dOsc
	 UvdiorPjTpIvX0KEA3qE6Ze8vMnPpp3o/2b0nDuIh1RfZd/ziR5K6QRzWTILohtdnz
	 /rydbAuDUVPfRFAlkLe8C/2vJsrcDL19Qc+sq2/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/398] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Wed, 23 Sep 2026 16:02:00 +0200
Message-ID: <20260923140644.617446656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Peng Hao <flyingpenghao@gmail.com>

[ Upstream commit a3d722190cdef18da4878b5efc27c3c386dda248 ]

mwifiex_pcie_request_irq() registers each MSI-X vector with a per-index
dev_id (&card->msix_ctx[i]). On a request_irq() failure the cleanup loop
"for (j = 0; j < i; j++)" frees msix_entries[j].vector but passes the
failed index's &card->msix_ctx[i] as the dev_id. free_irq() matches on
(irq, dev_id), so it fails to find the action registered with
&card->msix_ctx[j]: the already-requested IRQ j is not freed (leaked) and
free_irq() warns about freeing a non-existent IRQ. Use &card->msix_ctx[j].

Fixes: 99074fc1e67b ("mwifiex: enable pcie MSIx interrupt mode support")
Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Link: https://patch.msgid.link/20260828111531.56723-1-flyingpeng@tencent.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a760de191fce7..a9425e9a94f45 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3068,7 +3068,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 					    ret);
 				for (j = 0; j < i; j++)
 					free_irq(card->msix_entries[j].vector,
-						 &card->msix_ctx[i]);
+						 &card->msix_ctx[j]);
 				pci_disable_msix(pdev);
 			} else {
 				mwifiex_dbg(adapter, MSG, "MSIx enabled!");
-- 
2.53.0



