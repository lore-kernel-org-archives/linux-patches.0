Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D3B3DD851;
	Mon, 17 Aug 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977311; cv=none; b=sX0ZHZGwQYtZYHt2v/uxnpR6ZTyb8yETIZOkNQsUZluTqJ9G3/RLc381cX/t+OnXcQkI8j9BZhze7ewmDu2hxxNGS6BdTe3xQVnsrIFjSvU3FyGId5cGUm0WqoOQtHddmNNtb3OfbBa0+f/6VPI1bJoIOgAKEFFKTwFerrqNbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977311; c=relaxed/simple;
	bh=xyKOGcPINxXd9vUKvwhZBQINiMnNzENweH9FEypToXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5u5SeN0DN2RXsZhlD9ODdcCDly2s9waUKwcD7ovgYdbaYrzxJRoAaXHCVd3NDGfoRKMkdHFlHOIN6tSy9n641ZrG7o558a2Y/I//1jy3UBh8guAU3HFDaf6hIrqSFxlYjhAAXuIkHyfaySVi37v7iKYFVkUTN4KfsHld+FmhmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5U4MwIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5U4MwIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6108D1F000E9;
	Mon, 17 Aug 2026 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977309;
	bh=x/pB7KT18E+6/1cJF/D+/VYc+3SXHBznsC/Sv0YgS30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5U4MwIp/N6cp0jPVCfTsBoWBNoTipPMKhOMyg6O5691DQDj5D4hyfRIuvq9hUrdo
	 4PbAn6GS589ivquSHaUb4VHV0OT5N/xxxC4bO+zOM9KT1foeZVYSQpHhGw4pn56sAB
	 QmxBsJIFNAl2+YoslH50b49RZAfoXTEobgb73NUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/456] can: isotp: check register_netdevice_notifier() error in module init
Date: Mon, 17 Aug 2026 15:31:16 +0200
Message-ID: <20260817132551.093758849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index de6992580c38c..34939744dd412 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1827,13 +1827,18 @@ static __init int isotp_module_init(void)
 
 	pr_info("can: isotp protocol\n");
 
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



