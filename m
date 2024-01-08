Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C853806;
	Mon,  8 Jan 2024 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIgjXtPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028D7C433CD;
	Mon,  8 Jan 2024 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728594;
	bh=tsgz381MDiHj2pzbmkwh822xqexDu2jj1j8JEZJdpfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIgjXtPgG/8BmO8kvRPkSKdvCTzTPPc2iqlnDzmQDMXvYiDdBbfme8NB5AjDu56Wr
	 NzAIx40HLoZM9mHgvXdq74UAmZbXAqaULn++1KMjMcFwFC6D0puKzqwohZQ8eHLC3Q
	 mxGlqNOqcyN7yXiWt/bd8Zx+vHNeMgx6sXSdlVMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/150] octeontx2-af: Fix pause frame configuration
Date: Mon,  8 Jan 2024 16:36:18 +0100
Message-ID: <20240108153517.045170134@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit e307b5a845c5951dabafc48d00b6424ee64716c4 ]

The current implementation's default Pause Forward setting is causing
unnecessary network traffic. This patch disables Pause Forward to
address this issue.

Fixes: 1121f6b02e7a ("octeontx2-af: Priority flow control configuration support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index a70e1153fa04b..6b4792a942d84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -283,6 +283,11 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	cfg = FIELD_SET(RPM_PFC_CLASS_MASK, 0, cfg);
 	rpm_write(rpm, lmac_id, RPMX_CMRX_PRT_CBFC_CTL, cfg);
 
+	/* Disable forward pause to driver */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+
 	/* Enable channel mask for all LMACS */
 	rpm_write(rpm, 0, RPMX_CMR_CHAN_MSK_OR, ~0ULL);
 }
@@ -451,12 +456,10 @@ int rpm_lmac_pfc_config(void *rpmd, int lmac_id, u8 tx_pause, u8 rx_pause, u16 p
 
 	if (rx_pause) {
 		cfg &= ~(RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE |
-				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE |
-				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD);
+			 RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE);
 	} else {
 		cfg |= (RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE |
-				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE |
-				RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_FWD);
+			RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE);
 	}
 
 	if (tx_pause) {
-- 
2.43.0



