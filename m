Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C11846;
	Sat, 13 Jan 2024 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK/ruyEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A92C433C7;
	Sat, 13 Jan 2024 09:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139844;
	bh=JoTIvdSrnZ7FacuOJs1bev78sekHnP3GIGTc2Uyi6xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK/ruyEIDnYavD+PtQasjJpaOLp1W+Z5Sik0leeCMZ2tU4Vl9p/h1n5eR3rsxjYho
	 fW49IkRPmvv5+pAx2dHNi5jTcnCxP1QlLv0ysPrLyeqU99dPXbsgLji6i5jFz/RW+2
	 sreyrPwkLrxN54gIlD2rATNoOP+mblPkCchodokE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/43] sfc: fix a double-free bug in efx_probe_filters
Date: Sat, 13 Jan 2024 10:49:50 +0100
Message-ID: <20240113094207.289451444@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit d5a306aedba34e640b11d7026dbbafb78ee3a5f6 ]

In efx_probe_filters, the channel->rps_flow_id is freed in a
efx_for_each_channel marco  when success equals to 0.
However, after the following call chain:

ef100_net_open
  |-> efx_probe_filters
  |-> ef100_net_stop
        |-> efx_remove_filters

The channel->rps_flow_id is freed again in the efx_for_each_channel of
efx_remove_filters, triggering a double-free bug.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Link: https://lore.kernel.org/r/20231225112915.3544581-1-alexious@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/rx_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 36b46ddb67107..0ea3168e08960 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -837,8 +837,10 @@ int efx_probe_filters(struct efx_nic *efx)
 		}
 
 		if (!success) {
-			efx_for_each_channel(channel, efx)
+			efx_for_each_channel(channel, efx) {
 				kfree(channel->rps_flow_id);
+				channel->rps_flow_id = NULL;
+			}
 			efx->type->filter_table_remove(efx);
 			rc = -ENOMEM;
 			goto out_unlock;
-- 
2.43.0



