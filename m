Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B455100F;
	Mon,  8 Jan 2024 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlRpGc1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3708C433C7;
	Mon,  8 Jan 2024 15:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728311;
	bh=l+j9XrUCQ+RANByXhHrxfeQVSvbAXEJsudx0x67Jje8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlRpGc1EgVNFw4Ftf9Ks+JJ7KCmMpCJIyv8dP6xVHUOFnc6s36CsEjLPskB8Kt2h6
	 goYwN+iWpiPYVZxloXj0XJfri4WgSBViGuQSGa9GowcFUGnIjOiwMDps0vyJvk5+yn
	 UGhyGHOjg9xJ2nQAT/04FR1h8fpo3vnxf8YTuhZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/150] sfc: fix a double-free bug in efx_probe_filters
Date: Mon,  8 Jan 2024 16:34:48 +0100
Message-ID: <20240108153513.003048957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9220afeddee81..3f290791df1c4 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -820,8 +820,10 @@ int efx_probe_filters(struct efx_nic *efx)
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



