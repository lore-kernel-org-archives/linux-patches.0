Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9137822301;
	Thu, 16 Jul 2026 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210233; cv=none; b=rA1LG5RuXH1ClXlCDoMIT8oPkhM+ExlsIF6YSs5EymkiBn0pazmNn4+OqHRaDlJnKBN6Qk917LYJC34RstpWJjxxrj4N8K+6VNuuKsnAFt15k9mLQZ+DdQrPVX5sOlLC4g54haNNZPCAZw6k2oFfOADmlx0Kr7c53wIRchfwg2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210233; c=relaxed/simple;
	bh=jdQO5XHUnnr25m6BDg7fKTRnqaYLUM8hHvPqiMLkllw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0B0vFGbe87WeGDQpbZokqJsJcVa6bRgTBbnD8uYtQFrqyUFsVn9Bo+WA7w9PE86onPKRrAy2XVJ2NoWDYJnViBVco1UDI+gJgAK2ek0h9BncGDDaQqSoLmqPszZyvRHjjMl4fOykCkSI1CJXCB2lKampP3Idar9bTZglUBTZTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFH79R4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFH79R4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D01F000E9;
	Thu, 16 Jul 2026 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210232;
	bh=5Px4so46Ag8Cv7NU2hjDAD11S5rSmgGVu5eb7l/LKu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFH79R4KAShlwtPZFh4B2ryJLBX7IFvM02k51J7FdwICAlLpKXvSVpDdYsKcKo0wb
	 o1dZqnY+Zyy91HqAG3uJ6uvxu0tcosECt/mryq8KHHKrwDFO5h8Cho4UytXTR0fzgO
	 T+f0EI6bwkBvx8l8CfI8SdLJtziOpb6Vgmsf1WcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 486/518] Input: mms114 - fix touch indexing for MMS134S and MMS136
Date: Thu, 16 Jul 2026 15:32:34 +0200
Message-ID: <20260716133058.483302979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -217,7 +217,9 @@ static irqreturn_t mms114_interrupt(int
 	struct mms114_data *data = dev_id;
 	struct i2c_client *client = data->client;
 	struct mms114_touch touch[MMS114_MAX_TOUCH];
+	struct mms114_touch *t;
 	int packet_size;
+	int event_size;
 	int touch_size;
 	int index;
 	int error;
@@ -228,9 +230,11 @@ static irqreturn_t mms114_interrupt(int
 
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
@@ -238,18 +242,20 @@ static irqreturn_t mms114_interrupt(int
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


