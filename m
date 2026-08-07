Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17EC4749FA;
	Fri,  7 Aug 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115058; cv=none; b=udaaleklrjqNpSOB3+1q+VwfxMsYjcgWoC+ZiUpoWbcwpvI+mZSRWkmxhz5ODhMGo0r4iCu61y/fPIiAVSeV4g2uukEak1WoCie9KsLSL4mSz9rcBG0m25yHHionpSmT1nuUyYIUOG00Hd36IfrgPRR5cM3GFY35P0Tn5fxiMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115058; c=relaxed/simple;
	bh=O1JiNMHamZk5iZvH5E4CI/PcATD/xHlBx7w6N4ok0TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+SjBVeMUKjo7BhYkrbWXVWes1yN8HXbgrlkgopJPq/p3lnVuwcXSCsFApjMKdRArB8Kf8eekokS33WqZPQmMJt2A4COC2k0U9+j+P1pBY6i0I7wXxnzaU/uTqjVjr5Se1vEwF2R5B7f7j+jQ7ZQN8kh+OkH5Twq/p3QwtzckOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMoBGUG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMoBGUG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F881F000E9;
	Fri,  7 Aug 2026 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115045;
	bh=FghwCG+8JpTICx4YlJJamoZwLweM9rWh833vXxnA//g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMoBGUG6sHAT0wrJU4MWsCR4XXEGt9Sgmr+dkQSy6IXB/wtfB6cenXP5vQ0FTV/6I
	 pj762prWxxTy63Y1eyeRUFGfSbhcCMEHrn1eujKCkTYiJTPxfZooanhPsfkNo+P0RZ
	 ONr9nUXSTgymDPuxUoq4co5WHTEanCWrb73Y9Jf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/396] can: isotp: check register_netdevice_notifier() error in module init
Date: Fri,  7 Aug 2026 16:34:56 +0200
Message-ID: <20260807143427.240140413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c21d816a52747..95e14631a1eb9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1888,13 +1888,18 @@ static __init int isotp_module_init(void)
 
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



