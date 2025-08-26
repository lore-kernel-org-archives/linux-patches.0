Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2782135B8;
	Tue, 26 Aug 2025 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218693; cv=none; b=Ol4mD+Lo1GGelnEpNa0Ax3uyLxxyoX+87et9sPihO4NWgMjDC8eAVKDlN2of/IoWxQBvCIWN6ktlBTtoxIq1Myd0fAgxjWl2Fu2DTHTVz2+otPy0waUebPnF4NzxLh4Pah13tFAZCXeRD+Iw9aKegSC4hCQ0AXlcIQR6fQghEoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218693; c=relaxed/simple;
	bh=slB1aR+Eu4KpfkD7jxIpAxKYivSSn4hnOecyYi+WY+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/7I8pVwOUvOvgW7hYOLSFGfTjdF6B9fxFPWxOSpKoLDr4+kIu93c++XxuANlOchEphQKRqnulcBkeZCDZo+c+mYuc12HIiKFr37pPBThvcTy7yZYUqsFj9gMLsvY4kXVI213k8JBu1Tf2rzu3U9+MzkxhmlbwihfWhScS7X2ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5S/+msQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5S/+msQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54B7C4CEF1;
	Tue, 26 Aug 2025 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218692;
	bh=slB1aR+Eu4KpfkD7jxIpAxKYivSSn4hnOecyYi+WY+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5S/+msQ1BzG3r6U/m7nJaRsF0y6+GXXtqUaqGmvoXon/AstACo+0Do5pcNDZ3QsZ
	 m3iP7+nF1kpEJb0i055Zn/W7tRNSLDan1EnPtoqd16SRro6poN01tcBhVFr0VoUToY
	 pBh2H7cCxesuig5LsE863CPH5wotHF9tuDtgK/1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/403] mwl8k: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:07:03 +0200
Message-ID: <20250826110909.352058930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 50459501b9a212dbe7a673727589ee105a8a9954 ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, unmap and return an error.

Fixes: 788838ebe8a4 ("mwl8k: use pci_unmap_addr{,set}() to keep track of unmap addresses on rx")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20250709111339.25360-2-fourier.thomas@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index abd5c8670bc4..a0c15af1b167 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1220,6 +1220,10 @@ static int rxq_refill(struct ieee80211_hw *hw, int index, int limit)
 
 		addr = pci_map_single(priv->pdev, skb->data,
 				      MWL8K_RX_MAXSZ, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, addr)) {
+			kfree_skb(skb);
+			break;
+		}
 
 		rxq->rxd_count++;
 		rx = rxq->tail++;
-- 
2.39.5



