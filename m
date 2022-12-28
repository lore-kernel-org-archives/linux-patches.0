Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181911863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9CFC433D2;
	Wed, 28 Dec 2022 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241185;
	bh=SQKDysGymzgVK+IS8HVsZSd60O6qAgSzzMMTcmRj2lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR+eA3R5sP2uv8eN4f7RzMbf4ulsZfa1iSc6S15sxvhKy3JZluu4/EC1sGl1+bUlb
	 JctQ0PPUw7RhxXACT8BCVVHrs65lm3+WmrGnJs+MBPDr1roKsuqJtfQI333oyT1pdV
	 jXGx8t1dmCwk8yP0TWqjslvkxsFLdd91PulcjRhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/731] usb: typec: tipd: Fix spurious fwnode_handle_put in error path
Date: Wed, 28 Dec 2022 15:39:17 +0100
Message-Id: <20221228144309.599013032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 782c70edc4852a5d39be12377a85501546236212 ]

The err_role_put error path always calls fwnode_handle_put to release
the fwnode. This path can be reached after probe itself has already
released that fwnode though. Fix that by moving fwnode_handle_put in the
happy path to the very end.

Fixes: 18a6c866bb19 ("usb: typec: tps6598x: Add USB role switching logic")
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221114174449.34634-2-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tipd/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
index dd35b3ee2c5a..2f32c3fceef8 100644
--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -691,7 +691,6 @@ static int tps6598x_probe(struct i2c_client *client)
 		ret = PTR_ERR(tps->port);
 		goto err_role_put;
 	}
-	fwnode_handle_put(fwnode);
 
 	if (status & TPS_STATUS_PLUG_PRESENT) {
 		ret = tps6598x_connect(tps, status);
@@ -710,6 +709,7 @@ static int tps6598x_probe(struct i2c_client *client)
 	}
 
 	i2c_set_clientdata(client, tps);
+	fwnode_handle_put(fwnode);
 
 	return 0;
 
-- 
2.35.1



