Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102E374E23;
	Tue, 23 Jan 2024 02:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975479; cv=none; b=n8nXZdIuZlO/E4nBTjKPwBXdGXl4P5gfWCLutS0hIEmZxDcf9rpdJnKxX4NjXglQBk8TU60/8wSlaxMFESDYWHc1Cwqp1RfDdnE9hRAcgK+vOwLpgui+rN7IL1SDiS13Cpv6KEx1rlhuI/CXxIpG4Jm/hzd7F3MHZ6zLIdslGWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975479; c=relaxed/simple;
	bh=nTvfrZNdfWoacewmxcR2NdSRO/+1G5yrQWJ/Sa6lGtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMZfig6x80Ph54zsy928Ni+C+3FCPVrpOnqilVBZhOnyVJ4hgE0UWZtRM5WGLKZlIy6PMSHxRmO4cfEjV1ZLXSmFgOhB+VK8SNzfsCpjA510d1wqR9QQcT9fbSMfxiZ+awI20u8aHkeC6AqhDYO1LD4KjX+Q+KPkJGpWSrbgx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sAazn7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sAazn7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F68C433F1;
	Tue, 23 Jan 2024 02:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975478;
	bh=nTvfrZNdfWoacewmxcR2NdSRO/+1G5yrQWJ/Sa6lGtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sAazn7svEds5VtfKrNsRAxP/JLQVwm23LHVTox3xr3qdcD8mAIAsf5EhT8ps7IT2
	 JYqun+sdG7EdwDfIDzg0Pkq3cGoiO95tVnTXL5MtqUk9RX+oNJ2X+AqX7SSHquFxZK
	 I6CKz1ItJfaZBJsJcA14IqoEP4plnTXQuGSwzyYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yauhen Kharuzhy <jekhor@gmail.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 433/583] HID: sensor-hub: Enable hid core report processing for all devices
Date: Mon, 22 Jan 2024 15:58:04 -0800
Message-ID: <20240122235825.232446820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yauhen Kharuzhy <jekhor@gmail.com>

commit 8e2f79f41a5d1b1a4a53ec524eb7609ca89f3c65 upstream.

After the commit 666cf30a589a ("HID: sensor-hub: Allow multi-function
sensor devices") hub devices are claimed by hidraw driver in hid_connect().
This causes stoppping of processing HID reports by hid core due to
optimization.

In such case, the hid-sensor-custom driver cannot match a known custom
sensor in hid_sensor_custom_get_known() because it try to check custom
properties which weren't filled from the report because hid core didn't
parsed it.

As result, custom sensors like hinge angle sensor and LISS sensors
don't work.

Mark the sensor hub devices claimed by some driver to avoid hidraw-related
optimizations.

Fixes: 666cf30a589a ("HID: sensor-hub: Allow multi-function sensor devices")
Cc: stable@vger.kernel.org
Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20231219231503.1506801-1-jekhor@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 2eba152e8b90..26e93a331a51 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -632,7 +632,7 @@ static int sensor_hub_probe(struct hid_device *hdev,
 	}
 	INIT_LIST_HEAD(&hdev->inputs);
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | HID_CONNECT_DRIVER);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		return ret;
-- 
2.43.0



