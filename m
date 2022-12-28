Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F041863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3BFC433D2;
	Wed, 28 Dec 2022 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242405;
	bh=IqF1bJoKPOlvUlEswp1uQYakd/NZzAqQPxOHZ4bB4bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzjnia/XHMvwDVqwk0EWINVGAYWOX0hve8qmsK6GiPsoGVoJkbQTbVKpwEmY54dKH
	 aGlNvfWI+N5fssA5vrrtBk27af0wo04H3+z+CHvQC5UYs8sZEywH3mdk9tbH7vLpvY
	 COvmWkVuEjM04lrNiJeOLSRa7a8pL96P29wCoYqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0366/1146] HID: i2c: let RMI devices decide what constitutes wakeup event
Date: Wed, 28 Dec 2022 15:31:45 +0100
Message-Id: <20221228144340.107934144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 9984fbf55b9bd998b4ff66395cbb118020c1effa ]

HID-RMI is special in the sense that it does not carry HID events
directly, but rather uses HID protocol as a wrapper/transport for RMI
protocol.  Therefore we should not assume that all data coming from the
device via interrupt is associated with user activity and report wakeup
event indiscriminately, but rather let HID-RMI do that when appropriate.

HID-RMI devices tag responses to the commands issued by the host as
RMI_READ_DATA_REPORT_ID whereas motion and other input events from the
device are tagged as RMI_ATTN_REPORT_ID. Change hid-rmi to report wakeup
events when receiving the latter packets. This allows ChromeOS to
accurately identify wakeup source and make correct decision on the mode
of the resume the system should take ("dark" where the display stays off
vs normal one).

Fixes: d951ae1ce803 ("HID: i2c-hid: Report wakeup events")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c              | 2 ++
 drivers/hid/i2c-hid/i2c-hid-core.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index bb1f423f4ace..84e7ba5314d3 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -326,6 +326,8 @@ static int rmi_input_event(struct hid_device *hdev, u8 *data, int size)
 	if (!(test_bit(RMI_STARTED, &hdata->flags)))
 		return 0;
 
+	pm_wakeup_event(hdev->dev.parent, 0);
+
 	local_irq_save(flags);
 
 	rmi_set_attn_data(rmi_dev, data[1], &data[2], size - 2);
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 0667b6022c3b..a9428b7f34a4 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -554,7 +554,8 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
 
 	if (test_bit(I2C_HID_STARTED, &ihid->flags)) {
-		pm_wakeup_event(&ihid->client->dev, 0);
+		if (ihid->hid->group != HID_GROUP_RMI)
+			pm_wakeup_event(&ihid->client->dev, 0);
 
 		hid_input_report(ihid->hid, HID_INPUT_REPORT,
 				ihid->inbuf + sizeof(__le16),
-- 
2.35.1



