Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC00B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC83C433C9;
	Mon, 11 Sep 2023 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440698;
	bh=wFz8VkyA+LhA40IUrwxxMX8GkqpRUT5A76CmuDfDnmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuycfLjaYkxFKFJvdjGaDVI2yvnq6K8werH9NmUsirv5wksdEd/TTB0tHITLo5/m+
	 SiX9/Lot8v7T9+o6zrq0IaYUIZ5eRKEL9Q3FoTsQ9skgw20w7zLpKXAr1s2uYiJ8zT
	 eGVIAkACZKotWJJdECl4CTwGUCTCghTf0gJOD0mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 154/739] net: lan966x: Fix return value check for vcap_get_rule()
Date: Mon, 11 Sep 2023 15:39:13 +0200
Message-ID: <20230911134655.444407013@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruan Jinjie <ruanjinjie@huawei.com>

[ Upstream commit ab104318f63997113b0ce7ac288e51359925ed79 ]

As Simon Horman suggests, update vcap_get_rule() to always
return an ERR_PTR() and update the error detection conditions to
use IS_ERR(), so use IS_ERR() to fix the return value issue.

Fixes: 72df3489fb10 ("net: lan966x: Add ptp trap rules")
Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 266a21a2d1246..1da2b1f82ae93 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -59,7 +59,7 @@ static int lan966x_ptp_add_trap(struct lan966x_port *port,
 	int err;
 
 	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
-	if (vrule) {
+	if (!IS_ERR(vrule)) {
 		u32 value, mask;
 
 		/* Just modify the ingress port mask and exit */
@@ -106,7 +106,7 @@ static int lan966x_ptp_del_trap(struct lan966x_port *port,
 	int err;
 
 	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
-	if (!vrule)
+	if (IS_ERR(vrule))
 		return -EEXIST;
 
 	vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, &value, &mask);
-- 
2.40.1



