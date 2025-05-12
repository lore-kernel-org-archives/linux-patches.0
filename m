Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4C12989AD;
	Mon, 12 May 2025 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073282; cv=none; b=spqa3kY+KK3C4V6XmhgM4ZxaCH+SV+v76wdISi4bMp6Fkl6+WGEHR3FRIv4c23VgxmZnXCSh6RLFycI8FteMAdszbjrDdsWIL6jUH3t/DdSxh/+Mh4tg5MDjoO7iavVoqY/H6LZcPAIjcTPH9Ey//1Hik5V2IAzVe94AvTbqvL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073282; c=relaxed/simple;
	bh=Wq6rOv6112fF0gYSzmTR1KwzvVp2DVmngV5JP0kXacE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/H63ui3y1CGiso1Jl3at+UdjY3UZv5SiNMQ4+UMYCtJ5Mep+Rpg/n9jgM4d01ZPH6BCk2nviP7DL3gyVZRm/miYxW5fnMLUr0R+6sfgnoL+RUOkZNcL8ae8VdbM7xQYRRuFzAHMY+PI5VGWBFPrm4qOD38BBl0uScFqR8Lmoek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDS2cmYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDS2cmYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39001C4CEE7;
	Mon, 12 May 2025 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073282;
	bh=Wq6rOv6112fF0gYSzmTR1KwzvVp2DVmngV5JP0kXacE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDS2cmYQmqYtZnMtoZfv42VGclWc8KXEUJNPpK/ClEdJdPjs5fiJ5gujpcpSavAXp
	 WkLUfLrfL7SESyWSIP//rgHO++5a8Hy1G/g+bWsiX6La0gEPfI2pNp5i0DkNqcBkxC
	 n51Mft9ZfdXhjU+HJHnCKMe/n30H5JS5l4fBRlPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alistair Francis <alistair@alistair23.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 027/113] Input: cyttsp5 - fix power control issue on wakeup
Date: Mon, 12 May 2025 19:45:16 +0200
Message-ID: <20250512172028.786989524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>

commit 7675b5efd81fe6d524e29d5a541f43201e98afa8 upstream.

The power control function ignores the "on" argument when setting the
report ID, and thus is always sending HID_POWER_SLEEP. This causes a
problem when trying to wakeup.

Fix by sending the state variable, which contains the proper HID_POWER_ON or
HID_POWER_SLEEP based on the "on" argument.

Fixes: 3c98b8dbdced ("Input: cyttsp5 - implement proper sleep and wakeup procedures")
Cc: stable@vger.kernel.org
Signed-off-by: Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/20250423135243.1261460-1-hugo@hugovil.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/cyttsp5.c b/drivers/input/touchscreen/cyttsp5.c
index 14c43f0a6c21..071b7c9bf566 100644
--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -580,7 +580,7 @@ static int cyttsp5_power_control(struct cyttsp5 *ts, bool on)
 	int rc;
 
 	SET_CMD_REPORT_TYPE(cmd[0], 0);
-	SET_CMD_REPORT_ID(cmd[0], HID_POWER_SLEEP);
+	SET_CMD_REPORT_ID(cmd[0], state);
 	SET_CMD_OPCODE(cmd[1], HID_CMD_SET_POWER);
 
 	rc = cyttsp5_write(ts, HID_COMMAND_REG, cmd, sizeof(cmd));
-- 
2.49.0



