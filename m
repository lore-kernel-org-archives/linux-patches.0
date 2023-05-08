Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A701168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E910C433D2;
	Mon,  8 May 2023 10:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541693;
	bh=MFU8yBvbA/7bEFFNgOb47Y5oJ2wX1QOvS35//bwn3ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2LcjoU/TEkwVE+XjocQFLaGKFsOwL2bdAO+LhHrum2KWnWiG64AOBvtenT7D665d
	 yaVJRwxc+DgCDqDQj7qGAZ9qG9TqHkZYD7UgKxFpXL0jzPO33Gqz+6jc/4tLAL528K
	 Zv26+ER666BV5J+N3GfwpI0YcPjbnodyR80p3tDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 196/663] firmware: arm_scmi: Fix xfers allocation on Rx channel
Date: Mon,  8 May 2023 11:40:22 +0200
Message-Id: <20230508094434.759191810@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit b2ccba9e8cdc6fb3985cc227844e7c6af309ffb1 ]

Two distinct pools of xfer descriptors are allocated at initialization
time: one (Tx) used to provide xfers to track commands and their replies
(or delayed replies) and another (Rx) to pick xfers from to be used for
processing notifications.

Such pools, though, are allocated globally to be used by the whole SCMI
instance, they are not allocated per-channel and as such the allocation of
notifications xfers cannot be simply skipped if no Rx channel was found for
the base protocol common channel, because there could be defined more
optional per-protocol dedicated channels that instead support Rx channels.

Change the conditional check to skip allocation for the notification pool
only if no Rx channel has been detected on any per-channel protocol at all.

Fixes: 4ebd8f6dea81 ("firmware: arm_scmi: Add receive buffer support for notifications")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20230326203449.3492948-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index ffdad59ec81fc..fe06dc1936896 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1981,7 +1981,7 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
 		return ret;
 
 	ret = __scmi_xfer_info_init(sinfo, &sinfo->tx_minfo);
-	if (!ret && idr_find(&sinfo->rx_idr, SCMI_PROTOCOL_BASE))
+	if (!ret && !idr_is_empty(&sinfo->rx_idr))
 		ret = __scmi_xfer_info_init(sinfo, &sinfo->rx_minfo);
 
 	return ret;
-- 
2.39.2



