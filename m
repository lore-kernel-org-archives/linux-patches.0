Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901757993D;
	Wed, 21 Feb 2024 13:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523092; cv=none; b=CwYdskRPV1AdvV6hlKAydjdYR10a98dOsS1nxprGFWA4vioIx/6RUx3TOuSSPPSOmXTwknBN3NOxpDGJGhv7dV4GIidoNcwdEWRbyGSnaqaoDMt1Np1+iDtZMWiEQ9JtG5Up/8r36R92qtq7xMJqW0ycVvf3kPuzQLmP+6jV8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523092; c=relaxed/simple;
	bh=0bL1glqdxs2b69jfhLbtktSVc8lfLWO6DHxDYwrwz08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4mZ+XYZOZY5yljiDlx4/bg0tMQ5jn99AuxUw97K55b+/AeDNum4YhvLynjEbCttHleQiNb3KmSumFvUhjtfdcEvsFoizGvEU08P2wWA85cI5HB/5WL2gQ5Z4Q76bTdP3KoeS9pocnjkcpfq2vd7EDoQ26jhU9ojtpukqNGm3PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTwwC8wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTwwC8wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C9BC433C7;
	Wed, 21 Feb 2024 13:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523092;
	bh=0bL1glqdxs2b69jfhLbtktSVc8lfLWO6DHxDYwrwz08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTwwC8wbHaZvz6IaRAz0jH6Rm72whaYHA53YZGIZtSgNSHP/+oHA0lDyA7vK+iXsf
	 GyQ8mXTJJEFCLYG3BMKs+OVUgzXjAVaRAM09o9ngpWY6Zu2rt+j/Sk78wk+a74pTa6
	 f/iHtYd+JYrybB9M86bNsevT9RsA7DeyXOAiWS18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 337/476] Input: i8042 - fix strange behavior of touchpad on Clevo NS70PU
Date: Wed, 21 Feb 2024 14:06:28 +0100
Message-ID: <20240221130020.481916241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,6 +1173,12 @@ static const struct dmi_system_id i8042_
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


