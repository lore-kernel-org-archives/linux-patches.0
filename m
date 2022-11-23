Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031147B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F53C433C1;
	Wed, 23 Nov 2022 08:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193646;
	bh=asc465cBKj0TtgHS5OylIPjBUaBnVpMAv89pMX/9uWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rt3OvuYtcY5e5+ehRfrXNHHrfABjsv0LUW9VS3zuzNO7jxptfZJVxdcJAfgWdxgeu
	 aIPAsDYXNmyqBa6CvIzBBxb30ydzwCPf8CWXbp9Sq/XPUjc0AhRbzVx/WgqAXtbkv9
	 Ve30GdZ3eT61yBzB7wOXLgX7bJf+Zp1fl+CQZo8s=
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
Subject: [PATCH 4.9 03/76] bnxt_en: fix potentially incorrect return value for ndo_rx_flow_steer
Date: Wed, 23 Nov 2022 09:50:02 +0100
Message-Id: <20221123084546.857309682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index 77dadbe1a446..ceaa066bdc33 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6577,8 +6577,8 @@ static int bnxt_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
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



