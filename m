Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98EF15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6D6C433D6;
	Tue,  8 Nov 2022 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916202;
	bh=XyzBNQ8BORZFEpR78LHsZh6iOCwV2oBn3jc3KRX3jeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hramJsevwdIhqo8ZSaf6yv6oHpKolw/bm6m+SmJFMto9iXyvF22b/6qUQx31AEnE/
	 L3tKdl+9u2iVaaAR2h5xwh8LyCH7pW652KUXwRG2cIyyZT8BpNRoXDja6Qr88BH08G
	 nASOXr0eGz34nE2NiNFog106Kbsc9vafu+eNCd+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Hilber <peter.hilber@opensynergy.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/144] firmware: arm_scmi: Fix devres allocation device in virtio transport
Date: Tue,  8 Nov 2022 14:39:30 +0100
Message-Id: <20221108133349.188948701@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

[ Upstream commit 5ffc1c4cb896f8d2cf10309422da3633a616d60f ]

SCMI virtio transport device managed allocations must use the main
platform device in devres operations instead of the channel devices.

Cc: Peter Hilber <peter.hilber@opensynergy.com>
Fixes: 46abe13b5e3d ("firmware: arm_scmi: Add virtio transport")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-5-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/virtio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index 87039c5c03fd..0c351eeee746 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -247,19 +247,19 @@ static int virtio_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	for (i = 0; i < vioch->max_msg; i++) {
 		struct scmi_vio_msg *msg;
 
-		msg = devm_kzalloc(cinfo->dev, sizeof(*msg), GFP_KERNEL);
+		msg = devm_kzalloc(dev, sizeof(*msg), GFP_KERNEL);
 		if (!msg)
 			return -ENOMEM;
 
 		if (tx) {
-			msg->request = devm_kzalloc(cinfo->dev,
+			msg->request = devm_kzalloc(dev,
 						    VIRTIO_SCMI_MAX_PDU_SIZE,
 						    GFP_KERNEL);
 			if (!msg->request)
 				return -ENOMEM;
 		}
 
-		msg->input = devm_kzalloc(cinfo->dev, VIRTIO_SCMI_MAX_PDU_SIZE,
+		msg->input = devm_kzalloc(dev, VIRTIO_SCMI_MAX_PDU_SIZE,
 					  GFP_KERNEL);
 		if (!msg->input)
 			return -ENOMEM;
-- 
2.35.1



