Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708D231E85C;
	Thu, 16 Jul 2026 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210241; cv=none; b=UEfaQOjxjkdl5kn1DQS5hJ2NmJuD+iCtROou8C1QnGWPfYgc+FCCZxmCAUqbnJ6e8TYESuQonsInoEBQDuW1p76vxJAsxyVVuGt3rLfnv62t0wlvp7cvOp9+FrsDIf5q6XawNRI+jQOg5zKE1aT89wKY7xP4EQMKsgTPYi3Egfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210241; c=relaxed/simple;
	bh=0ReYwNaEXEznxjLZHP+AcJF082ptHzxR9TXw5FZRJPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4NixfcN489xHAyE85dKjdfQnMaSNIW72/19CEO+I6t63JfiIIkypmu6DARXac4sIXUmGivhVO2gjE1oc9fVWc4roE32BuvNiBVKIW3WoT9Na8mP/et2NwJCx6ytjJ/x9tQQFoe4NOqVkvMd17OMQzhG6uC85v4VIdTx2ZqJtJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFbzPVJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFbzPVJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02521F000E9;
	Thu, 16 Jul 2026 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210240;
	bh=PkfavtIUXml3Og6M6cxGXHYMTzTiQT8HKdgVRJu1XTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFbzPVJw27ye8PbXpVe1INIuIGrp5QmQq0knwlzc+wyWS26rxDclhlVRj6kS9wPqZ
	 RcxQ/+CWRHcXhdAWMdEzQJgZfEb9sXU7T0phoa7qUqFwySGfMOcz5J1nH2fUBGB3K+
	 O3xSdwZ1keSBMSLqR9wGVriHgkXqjLzlj+n3D4OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 489/518] Input: mms114 - reject an oversized device packet size
Date: Thu, 16 Jul 2026 15:32:37 +0200
Message-ID: <20260716133058.545527033@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 66725039f7090afe14c31bd259e2059a68f04023 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/mms114.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/touchscreen/mms114.c
+++ b/drivers/input/touchscreen/mms114.c
@@ -228,6 +228,12 @@ static irqreturn_t mms114_interrupt(int
 	if (packet_size <= 0)
 		goto out;
 
+	if (packet_size > sizeof(touch)) {
+		dev_err(&client->dev, "Invalid packet size %d (max %zu)\n",
+			packet_size, sizeof(touch));
+		goto out;
+	}
+
 	/* MMS136 has slightly different event size */
 	if (data->type == TYPE_MMS134S || data->type == TYPE_MMS136)
 		event_size = MMS136_EVENT_SIZE;


