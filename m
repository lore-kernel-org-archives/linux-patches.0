Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37508434E5D;
	Tue, 21 Jul 2026 20:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665460; cv=none; b=tJVFN3NeULMamWnBE3geI13FtDBVzGJhGMuHYS6lilrXJAn9eYJadm1MBzlxI0YspUJCECg6BzYsHO7qvvT76FQ3nq14u0eOUX6TuWWiHJUBwsrI4nIYFNhmCx7PM65WfWe+fjegP/zGypc+FhikqGTr1p5/0etud+f+HWrjFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665460; c=relaxed/simple;
	bh=FFMeKgFTZ297sgJiGFGVCoGNZ+1zC2Wd4k/At+u+qrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4bMrCWSEQOSLY+v4b2E+8ITLJzLe3Hsm6XWWqW/ckTNHciI5KRTYkWFfmU7QqjsPALYOHV1EkCgbQ5KJW2G54MuNFjPgclxHBjrWsT5d3UQqOFVoLuB2sEVqDSg+wQwXl3Qq2Z61pkITjxJhlYi5qeOHx9Bz6hoLWIEo6nZYVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Hr4U5Xm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Hr4U5Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2621F000E9;
	Tue, 21 Jul 2026 20:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665459;
	bh=gkbut8xx7NLKR8jAixdDwdSVjwvJqxF11dKk58KIslI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Hr4U5Xm52V5I03ouw79CvdiNc9PuCJKPR9qDYng/JWJc1CcEZ7xIl0I/xshZu/Uf
	 eojKqqDri4w4D/3fFR6aOGPkpPk/4wa9VTjfw4et6lYm0qWgFCek5qWGBVfAwyH+im
	 PLV0K7xYQyvsl0pgahr7O5kYACWa8LN1HbyIX4A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0311/1266] Input: mms114 - fix touch indexing for MMS134S and MMS136
Date: Tue, 21 Jul 2026 17:12:28 +0200
Message-ID: <20260721152448.792651843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a6ac4e24c1a8a533bb61035184fdcc7eede4cc8d upstream.

The MMS134S and MMS136 touch controllers have an event size of 6 bytes
rather than 8 bytes. When __mms114_read_reg() reads the touch data
packet from the device into the touch buffer, the events are packed
tightly at 6-byte intervals. However, the driver iterates through the
events using standard C array indexing (touch[index]), where each
element is sizeof(struct mms114_touch) (8 bytes) apart. As a result, any
touch events beyond the first one are read from incorrect offsets and
parsed improperly.

Fix this by explicitly calculating the byte offset for each touch event
based on the device's specific event size.

Fixes: 53fefdd1d3a3 ("Input: mms114 - support MMS136")
Fixes: ab108678195f ("Input: mms114 - support MMS134S")
Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Reviewed-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260616050912.1531241-1-dmitry.torokhov@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/mms114.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -218,7 +218,9 @@ static irqreturn_t mms114_interrupt(int
 	struct i2c_client *client = data->client;
 	struct input_dev *input_dev = data->input_dev;
 	struct mms114_touch touch[MMS114_MAX_TOUCH];
+	struct mms114_touch *t;
 	int packet_size;
+	int event_size;
 	int touch_size;
 	int index;
 	int error;
@@ -236,9 +238,11 @@ static irqreturn_t mms114_interrupt(int
 
 	/* MMS136 has slightly different event size */
 	if (data->type == TYPE_MMS134S || data->type == TYPE_MMS136)
-		touch_size = packet_size / MMS136_EVENT_SIZE;
+		event_size = MMS136_EVENT_SIZE;
 	else
-		touch_size = packet_size / MMS114_EVENT_SIZE;
+		event_size = MMS114_EVENT_SIZE;
+
+	touch_size = packet_size / event_size;
 
 	error = __mms114_read_reg(data, MMS114_INFORMATION, packet_size,
 			(u8 *)touch);
@@ -246,18 +250,20 @@ static irqreturn_t mms114_interrupt(int
 		goto out;
 
 	for (index = 0; index < touch_size; index++) {
-		switch (touch[index].type) {
+		t = (struct mms114_touch *)((u8 *)touch + index * event_size);
+
+		switch (t->type) {
 		case MMS114_TYPE_TOUCHSCREEN:
-			mms114_process_mt(data, touch + index);
+			mms114_process_mt(data, t);
 			break;
 
 		case MMS114_TYPE_TOUCHKEY:
-			mms114_process_touchkey(data, touch + index);
+			mms114_process_touchkey(data, t);
 			break;
 
 		default:
 			dev_err(&client->dev, "Wrong touch type (%d)\n",
-				touch[index].type);
+				t->type);
 			break;
 		}
 	}


