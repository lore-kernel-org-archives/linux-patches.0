Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509BE214813;
	Wed,  7 May 2025 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644147; cv=none; b=AlXpJuiFQkdTvglQeE0SmPwJGYTTDzMjL08aCWkEYr0CsQxLE41GO80nFHg/XHuBuvwC26irpXiLlhwtOT7vjSTVd+Ix2ULsuFpuiedHLtTgDloYKeeGg/sjviP7gUGMr59p25XmR25n8qzZy/aSTPiBp0YydlT121ifaEzKAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644147; c=relaxed/simple;
	bh=FBaBtMiGb8LLLyHn5S2/3Ibbp42PlYOcmYVRZSVgZJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBRxidUQtQtSxHqsKwfEa1EgEZCq4FBKcrZDvgPke7/iXaUXX4TY2DcRkFe6qHTJtS9VnOIlBSOFAVV4tEoaw2eaNHMj+OOUMdau0/ZVB583cX2L4Kn5hgN/hXuFM8XTgAOv3rdqG8OxkQPoAkyrs08xKBFNeRvzS9spsix/t88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNbYy1Qo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNbYy1Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52A0C4CEE2;
	Wed,  7 May 2025 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644147;
	bh=FBaBtMiGb8LLLyHn5S2/3Ibbp42PlYOcmYVRZSVgZJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNbYy1QoXh3yswF7gB5oX/dlbRomEzHqp/PsYAgo4eAuCSzzqsrCqKkW/X7N9sAyz
	 +svZlzUqY/56tfJCVxYmXTmp7bZMtQ8DCsWtmihhFbqA9PH36Go3VkdkLH1rtPCroL
	 ILfS/Jc6yiheNc61Vjj0QSVyoGfWPdyuqa9nNYX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Vadim Fedorenko <vadfed@meta.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 134/183] bnxt_en: fix module unload sequence
Date: Wed,  7 May 2025 20:39:39 +0200
Message-ID: <20250507183830.246842719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit 927069d5c40c1cfa7b2d13cfc6d7d58bc6f85c50 ]

Recent updates to the PTP part of bnxt changed the way PTP FIFO is
cleared, skbs waiting for TX timestamps are now cleared during
ndo_close() call. To do clearing procedure, the ptp structure must
exist and point to a valid address. Module destroy sequence had ptp
clear code running before netdev close causing invalid memory access and
kernel crash. Change the sequence to destroy ptp structure after device
close.

Fixes: 8f7ae5a85137 ("bnxt_en: improve TX timestamping FIFO configuration")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Closes: https://lore.kernel.org/netdev/CAMArcTWDe2cd41=ub=zzvYifaYcYv-N-csxfqxUvejy_L0D6UQ@mail.gmail.com/
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Tested-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20250430170343.759126-1-vadfed@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a414d7d721b20..bd8b9cb05ae98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15731,8 +15731,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 
 	bnxt_rdma_aux_device_del(bp);
 
-	bnxt_ptp_clear(bp);
 	unregister_netdev(dev);
+	bnxt_ptp_clear(bp);
 
 	bnxt_rdma_aux_device_uninit(bp);
 
-- 
2.39.5



