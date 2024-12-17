Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5811F7568;
	Tue, 17 Dec 2024 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456104; cv=none; b=mFoevwuSV+cLvtB2yZMDrsWLNFN6UnpsOnRu+9UEKk2wXiWPFAowYvypkBq7/cwiE0B1SqDJQCh4MfwBPrZUxpx0N5QE0uwBaRGiuTfj998H5jNjv/1Wqu8mmLk1WRn4byZuo6imSzP/aTL9TafM2lflpDY8YdrB9wGgJd76pLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456104; c=relaxed/simple;
	bh=+TInIydtzLgoMpmZPLYGacVHJaZBHH2eDJ0foHqxV9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9rYGOJknWSawXrYmVxtpVCqrhbj3L5OK+f2/WE4vI4H+mes2vqXNAMFQgTL549b7nipOdORyCFEPBtElqmBKk2S7A0kGZ63b5Ns6dhPZshZGODFNNA1Mxf3xd64RYQHzwXgEkuflYcAL2eN8OIACsOxvChCcL/c4oC4Njbtyws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrtyCmTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrtyCmTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318EC4CED3;
	Tue, 17 Dec 2024 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456104;
	bh=+TInIydtzLgoMpmZPLYGacVHJaZBHH2eDJ0foHqxV9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrtyCmTeJaSY8sEP+GawX0FEJobuGAg19Asla8VgiihH1LguaBIh2FDR1T9iRkgnG
	 KCD7209Cc2aaqeyl9JayS7ZL953Wkx+2gFwds2p8mGzHRIi+z0S24ED1g/ob6Zd1sS
	 cGZmED1mJbeOjlegsAvGk3Gafnv8kTfn5cxCbkRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/109] net: sparx5: fix the maximum frame length register
Date: Tue, 17 Dec 2024 18:07:44 +0100
Message-ID: <20241217170535.878833053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit ddd7ba006078a2bef5971b2dc5f8383d47f96207 ]

On port initialization, we configure the maximum frame length accepted
by the receive module associated with the port. This value is currently
written to the MAX_LEN field of the DEV10G_MAC_ENA_CFG register, when in
fact, it should be written to the DEV10G_MAC_MAXLEN_CFG register. Fix
this.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 60dd2fd603a8..fcdaa37879f7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1119,7 +1119,7 @@ int sparx5_port_init(struct sparx5 *sparx5,
 	spx5_inst_rmw(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(ETH_MAXLEN),
 		      DEV10G_MAC_MAXLEN_CFG_MAX_LEN,
 		      devinst,
-		      DEV10G_MAC_ENA_CFG(0));
+		      DEV10G_MAC_MAXLEN_CFG(0));
 
 	/* Handle Signal Detect in 10G PCS */
 	spx5_inst_wr(PCS10G_BR_PCS_SD_CFG_SD_POL_SET(sd_pol) |
-- 
2.39.5



