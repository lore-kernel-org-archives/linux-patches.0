Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1AD168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1060EC433D2;
	Mon,  8 May 2023 11:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544105;
	bh=ReMk9k9BAMMiNNvcJsUxr8zjyOSiRzDZGDRXvL53JeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbMKERrSRjVhIWMVbRAF7KUPHPNuoVENIqsQuMdQymu15rI+iKyJ/qHJoaslj7KvP
	 3kbGHRIkW1IOpxqdDy2CDgTM7WruV3+zJ70KkMQmv4ksFWenwyMzdWuf0sgXnMQ+ie
	 6e6K2dCiXaeNR4uj5oH5v7hFkW1TsInthThkzFOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Lear <matthew.lear@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 303/694] media: rc: gpio-ir-recv: Fix support for wake-up
Date: Mon,  8 May 2023 11:42:18 +0200
Message-Id: <20230508094442.117850594@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 9c592f8ab114875fdb3b2040f01818e53de44991 ]

The driver was intended from the start to be a wake-up source for the
system, however due to the absence of a suitable call to
device_set_wakeup_capable(), the device_may_wakeup() call used to decide
whether to enable the GPIO interrupt as a wake-up source would never
happen. Lookup the DT standard "wakeup-source" property and call
device_init_wakeup() to ensure the device is flagged as being wakeup
capable.

Reported-by: Matthew Lear <matthew.lear@broadcom.com>
Fixes: fd0f6851eb46 ("[media] rc: Add support for GPIO based IR Receiver driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/gpio-ir-recv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 8dbe780dae4e7..41ef8cdba28c4 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -103,6 +103,8 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 		rcdev->map_name = RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
+	if (of_property_read_bool(np, "wakeup-source"))
+		device_init_wakeup(dev, true);
 
 	rc = devm_rc_register_device(dev, rcdev);
 	if (rc < 0) {
-- 
2.39.2



