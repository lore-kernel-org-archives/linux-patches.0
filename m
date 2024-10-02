Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464841D0943;
	Wed,  2 Oct 2024 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875483; cv=none; b=hacQ79SpenV1sAnuY40raG++QamOGXaVHKHRj6t6JB4llWZylxghtqQkxI0eA0I+k4+5OTX8Fn0TCz/RqqZR+hLi1tine8eknYcK1n5r6N46iCTIr/3ltNPteKVjCGbNtipLdr5EcMWZeYwatZ/Vpx1Vrk9V/JvPiPgSPzynb1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875483; c=relaxed/simple;
	bh=a+sr3X4GMEpSe19x8RfLxh0ZluH8zwfdXnsObGbl6ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGq0IzDzWT/wloHK1Ta+9iRvTfklg3zvUOiSSjZrsQVWS1y2VH+2ym6YhEcW4nbkn0/Yq+cX5iqmipKNmCayCa8h/zhahr1obnmj3Oaw4b5/L+nC7TjB+bv8oklHl9+onqRWQYwSxKuSlvyC7dQnErrJv8pTlyezE56yMkNTszM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8umlkmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8umlkmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A5CC4CEC5;
	Wed,  2 Oct 2024 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875483;
	bh=a+sr3X4GMEpSe19x8RfLxh0ZluH8zwfdXnsObGbl6ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8umlkmNdH832QhX1p1VGPWEFmfCvwwmuOfW2k6MvUlsBw7Io+tKMT1CMwj83hmdI
	 cIxK2TGBwJnc7FCeGmiXTAIamgBla10RadFJjYn2Srmc57fZ+Wl7ZOrpXCm37oIiGg
	 k6rDCUaSYXuD4NTGbbs/PEJ+M9LICKWv0++GHBaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Joe Damato <jdamato@fastly.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 115/695] fbnic: Set napi irq value after calling netif_napi_add
Date: Wed,  2 Oct 2024 14:51:53 +0200
Message-ID: <20241002125827.063212667@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 9f3e7f11f21ac83cd99428390165177d4953b005 ]

The driver calls netif_napi_set_irq() and then calls netif_napi_add(),
which calls netif_napi_add_weight(). At the end of
netif_napi_add_weight() is a call to netif_napi_set_irq(napi, -1), which
clears the previously set napi->irq value. Fix this by calling
netif_napi_set_irq() after calling netif_napi_add().

This was found when reviewing another patch and I have no way to test
this, but the fix seemed relatively straight forward.

Fixes: bc6107771bb4 ("eth: fbnic: Allocate a netdevice and napi vectors with queues")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20240912174922.10550-1-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 0ed4c9fff5d80..72f88ae7815f4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1012,14 +1012,14 @@ static int fbnic_alloc_napi_vector(struct fbnic_dev *fbd, struct fbnic_net *fbn,
 	nv->fbd = fbd;
 	nv->v_idx = v_idx;
 
-	/* Record IRQ to NAPI struct */
-	netif_napi_set_irq(&nv->napi,
-			   pci_irq_vector(to_pci_dev(fbd->dev), nv->v_idx));
-
 	/* Tie napi to netdev */
 	list_add(&nv->napis, &fbn->napis);
 	netif_napi_add(fbn->netdev, &nv->napi, fbnic_poll);
 
+	/* Record IRQ to NAPI struct */
+	netif_napi_set_irq(&nv->napi,
+			   pci_irq_vector(to_pci_dev(fbd->dev), nv->v_idx));
+
 	/* Tie nv back to PCIe dev */
 	nv->dev = fbd->dev;
 
-- 
2.43.0



