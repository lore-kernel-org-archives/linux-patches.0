Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4CD168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4044C433EF;
	Mon,  8 May 2023 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545745;
	bh=z99qIT2lq0WuKPPyuPN9zdkcIcIZlCenqAxLta/hhSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atUTabFeJUs4H/aGBK/jf+ZwQIceTgRMI1+VAG8Ot7JJtUIRWM1fbwbbIv2AenSvY
	 z9vZcler29PxSqFHqDlp5ChB91MHKkAK2osyjoEoZozOL4jqqF/de+aPHiZUsLNE5c
	 kvX67dLVkESzXGtNyzrNT6iVoRvXaOjdqhPwjeM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Lear <matthew.lear@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/371] media: rc: gpio-ir-recv: Fix support for wake-up
Date: Mon,  8 May 2023 11:45:41 +0200
Message-Id: <20230508094817.607042998@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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
index a56c844d7f816..16795e07dc103 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -107,6 +107,8 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 		rcdev->map_name = RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
+	if (of_property_read_bool(np, "wakeup-source"))
+		device_init_wakeup(dev, true);
 
 	rc = devm_rc_register_device(dev, rcdev);
 	if (rc < 0) {
-- 
2.39.2



