Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910426FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6C2C433D2;
	Mon,  3 Apr 2023 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533250;
	bh=hC3hSOEkwIzy9efsheKlHFY4fiD1g1yw28jKqQZmX6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L321YBU75igKsUPo/x8G/FMWnOfheunQJLQgRwEMZ7g0j4jy1TqgeECEm57CFn+oR
	 9awNUI2s38VMjdPyZ3HnJCHSSaD+NssKcVLoWyLUofDeM16Z0iClnRya+PGAq/tH3d
	 sUXD0UOG32YJ2JBFyV/kwAN+s/us2EDIC0MRiYWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	Shane Parslow <shaneparslow808@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Martin <mwolf@adiumentum.com>
Subject: [PATCH 6.2 111/187] net: wwan: iosm: fixes 7560 modem crash
Date: Mon,  3 Apr 2023 16:09:16 +0200
Message-Id: <20230403140419.630259679@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 5f70bcbca469a087b54ad2d934185ed69a098576 ]

ModemManger/Apps probing the wwan0xmmrpc0 port for 7560 Modem results in
modem crash.

7560 Modem FW uses the MBIM interface for control command communication
whereas 7360 uses Intel RPC interface so disable wwan0xmmrpc0 port for
7560.

Fixes: d08b0f8f46e4 ("net: wwan: iosm: add rpc interface for xmm modems")
Reported-and-tested-by: Martin <mwolf@adiumentum.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217200
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1e6a479766429..c066b0040a3fe 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -587,6 +587,13 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
 		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
 			ipc_imem->ipc_port[ctrl_chl_idx] = NULL;
+
+			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7560_ID &&
+			    chnl_cfg_port.wwan_port_type == WWAN_PORT_XMMRPC) {
+				ctrl_chl_idx++;
+				continue;
+			}
+
 			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7360_ID &&
 			    chnl_cfg_port.wwan_port_type == WWAN_PORT_MBIM) {
 				ctrl_chl_idx++;
-- 
2.39.2



