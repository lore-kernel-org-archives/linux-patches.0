Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF317E8;
	Sat, 13 Jan 2024 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttFOjwKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD0FC433F1;
	Sat, 13 Jan 2024 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139656;
	bh=WNwfl+SBrAkK5cGDLrUFieqC8i2UOvT14Jr2d/onaMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttFOjwKAXbY8FYK2dZC68GJczBBweMSh98qVBD7+L0PqrGk84/WwRo+OioRa7fI+M
	 7h01/xg065SITvPVMiIUyB93wXmqRF1RvMhTimZXb39LGcNUJC921M8ftexj3Eun6y
	 eed2CCun78EZyAMYiFe0ziZmNwlY/SD/Oc3Ck0v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/25] bnxt_en: Remove mis-applied code from bnxt_cfg_ntp_filters()
Date: Sat, 13 Jan 2024 10:49:53 +0100
Message-ID: <20240113094205.425957997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094205.025407355@linuxfoundation.org>
References: <20240113094205.025407355@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit e009b2efb7a8850498796b360043ac25c8d3d28f ]

The 2 lines to check for the BNXT_HWRM_PF_UNLOAD_SP_EVENT bit was
mis-applied to bnxt_cfg_ntp_filters() and should have been applied to
bnxt_sp_task().

Fixes: 19241368443f ("bnxt_en: Send PF driver unload notification to all VFs.")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d79281c6d915d..ca817b251ef58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7847,6 +7847,8 @@ static void bnxt_sp_task(struct work_struct *work)
 		bnxt_cfg_ntp_filters(bp);
 	if (test_and_clear_bit(BNXT_HWRM_EXEC_FWD_REQ_SP_EVENT, &bp->sp_event))
 		bnxt_hwrm_exec_fwd_req(bp);
+	if (test_and_clear_bit(BNXT_HWRM_PF_UNLOAD_SP_EVENT, &bp->sp_event))
+		netdev_info(bp->dev, "Receive PF driver unload event!\n");
 	if (test_and_clear_bit(BNXT_VXLAN_ADD_PORT_SP_EVENT, &bp->sp_event)) {
 		bnxt_hwrm_tunnel_dst_port_alloc(
 			bp, bp->vxlan_port,
@@ -8407,8 +8409,6 @@ static void bnxt_cfg_ntp_filters(struct bnxt *bp)
 			}
 		}
 	}
-	if (test_and_clear_bit(BNXT_HWRM_PF_UNLOAD_SP_EVENT, &bp->sp_event))
-		netdev_info(bp->dev, "Receive PF driver unload event!");
 }
 
 #else
-- 
2.43.0



