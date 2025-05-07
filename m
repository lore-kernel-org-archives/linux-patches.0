Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348421CF5C6;
	Wed,  7 May 2025 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644735; cv=none; b=NDjk2RxiqSLHCE3h0DN2DsKEpc8eXZMmMS9MIkkTJGuUtcIHKJZhyFSFysktzN5aIQ45nQP83Q5JycztHEeORzTtzh8+WVguuF7AQHjivuLlVJG52Fj5k/y9/+yKTLLzL0eey20jjOXp+vcoYDUWn//R2gyJA8VFLf6oAwJEyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644735; c=relaxed/simple;
	bh=ux1aD0B6Tx4xP39ef+4IQ4WNl3kljlWy1nTIOP0A4dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBDkKKdXwWwh2iuHbIZRGZdJQoAg/eTaHHrT5kCjmQ9ZSDGlkgpVA8C2GMhQnvQnCtoj7I6oRQz+EE/zycRpYt9B6CWZP6aiqDROwZDfvaRk8I5eRlup3FYruTzCbLtzn5Wr6sY8pnpist5uVIErikbp0jVmT142h2CJI9rI2vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxMD6iRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxMD6iRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0D4C4CEE9;
	Wed,  7 May 2025 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644735;
	bh=ux1aD0B6Tx4xP39ef+4IQ4WNl3kljlWy1nTIOP0A4dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxMD6iRjjQzstq0ff9Fn/n4JUZiXyPzK/EZMlmAHp8Pgod1Ur+OTUM09L9piQR8FV
	 SxwT+NomY1YFNuC2PeTLwuJYC/PTk8pvkJzMwkUz79JGazC4GmWIBN/8eCVjXvaErY
	 TPyenxPdSUq1RZRfI7y7ERRxG8jSuzbRFrlZKAN0=
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
Subject: [PATCH 6.12 122/164] bnxt_en: fix module unload sequence
Date: Wed,  7 May 2025 20:40:07 +0200
Message-ID: <20250507183825.912106458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e4d5bd30cf319..12b61a6fcda42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15421,8 +15421,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 
 	bnxt_rdma_aux_device_del(bp);
 
-	bnxt_ptp_clear(bp);
 	unregister_netdev(dev);
+	bnxt_ptp_clear(bp);
 
 	bnxt_rdma_aux_device_uninit(bp);
 
-- 
2.39.5



