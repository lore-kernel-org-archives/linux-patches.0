Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B75FEEB;
	Tue, 13 Feb 2024 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845184; cv=none; b=Rs906uwMtFjSW4ZTxA3Ye7EMALhhr8Ap+WQmsywA/N3rgg9aYbP4O2TNSCOCDnA11HKyhnhFuQDJ/C103UvBcmZCxnMAgvkQdfkGtzzqwYcAs0xWOVhiSwyQLdEQE/NyOkupnF6Wx525nOXYfhHGHf8ohEAxi+mJdlcM98Wtjh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845184; c=relaxed/simple;
	bh=+czXk+GportjZpLovw40v4C9BVQASOWgnp3cjRymGj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5kyC8+FTF178ARm9Mz4audxR6zRYJDQK9GKAkB8zRmEAGf9StVLNpYITdRhVfp3PBISowfDOyWS4qde1WsLPgI/Ot5LFl/i6q+MlxtqMpmkybVUuQ42d7EPkLvyEqrM+2Wsa834zYejHxBBHJJ5OVT+GPjVPrqKVXXRck4QtvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt3CN4Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt3CN4Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678B5C43399;
	Tue, 13 Feb 2024 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845183;
	bh=+czXk+GportjZpLovw40v4C9BVQASOWgnp3cjRymGj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt3CN4Ez54sGBi9vE4oZT8frz3SOp+WJ+RoJuys1E6znkidN9fw/oakiCMCloeSr9
	 9mb+KEp3+kTEMq6dzPL2MeHcqL395nZqd/W64o7ycdrk9UsawJgZaFSUKloJ78ZC9+
	 wMvqSLTtO9RzANQD0chOLXmq1wKFxvuo/hyLxLvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 56/64] Input: i8042 - fix strange behavior of touchpad on Clevo NS70PU
Date: Tue, 13 Feb 2024 18:21:42 +0100
Message-ID: <20240213171846.494793842@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


