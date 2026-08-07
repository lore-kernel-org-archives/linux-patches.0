Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503C2386554;
	Fri,  7 Aug 2026 14:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114022; cv=none; b=NULvZU75GFIxF/c8caLw4++PznRoqP0S+XJSeBKfPUfKYNrF0x0l8e3PGJRZzX6XjENkLnCePXyoxFJ5VAGxbCS07/n0uGRSnYTIpDdjTHSZSa8urfqxN0JhaKcr9qgK+0WE+I2I4Nhemww1LydZM0dCaTu/2TFo0HPB4cbz0CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114022; c=relaxed/simple;
	bh=O4CfcBs3RdH7nqLDZ/WbHFjwZ3/xB5BFcSTxiktvwjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1dip1H9HCETODh3zFdbkTVMCMO3rpi58mSbK32lTU5ZmaAtLVVEoZyniDAvexeRlAb4V2FTWAy2SB1+575W35GSR7nK2vhauSZt0z0eQpGjrgZOhlxMuTXHp1rf98WD1Wy80Ir0sK6ile+VuAT/+OFtYJr74EwVImyIfbsT/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9rHdx3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9rHdx3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596AA1F000E9;
	Fri,  7 Aug 2026 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114019;
	bh=OMHgJdZhnU/Qmzjj1WW8EF809z9L9BHXFka7JYcMECI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9rHdx3YV6qnr4BGALMlvGTADr0dUSU8rnPCRvxdDy0Y4bhj5xWUdoG5hTELk7BsT
	 9wpHg2ORBQ3S5+JzY2aBN9jJIokllXJK1qc8BpxOSFuN/ZR34WJdLSpVSGcJgmUrXK
	 b3q/9fpMF5V6CS0FwSZZVlZu/uFaobi8P46P6drI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/337] can: isotp: check register_netdevice_notifier() error in module init
Date: Fri,  7 Aug 2026 16:35:17 +0200
Message-ID: <20260807143421.001775054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit ef09a13c5afac41a3c4b5f22b8572820d9e7518c ]

Register the netdevice notifier before can_proto_register() and check the
return value. If protocol registration fails, unregister the notifier
before returning the error.

Align isotp_module_init() with the reordering already done for raw.c
(commit c28b3bffe49e ("can: raw: process optimization in raw_init()")) and
bcm.c (commit edd1a7e42f1d ("can: bcm: registration process optimization
in bcm_module_init()")).

Fixes: 8d0caedb7596 ("can: bcm/raw/isotp: use per module netdevice notifier")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260729085656.134523-1-heminhong@kylinos.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index b2622c881aa32..7e3d6afbb24f9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1885,13 +1885,18 @@ static __init int isotp_module_init(void)
 
 	pr_info("can: isotp protocol (max_pdu_size %d)\n", max_pdu_size);
 
+	err = register_netdevice_notifier(&canisotp_notifier);
+	if (err)
+		return err;
+
 	err = can_proto_register(&isotp_can_proto);
-	if (err < 0)
+	if (err < 0) {
 		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err));
-	else
-		register_netdevice_notifier(&canisotp_notifier);
+		unregister_netdevice_notifier(&canisotp_notifier);
+		return err;
+	}
 
-	return err;
+	return 0;
 }
 
 static __exit void isotp_module_exit(void)
-- 
2.53.0



