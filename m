Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07D1FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186ABC433EF;
	Mon, 15 May 2023 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172943;
	bh=hCrY4jyxNQ4CJJLdiS9xm5clus0qWcE3FDl2BQsYHoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlHClz24Siy9OdvaT9gT9jQhhh6OkwBfSavZMYoSR1QQ3g8IMs7yqKRPh9WrnQq6b
	 Ieehm+J1zJYon2PLJAOtsR/OKmcnxMHodGTxnVO+CBQfnN32bhWUr/XBA0eTGJzJfT
	 bcCRc9rZzWB09fgvEgScoLQyx8lA5rqRnBD04Gu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Moreton <andy.moreton@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/381] sfc: Fix module EEPROM reporting for QSFP modules
Date: Mon, 15 May 2023 18:29:27 +0200
Message-Id: <20230515161751.091158216@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Moreton <andy.moreton@amd.com>

[ Upstream commit 281900a923d4c50df109b52a22ae3cdac150159b ]

The sfc driver does not report QSFP module EEPROM contents correctly
as only the first page is fetched from hardware.

Commit 0e1a2a3e6e7d ("ethtool: Add SFF-8436 and SFF-8636 max EEPROM
length definitions") added ETH_MODULE_SFF_8436_MAX_LEN for the overall
size of the EEPROM info, so use that to report the full EEPROM contents.

Fixes: 9b17010da57a ("sfc: Add ethtool -m support for QSFP modules")
Signed-off-by: Andy Moreton <andy.moreton@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mcdi_port_common.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index c4fe3c48ac46a..eccb97a5d9387 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -974,12 +974,15 @@ static u32 efx_mcdi_phy_module_type(struct efx_nic *efx)
 
 	/* A QSFP+ NIC may actually have an SFP+ module attached.
 	 * The ID is page 0, byte 0.
+	 * QSFP28 is of type SFF_8636, however, this is treated
+	 * the same by ethtool, so we can also treat them the same.
 	 */
 	switch (efx_mcdi_phy_get_module_eeprom_byte(efx, 0, 0)) {
-	case 0x3:
+	case 0x3: /* SFP */
 		return MC_CMD_MEDIA_SFP_PLUS;
-	case 0xc:
-	case 0xd:
+	case 0xc: /* QSFP */
+	case 0xd: /* QSFP+ */
+	case 0x11: /* QSFP28 */
 		return MC_CMD_MEDIA_QSFP_PLUS;
 	default:
 		return 0;
@@ -1077,7 +1080,7 @@ int efx_mcdi_phy_get_module_info(struct efx_nic *efx, struct ethtool_modinfo *mo
 
 	case MC_CMD_MEDIA_QSFP_PLUS:
 		modinfo->type = ETH_MODULE_SFF_8436;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		break;
 
 	default:
-- 
2.39.2



