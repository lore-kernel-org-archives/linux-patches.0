Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483D844062A;
	Thu, 20 Aug 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248074; cv=none; b=TkWpXEwuFtmwosFr2fx2ihao7NU+EL61IUyuYUzo+0nRWq5eNTpjMTrVJ6n5uBLycgAy6zX/Bj1OmFEjFTEjPAkEWXzt08N81wh6UTqxRHXka7ggB4odMBNDe1higoktl1DtMA+hPwjw46Sp4t0p5v9RztA7ArPqIP5HvPBndM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248074; c=relaxed/simple;
	bh=WmUlQIDo+0PBrDsv+Qx3LkxhJDdQkS4wt+JwlKSZGwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PySMhTY/gxLwfkLUjNOJCkwR233Clv3BFjNyAbPpPxJvfGoxDDgIUQbArJJqV11qZRxSFYaN3y8FxvgvlNP1J9kqBr4HXz0jVK7ja/RRH4r665yIv7raSQAvLQor3+U2lraMIuCZrDVixkL+gY70kiqiYcAl0Co06qcQuW5lHck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Pwf2PZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Pwf2PZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598D61F000E9;
	Thu, 20 Aug 2026 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248072;
	bh=gl/d97zXJaTyLQqHGF/krS3Qn7eZFlJNHQW29CwjUYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Pwf2PZhq2LY4RZsePowYiN1fhhQ712hTZPUIbaj1nflwXwj9Qfh6qG/AVdkCJdIM
	 iird1uTMeA4ZOs68BV08pU9LnwYgk+E7aJF8/tjPQvM+1PZN++3wKHd9Fh7VZjeaNM
	 bZuhFYBMlZB3JVI2LBPSXCjgcPItrdIR0mfOGvJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/303] Input: mms114 - fix touch indexing for MMS134S and MMS136
Date: Thu, 20 Aug 2026 16:53:20 +0200
Message-ID: <20260820145255.088369901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit a6ac4e24c1a8a533bb61035184fdcc7eede4cc8d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/mms114.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -196,7 +196,9 @@ static irqreturn_t mms114_interrupt(int
 	struct mms114_data *data = dev_id;
 	struct input_dev *input_dev = data->input_dev;
 	struct mms114_touch touch[MMS114_MAX_TOUCH];
+	struct mms114_touch *t;
 	int packet_size;
+	int event_size;
 	int touch_size;
 	int index;
 	int error;
@@ -214,17 +216,22 @@ static irqreturn_t mms114_interrupt(int
 
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
 	if (error < 0)
 		goto out;
 
-	for (index = 0; index < touch_size; index++)
-		mms114_process_mt(data, touch + index);
+	for (index = 0; index < touch_size; index++) {
+		t = (struct mms114_touch *)((u8 *)touch + index * event_size);
+
+		mms114_process_mt(data, t);
+	}
 
 	input_mt_report_pointer_emulation(data->input_dev, true);
 	input_sync(data->input_dev);


