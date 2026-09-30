Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1DD4CC63A;
	Wed, 30 Sep 2026 18:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791909; cv=none; b=dzUIVpnY/R1xWw22nrm43keg+vPu98d63FLaZlQHbUKk1GKlAK19tD6UkbLBf83pHcbfRBf+KxhdBmF5ixoVpHWPDLaxK63EsqdIxyCLRmFN66d3EBkezUaC9UrkQrXK5I/HjRzzPFrxsPY8Aaeptm24irIG8ecv3stjuVF9U5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791909; c=relaxed/simple;
	bh=IVVd6+A4j4oEQ2VRFv4bSaMdeyLw2sYPvLvf6TqhmkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMD5DZJ0m8AW37iwaS3wqbgKuhlRUVth0KUMg4rh/trom9+BnqKUO6EW78MLJpi+OOD7SkL7lgXdbYY/KO0fn5JQqRLay7BSJHWGzxHsfd6RpGNJUzV/UFfFZUzgTR/Ut3wU3onL1qTbviAaNpJqs6dcwJ/i624OaITwaueRutc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoQRO3rP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoQRO3rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94101F0089D;
	Wed, 30 Sep 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791908;
	bh=pNGLz+lGUpVuEP69t6nTUYGd89BCgAXSM11CEiCZ81Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoQRO3rPiX68mk82iRdEoSH4Rk0Wn/PhxWWftaR8R02blxO2kRrXUV3FKGT9HXKf1
	 qzlln8xol8fh81CW2Xwu7SongfLpLHToRiFlcknhn9Q6dxEW6J6x87bN3JoUtswq+u
	 bXKhRITsMtUGzMKJm5YqWv4XeLsFQM5MOaYS18Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Hao <flyingpeng@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/752] wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path
Date: Wed, 30 Sep 2026 17:25:31 +0200
Message-ID: <20260930152408.251848950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 8b3f46586654a..09ec5ffd793b2 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3253,7 +3253,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
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



