Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51429D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE58C433EF;
	Mon, 12 Jun 2023 10:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566893;
	bh=q7AZgL1Q2wUJlbLmBb90imZYwU03OA8U9REGe/qT1fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jqm39DAW29v0J//0cVSeSthpUHGIT8NGWnT3tm1uAwaSyTfr2MZkxpX4706ituo0U
	 RKICWCAtkw4eevUcpk9g+MLznNyHZjdlS/nAO19cgc/JrX3hEdK6/f/r7E6yoJF1ih
	 S1ztn+ywtemJthfwVCIP3r5AvX3LOwVdlUvTsd+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
	Cameron Gutman <aicommander@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.3 071/160] Input: xpad - delete a Razer DeathAdder mouse VID/PID entry
Date: Mon, 12 Jun 2023 12:26:43 +0200
Message-ID: <20230612101718.259864658@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit feee70f4568650cf44c573488798ffc0a2faeea3 upstream.

While doing my research to improve the xpad device names I noticed
that the 1532:0037 VID/PID seems to be used by the DeathAdder 2013,
so that Razer Sabertooth instance looked wrong and very suspect to
me. I didn't see any mention in the official drivers, either.

After doing more research, it turns out that the xpad list
is used by many other projects (like Steam) as-is [1], this
issue was reported [2] and Valve/Sam Lantinga fixed it [3]:

[1]: https://github.com/libsdl-org/SDL/blob/dcc5eef0e2395854b254ea2873a4899edab347c6/src/joystick/controller_type.h#L251
[2]: https://steamcommunity.com/app/353380/discussions/0/1743392486228754770/
[3]: https://hg.libsdl.org/SDL/rev/29809f6f0271

(With multiple Internet users reporting similar issues, not linked here)

After not being able to find the correct VID/PID combination anywhere
on the Internet and not receiving any reply from Razer support I did
some additional detective work, it seems like it presents itself as
"Razer Sabertooth Gaming Controller (XBOX360)", code 1689:FE00.

Leaving us with this:
 * Razer Sabertooth (1689:fe00)
 * Razer Sabertooth Elite (24c6:5d04)
 * Razer DeathAdder 2013 (1532:0037) [note: not a gamepad]

So, to sum things up; remove this conflicting/duplicate entry:

{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },

As the real/correct one is already present there, even if
the Internet as a whole insists on presenting it as the
Razer Sabertooth Elite, which (by all accounts) is not:

{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },

Actual change in SDL2 referencing this kernel issue:
https://github.com/libsdl-org/SDL/commit/e5e54169754ca5d3e86339d968b20126d9da0a15

For more information of the device, take a look here:
https://github.com/xboxdrv/xboxdrv/pull/59

You can see a lsusb dump here: https://github.com/xboxdrv/xboxdrv/files/76581/Qa6dBcrv.txt

Fixes: f554f619b70 ("Input: xpad - sync device IDs with xboxdrv")
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Reviewed-by: Cameron Gutman <aicommander@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/5c12dbdb-5774-fc68-5c58-ca596383663e@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -282,7 +282,6 @@ static const struct xpad_device {
 	{ 0x1430, 0xf801, "RedOctane Controller", 0, XTYPE_XBOX360 },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
-	{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },


