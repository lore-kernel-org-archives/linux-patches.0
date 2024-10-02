Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4521D04A8;
	Wed,  2 Oct 2024 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879676; cv=none; b=sZI2GHXHbY2rA6odoV4HKb2ldv3c450X6PlQCRZ/vzzKTnUBaNT7WWhqJu3ZvHktX8yTiv/aM3objpv7Fz+oNgIrlVbrIhRqqs/03K61+TahT5YfpaCNURfUjzTXjOMSnXQYEcxOXi6cBp/4I3XFGqUMmvAueSHgcEGGIjKAhpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879676; c=relaxed/simple;
	bh=kjTYPSzfDU8SeZ4Zbe6NwN0VvMSrHkwL65EwshlrVf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4qkHJ7VjdM0UZBGU3FqLg6rRlVxUP//g6pxGgKlT5ZcBm+/vLQjwq4n3XL0KSrRpZEa6jj1kedEavGIvKXmKz7xfI75Hitz1q8eObYct1lt7tn0RZ3/mX1TeWw6M8D/mjTbIdm3HG5hO9zFz6RhSkx3fjeImO3JmU2hmzOUABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXCS7Z0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXCS7Z0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE23C4CEC2;
	Wed,  2 Oct 2024 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879676;
	bh=kjTYPSzfDU8SeZ4Zbe6NwN0VvMSrHkwL65EwshlrVf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXCS7Z0hBKmOiwGSRVayOEHVw67Nx1m2YhV8Y5m0VWYL8sOQKwrqAt8/prp7cxGK5
	 CIu5sRWensqLKFB/tW6pKQtNBouClVHGnw/aTIhGQeB0C6yH0NX9tYRuVbEJyy+76t
	 6LwjjcQ4er8y4q/27wulxPKSVHCz2jYnC5IU6AOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Joshua Dickens <joshua.dickens@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/538] HID: wacom: Do not warn about dropped packets for first packet
Date: Wed,  2 Oct 2024 14:56:48 +0200
Message-ID: <20241002125758.924480356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Jason Gerecke <jason.gerecke@wacom.com>

[ Upstream commit 84aecf2d251a3359bc78b7c8e58f54b9fc966e89 ]

The driver currently assumes that the first sequence number it will see
is going to be 0. This is not a realiable assumption and can break if,
for example, the tablet has already been running for some time prior to
the kernel driver connecting to the device. This commit initializes the
expected sequence number to -1 and will only print the "Dropped" warning
the it has been updated to a non-negative value.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 6 +++++-
 drivers/hid/wacom_wac.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index c3c576641a38e..18b5cd0234d21 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2368,6 +2368,9 @@ static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
 		wacom_map_usage(input, usage, field, EV_KEY, BTN_STYLUS3, 0);
 		features->quirks &= ~WACOM_QUIRK_PEN_BUTTON3;
 		break;
+	case WACOM_HID_WD_SEQUENCENUMBER:
+		wacom_wac->hid_data.sequence_number = -1;
+		break;
 	}
 }
 
@@ -2492,7 +2495,8 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		wacom_wac->hid_data.barrelswitch3 = value;
 		return;
 	case WACOM_HID_WD_SEQUENCENUMBER:
-		if (wacom_wac->hid_data.sequence_number != value) {
+		if (wacom_wac->hid_data.sequence_number != value &&
+		    wacom_wac->hid_data.sequence_number >= 0) {
 			int sequence_size = field->logical_maximum - field->logical_minimum + 1;
 			int drop_count = (value - wacom_wac->hid_data.sequence_number) % sequence_size;
 			hid_warn(hdev, "Dropped %d packets", drop_count);
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 57e185f18d53d..61073fe81ead2 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -324,7 +324,7 @@ struct hid_data {
 	int bat_connected;
 	int ps_connected;
 	bool pad_input_event_flag;
-	unsigned short sequence_number;
+	int sequence_number;
 	ktime_t time_delayed;
 };
 
-- 
2.43.0



