Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D775FF16;
	Tue, 13 Feb 2024 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845937; cv=none; b=Gvvux5AsFaWIGqDIwd02BulMIlcuokXdEIosREsbhdFc18DuI9yQ3JvNftLqdY9g5Z6Jx4po34RBtkYMS9K1Xtu+My7fkskN6LeQ2orgAEAgwLCM4iPO36g/wPNAoegqImklj7Ki8UHVKQ1S34cAW+uvpR62h4FxwqUTZls+/8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845937; c=relaxed/simple;
	bh=ShjExyYhQoHxXEq4bLezq7g4PjJAE/Fo/o6xTr4Cd5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZEOCzsE5tck9feGeukGvGJ173J2u0+tRgXwDo86k1RrJ/1JWyEdv7iEt4PxsQLYJYm4PY8vsTGb/Oj6jCkktJQwnlodnJHoYV0b5CztTwXmr8+oS/7Zj3G3Ue0+8KYdvsrOxYRk03yGrZ4E75YzN/4bkGHL9wxL/x/MUq7FXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0k3IOWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0k3IOWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149CEC433F1;
	Tue, 13 Feb 2024 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845937;
	bh=ShjExyYhQoHxXEq4bLezq7g4PjJAE/Fo/o6xTr4Cd5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0k3IOWJ3qwjJGAevO26lGI34Jev9600G1D0uS6RKChLvO7IWrZJDYCHyU7OXLxRU
	 8D0oLwfKTJ1OW0/pDjxRGoNPEtrY1TY9WDbxnQqQz9nSCjpXF18fwvaxEsNfrUaV2Z
	 wlcG0v4spJLyE5MMSLcEZk9ci9muD0AYeywRAGUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.7 102/124] Input: i8042 - fix strange behavior of touchpad on Clevo NS70PU
Date: Tue, 13 Feb 2024 18:22:04 +0100
Message-ID: <20240213171856.709267937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit a60e6c3918d20848906ffcdfcf72ca6a8cfbcf2e upstream.

When closing the laptop lid with an external screen connected, the mouse
pointer has a constant movement to the lower right corner. Opening the
lid again stops this movement, but after that the touchpad does no longer
register clicks.

The touchpad is connected both via i2c-hid and PS/2, the predecessor of
this device (NS70MU) has the same layout in this regard and also strange
behaviour caused by the psmouse and the i2c-hid driver fighting over
touchpad control. This fix is reusing the same workaround by just
disabling the PS/2 aux port, that is only used by the touchpad, to give the
i2c-hid driver the lone control over the touchpad.

v2: Rebased on current master

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231205163602.16106-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1210,6 +1210,12 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NS5x_7xPU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NJ50_70CU"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


