Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB425C6EE;
	Thu, 20 Aug 2026 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243324; cv=none; b=WRxDyRLWzFkHweTsaP3W/BSd3/u1ZVLhoG8NdNOulh9UvrUbjrYiRDaFgdKxb2ITMfeWbxJ5yZWYq5VaTinvf3lgoJ9HqbpFv1kwQTcGDrlo+TM/gjfQFyW8LU52C2LdWfx4rzhA5M82t9AvmEbLIyHKjMlM19VHkAZz8Hsbf/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243324; c=relaxed/simple;
	bh=FyPWPL/dH9qVHbJge+adtT6Gh3sSKTLAila6cI/EcdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQIfUcPfVskjq4PUiOf7EH/RQyDov/0dzWXnNLUm5s/c+2UKjY5rmtYk/ev64o9x7OBuO/t2jctPX0Q3lWBVAP+6n5qdk97wBMr8lGF/eklVq7FgeTLOK1uXhOZxuzTqu0II5+K9o3MdjsHP63i2RQoXllcuLesovRnf1y2JaC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JW7RVuL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JW7RVuL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846441F000E9;
	Thu, 20 Aug 2026 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243323;
	bh=4GjWMqTw5+7kixSNySpDXlnt9UW11z3YsVgKU2SjdMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JW7RVuL+yJ4T+h9QDGAFDK1gBVtbL4EjYSUsDjWeX0P7awl2MVUHywO5GK6YJLAs+
	 JSQUvzHcVzL4RzUd/1f3A39Icvoq83BRmRoxxM8RZ7r8SqRLIM6Lne7H9aOJGC6IIX
	 nySomMSA/hqbN+AiwKS6XxbFs5eWI/a6x1LOWLtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/272] Input: mms114 - reject an oversized device packet size
Date: Thu, 20 Aug 2026 16:53:59 +0200
Message-ID: <20260820145232.943064483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 66725039f7090afe14c31bd259e2059a68f04023 ]

mms114_interrupt() reads a packet of touch data from the device into a
fixed-size on-stack buffer

	struct mms114_touch touch[MMS114_MAX_TOUCH];

which holds MMS114_MAX_TOUCH (10) events of MMS114_EVENT_SIZE (8) bytes,
i.e. 80 bytes. The length of the I2C read into it is taken verbatim from
the device:

	packet_size = mms114_read_reg(data, MMS114_PACKET_SIZE);
	if (packet_size <= 0)
		goto out;
	...
	error = __mms114_read_reg(data, MMS114_INFORMATION, packet_size,
			(u8 *)touch);

packet_size is a single device register byte (0x0F) and the only check
is the lower bound packet_size <= 0; it is never bounded against the
size of touch[]. A malfunctioning, malicious or counterfeit controller
(or an attacker tampering with the I2C bus) can report a packet_size of
up to 255, so __mms114_read_reg() writes up to 175 bytes past the end of
touch[] on the IRQ-thread stack: a stack out-of-bounds write that can
overwrite the stack canary, saved registers and the return address.

A well-formed device never reports more than the buffer holds, so reject
an oversized packet and drop the report, consistent with the handler's
other error paths, rather than reading past the buffer.

Fixes: 07b8481d4aff ("Input: add MELFAS mms114 touchscreen driver")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260612-b4-disp-dc4b8dc4-v1-1-d7cb0a828d92@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ changed `&client->dev` to `&data->client->dev` since 6.1's interrupt handler lacks the `client` local variable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/mms114.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -214,6 +214,12 @@ static irqreturn_t mms114_interrupt(int
 	if (packet_size <= 0)
 		goto out;
 
+	if (packet_size > sizeof(touch)) {
+		dev_err(&data->client->dev, "Invalid packet size %d (max %zu)\n",
+			packet_size, sizeof(touch));
+		goto out;
+	}
+
 	/* MMS136 has slightly different event size */
 	if (data->type == TYPE_MMS134S || data->type == TYPE_MMS136)
 		event_size = MMS136_EVENT_SIZE;


