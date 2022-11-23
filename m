Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7057B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C04EC433D7;
	Wed, 23 Nov 2022 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193902;
	bh=KxItM2fIxvzJQB9PTKchU5tR2R5iX7fV1lq9q5VPelE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx6gryNfllBXt3+SUPHWRLCEjcTfvru57xSW4NiEvyM4nOjayNdhPxyzz+twmSLO3
	 Muli16cum8QlCEljyUs0eZZkIg3arbALn5YfPNas7sfDh9DsUhPvFDjV32r9w3vxEL
	 AKlAzQX/6d9s8l260LBTmhJh0/WyW3ZJ041FA7Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Navgire <anavgire@purestorage.com>,
	Alex Barba <alex.barba@broadcom.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/88] bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
Date: Wed, 23 Nov 2022 09:50:00 +0100
Message-Id: <20221123084548.657589437@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Barba <alex.barba@broadcom.com>

[ Upstream commit 02597d39145bb0aa81d04bf39b6a913ce9a9d465 ]

In the bnxt_en driver ndo_rx_flow_steer returns '0' whenever an entry
that we are attempting to steer is already found.  This is not the
correct behavior.  The return code should be the value/index that
corresponds to the entry.  Returning zero all the time causes the
RFS records to be incorrect unless entry '0' is the correct one.  As
flows migrate to different cores this can create entries that are not
correct.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Akshay Navgire <anavgire@purestorage.com>
Signed-off-by: Alex Barba <alex.barba@broadcom.com>
Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 17592aeb2618..89782e8e0b91 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7504,8 +7504,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(fltr, head, hash) {
 		if (bnxt_fltr_match(fltr, new_fltr)) {
+			rc = fltr->sw_id;
 			rcu_read_unlock();
-			rc = 0;
 			goto err_free;
 		}
 	}
-- 
2.35.1



