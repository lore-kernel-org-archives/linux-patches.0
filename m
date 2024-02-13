Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEA5F54E;
	Tue, 13 Feb 2024 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845608; cv=none; b=Uu0kbbsd13Q95V8KHl/eS44Qsn+882bBQtFYO5qel5AkLsQMAq48/ErOmVXbUTLpp+CAdOBTQfGmmuert/IWwSWyEouMgQa640X7UqKYj2NgU5PZ7jqmu47a/5ywNnlHI7I9gYAuXT9taaodIoU3ZEbd+B6GL9aZZX2sgLbfdIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845608; c=relaxed/simple;
	bh=qzp0UQ+sS/sLbd9wsx/BwgqvV3EFixOTnv8O4ao00JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2SfwP8QpzAgu5a2NiggKbDamzw5CHwasI9XeBowoYopBVI83mhBXpbRkEQNNJiY40e/0JFKuB8tx3bTiUBIfyOHSGbPsCKSwXCH+WDmvdmzLAP49Cev+DL3SnZerlDVhPCpFfCQVTCSmEw0Nw02xlq7YB5jdXUESAafSm7/0AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6jsrM2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6jsrM2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F3C433C7;
	Tue, 13 Feb 2024 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845607;
	bh=qzp0UQ+sS/sLbd9wsx/BwgqvV3EFixOTnv8O4ao00JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6jsrM2pYfRQb/RSUxnN6xOODzL2JzH6BWxvKZIEEtLuur4IWUZhd3o9IxxwcAatH
	 xduU81hgxzkwFoHyXhSWfI1XBuywLGr6xbdHsbg9NVqbggqWIqgoDQI18NHeey415R
	 mEgYJK5Hn+Qmbi6iHaQjpoCkMxYrAdRfaMbfG/6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 113/121] Input: i8042 - fix strange behavior of touchpad on Clevo NS70PU
Date: Tue, 13 Feb 2024 18:22:02 +0100
Message-ID: <20240213171856.287681293@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


