Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133F1EA91
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ABCC433C7;
	Tue, 25 Jul 2023 11:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283525;
	bh=0PoSD9LdhI95KCuh8LLnfDFeoWwftXHZPxUPjoW/vtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq9daTO8ivGWMFCgcLv2IMQltndJ7ZFqbZGpDVl2zGhtAeBfR52lkaRBooshKg6AQ
	 jAaYTyslTlMZSG5fIrRW3cnfPbb2fTz5RnG6KcnGecPW7UnecEq1RElGGqiNWyEduo
	 aLLzu8gcl7lkNpny3VtAH5XfVaYLax7kky9x8cg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 006/509] HID: wacom: Use ktime_t rather than int when dealing with timestamps
Date: Tue, 25 Jul 2023 12:39:05 +0200
Message-ID: <20230725104553.908055576@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 9a6c0e28e215535b2938c61ded54603b4e5814c5 upstream.

Code which interacts with timestamps needs to use the ktime_t type
returned by functions like ktime_get. The int type does not offer
enough space to store these values, and attempting to use it is a
recipe for problems. In this particular case, overflows would occur
when calculating/storing timestamps leading to incorrect values being
reported to userspace. In some cases these bad timestamps cause input
handling in userspace to appear hung.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/901
Fixes: 17d793f3ed53 ("HID: wacom: insert timestamp to packed Bluetooth (BT) events")
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20230608213828.2108-1-jason.gerecke@wacom.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    6 +++---
 drivers/hid/wacom_wac.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1307,7 +1307,7 @@ static void wacom_intuos_pro2_bt_pen(str
 	struct input_dev *pen_input = wacom->pen_input;
 	unsigned char *data = wacom->data;
 	int number_of_valid_frames = 0;
-	int time_interval = 15000000;
+	ktime_t time_interval = 15000000;
 	ktime_t time_packet_received = ktime_get();
 	int i;
 
@@ -1341,7 +1341,7 @@ static void wacom_intuos_pro2_bt_pen(str
 	if (number_of_valid_frames) {
 		if (wacom->hid_data.time_delayed)
 			time_interval = ktime_get() - wacom->hid_data.time_delayed;
-		time_interval /= number_of_valid_frames;
+		time_interval = div_u64(time_interval, number_of_valid_frames);
 		wacom->hid_data.time_delayed = time_packet_received;
 	}
 
@@ -1352,7 +1352,7 @@ static void wacom_intuos_pro2_bt_pen(str
 		bool range = frame[0] & 0x20;
 		bool invert = frame[0] & 0x10;
 		int frames_number_reversed = number_of_valid_frames - i - 1;
-		int event_timestamp = time_packet_received - frames_number_reversed * time_interval;
+		ktime_t event_timestamp = time_packet_received - frames_number_reversed * time_interval;
 
 		if (!valid)
 			continue;
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -320,7 +320,7 @@ struct hid_data {
 	int bat_connected;
 	int ps_connected;
 	bool pad_input_event_flag;
-	int time_delayed;
+	ktime_t time_delayed;
 };
 
 struct wacom_remote_data {


