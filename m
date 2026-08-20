Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB535DA68;
	Thu, 20 Aug 2026 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248082; cv=none; b=E9GVwkBIEyqaChE6NzwV+fSZy4IlH1FLje8XLjYEs+28eY4xRJJ3Mol83KrHEENUijtBsES1AYoJoHg/ES7tAp9v2MFGNm/5K4B9MYtk4mBNYS74XTX67TpgFuwT+Ui1QF92vCDjSlZ4U5JwsCCABmKykqO1Wy7kGs2yEIYM1jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248082; c=relaxed/simple;
	bh=QB/PZXahnvaav0c0vvuFI97va9ZwWDn8QjcRjNUDbME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJyPl8JaWEeG84kdGE/UCMQjnD/Cw/ZA2f52xBpusysFh1eySXGRty77a1fCBZQlIEGMuKMuH2mGkL/zfcEkKC7GhEhXM+X635PGec1fAO6fLWWZAZWXcJMEQfwruCIlUW3vwY5lodPqiWufRMlArjB6x14jN7rhDdRxkbhkEhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvGNEw7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvGNEw7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83481F00A3A;
	Thu, 20 Aug 2026 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248081;
	bh=+Lbf71bK34/c7kqJhLQvs2YvjaM9lrYF4cN+iG/+iqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvGNEw7W/J30jUBeLr+cNQGL8avq+V950/eMqZNiJqgyY08eMBdGkz6Vp/G4KACuH
	 SjK4qGpuVfHJJvg96uRRYhquT/bCcKxPHCNF21crNyIs6k70TidpFMhTFwlsxqglSK
	 8z6EC7zsuvQHWaKSRHw577YOan8ttahTfbkjYw2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/303] Input: mms114 - reject an oversized device packet size
Date: Thu, 20 Aug 2026 16:53:21 +0200
Message-ID: <20260820145255.119502771@linuxfoundation.org>
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


