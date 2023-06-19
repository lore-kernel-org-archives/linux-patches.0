Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1E05381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA9C433C8;
	Mon, 19 Jun 2023 10:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170999;
	bh=xUIZ23c+3tN02lO0oTMrtSf2owuRlG5/4NrqvimrJLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWaYs3w/qVib4bWZyLUJnS7VTG92Uus6SvoXz2QXcOOzE7eoxerPf5UtAV42H9OS6
	 uL1QKnW4VuZ+3+F1hOgNyyakHXIOYLJzZHZpvpF+MmKG4cFKiFjxksE5BsbwWxprdC
	 FrfjNS7+DxKVOG5tMs30UsQZ5MHCxdSP5QQ69Axs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.3 094/187] thunderbolt: dma_test: Use correct value for absent rings when creating paths
Date: Mon, 19 Jun 2023 12:28:32 +0200
Message-ID: <20230619102202.138615313@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 70c2e03e9aaf17496c63f6e42333c012f5ae5307 upstream.

Both tb_xdomain_enable_paths() and tb_xdomain_disable_paths() expect -1,
not 0, if the corresponding ring is not needed. For this reason change
the driver to use correct value for the rings that are not needed.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Cc: stable@vger.kernel.org
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/dma_test.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/dma_test.c
+++ b/drivers/thunderbolt/dma_test.c
@@ -192,9 +192,9 @@ static int dma_test_start_rings(struct d
 	}
 
 	ret = tb_xdomain_enable_paths(dt->xd, dt->tx_hopid,
-				      dt->tx_ring ? dt->tx_ring->hop : 0,
+				      dt->tx_ring ? dt->tx_ring->hop : -1,
 				      dt->rx_hopid,
-				      dt->rx_ring ? dt->rx_ring->hop : 0);
+				      dt->rx_ring ? dt->rx_ring->hop : -1);
 	if (ret) {
 		dma_test_free_rings(dt);
 		return ret;
@@ -218,9 +218,9 @@ static void dma_test_stop_rings(struct d
 		tb_ring_stop(dt->tx_ring);
 
 	ret = tb_xdomain_disable_paths(dt->xd, dt->tx_hopid,
-				       dt->tx_ring ? dt->tx_ring->hop : 0,
+				       dt->tx_ring ? dt->tx_ring->hop : -1,
 				       dt->rx_hopid,
-				       dt->rx_ring ? dt->rx_ring->hop : 0);
+				       dt->rx_ring ? dt->rx_ring->hop : -1);
 	if (ret)
 		dev_warn(&dt->svc->dev, "failed to disable DMA paths\n");
 


