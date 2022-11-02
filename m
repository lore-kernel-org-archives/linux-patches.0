Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A457E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71EFC433B5;
	Wed,  2 Nov 2022 03:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359013;
	bh=hkmBHOnMKPue9dNprXXDUtFjn8LIHByL5/yPrjH19d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOIO3+PE4hEC6Y+4xCoQo/j6lOdnj1fcSm7ZshRzYqeckT/n7CbAfgw0LkSGpMKK9
	 Vs1++T1vS63UyU6/HUpYrkTJCpDX6/r5SZls7cWNm50NkNVoSpgXmUZzZnJLXk6IB5
	 tVAJB9ZKk+J+jw3e15VKTD4S8fKhklewsCNNU7c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/91] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
Date: Wed,  2 Nov 2022 03:33:44 +0100
Message-Id: <20221102022056.761160942@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit 3e5b3418827cefb5e1cc658806f02965791b8f07 ]

The commit 1149108e2fbf ("can: mscan: improve clock API use") only
adds put_clock() in mpc5xxx_can_remove() function, forgetting to add
put_clock() in the error handling code.

Fix this bug by adding put_clock() in the error handling code.

Fixes: 1149108e2fbf ("can: mscan: improve clock API use")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/all/20221024133828.35881-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/mscan/mpc5xxx_can.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index e254e04ae257..ef649764f9b4 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -325,14 +325,14 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 					       &mscan_clksrc);
 	if (!priv->can.clock.freq) {
 		dev_err(&ofdev->dev, "couldn't get MSCAN clock properties\n");
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	err = register_mscandev(dev, mscan_clksrc);
 	if (err) {
 		dev_err(&ofdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_free_mscan;
+		goto exit_put_clock;
 	}
 
 	dev_info(&ofdev->dev, "MSCAN at 0x%p, irq %d, clock %d Hz\n",
@@ -340,7 +340,9 @@ static int mpc5xxx_can_probe(struct platform_device *ofdev)
 
 	return 0;
 
-exit_free_mscan:
+exit_put_clock:
+	if (data->put_clock)
+		data->put_clock(ofdev);
 	free_candev(dev);
 exit_dispose_irq:
 	irq_dispose_mapping(irq);
-- 
2.35.1



