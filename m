Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DD52579
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FE0C4339B;
	Tue, 18 Apr 2023 12:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821571;
	bh=sO7eV/elVhd+54a3tOl/0hB2MklgZXcC36w7daWercM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukrY+wNiHvrADpdZmSIMwGspC0kHJAYGFUDg0kk05U9lVJq9Y30EOAVW/pfmzjVDv
	 4RxC4JXHZkSkTjwBmOcrvCu0XhXVQpnlxj08xRXw2pTsbPicZi/2JMmekVtgQdO41l
	 fjLy51KiThyFmb922FUUwzymXKS+uBAnVmOnWsqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/91] counter: 104-quad-8: Fix Synapse action reported for Index signals
Date: Tue, 18 Apr 2023 14:21:56 +0200
Message-Id: <20230418120307.405045978@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 00f4bc5184c19cb33f468f1ea409d70d19f8f502 ]

Signal 16 and higher represent the device's Index lines. The
priv->preset_enable array holds the device configuration for these Index
lines. The preset_enable configuration is active low on the device, so
invert the conditional check in quad8_action_read() to properly handle
the logical state of preset_enable.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230316203426.224745-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index c587f295d720e..e00cf156c6e9a 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -327,7 +327,7 @@ static int quad8_action_read(struct counter_device *counter,
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
+		if (!priv->preset_enable[count->id])
 			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
 			*action = COUNTER_SYNAPSE_ACTION_NONE;
-- 
2.39.2



