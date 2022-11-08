Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF19115CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F196C433D6;
	Tue,  8 Nov 2022 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915724;
	bh=AxaDGZjoFJscRhlOZ1+3WLskyhlnwTzHgCQREMrk2lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1HLslTvMbeH2w9/emdmedsJxzxtNhvWnzaLpQlxGZWd2NlE7FafW9uqPSMBInzzd
	 SQjxixE7QUjHheIGX2iPjS+NHPJYgrzmj61fEavPZMq8JyFhI5R0GVoTfXY6k5TwgK
	 7nmFjY2mgqvs3HSKAB+hYKCrBljb3pinBUb1tJms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/118] firmware: arm_scmi: Make Rx chan_setup fail on memory errors
Date: Tue,  8 Nov 2022 14:39:11 +0100
Message-Id: <20221108133343.916900866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit be9ba1f7f9e0b565b19f4294f5871da9d654bc6d ]

SCMI Rx channels are optional and they can fail to be setup when not
present but anyway channels setup routines must bail-out on memory errors.

Make channels setup, and related probing, fail when memory errors are
reported on Rx channels.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 4bc974ead02b..8d24082848a8 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -711,8 +711,12 @@ scmi_txrx_setup(struct scmi_info *info, struct device *dev, int prot_id)
 {
 	int ret = scmi_chan_setup(info, dev, prot_id, true);
 
-	if (!ret) /* Rx is optional, hence no error check */
-		scmi_chan_setup(info, dev, prot_id, false);
+	if (!ret) {
+		/* Rx is optional, report only memory errors */
+		ret = scmi_chan_setup(info, dev, prot_id, false);
+		if (ret && ret != -ENOMEM)
+			ret = 0;
+	}
 
 	return ret;
 }
-- 
2.35.1



