Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77515683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255D9C433D2;
	Mon,  3 Apr 2023 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531076;
	bh=C0FLhrOXWMhJz0PAJwRu0Uzl46me5i3kX96oWvGA5ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3DB0jw6e4bMSr3UeLbicpsZ/klAbm8WE9Gy+/CpzIg5aD2laFRfInyMAA86B1QJu
	 HsCGKUrjDb7IvNxr5p9vUEPSh1E7aaMl2TuC1s430WEWLGguMmMmJIo/t+fw8map3A
	 AOXsCpYKxipDkdX2yL+PE5CUKh8V8z83/ldwIodA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Marek Szlosek <marek.szlosek@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/66] intel/igbvf: free irq on the error path in igbvf_request_msix()
Date: Mon,  3 Apr 2023 16:08:11 +0200
Message-Id: <20230403140351.835051222@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 85eb39bb39cbb5c086df1e19ba67cc1366693a77 ]

In igbvf_request_msix(), irqs have not been freed on the err path,
we need to free it. Fix it.

Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 98fd214f2c42b..cc1a608904ab8 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1093,7 +1093,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq_tx;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1102,10 +1102,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq_rx;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq_rx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq_tx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
-- 
2.39.2



