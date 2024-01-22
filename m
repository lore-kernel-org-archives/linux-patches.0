Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66537CF21;
	Tue, 23 Jan 2024 02:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975733; cv=none; b=uQtWHPO8Voo+AhUGGdvB1OWtoWcO1ySLYL1qPcJMXwhsijJ2VLYUt3triGi/i/Wb4cnqS8VF2xQWkoIjaJGAxn8tNd6HOS0vRvYWsBwB3QA5xvDaM7BRx67BVXTdVii5kUeo5w5F9PlzKO+PP1ZX8BLFmiqBLZcyvBq12ws811k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975733; c=relaxed/simple;
	bh=WNmPayOZVp7vMy5g9BFKt3TRx8Baw3X4cYoUkmgbcY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZFo1WxxzOY4sDaCDuKmqMJkCDgNhFzZbe+TV5yf9JkEJL4vw/Zko4A5RWTK4Iibusn9cblAiryP7ee/Cpw2hlQMrzglwGdbN2KT3u1LTanLmd9R6087534ExUWpxIxTWDNikqGUmIZxUDVfGBUQv3BsF9ZFjSREshXygLwWoVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHnDJ1N5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHnDJ1N5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975A0C43390;
	Tue, 23 Jan 2024 02:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975733;
	bh=WNmPayOZVp7vMy5g9BFKt3TRx8Baw3X4cYoUkmgbcY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHnDJ1N5bh+cLzYtCPIyNrmkBKjNV9ZOnp1RBqOJ2lopTgwdd6WNk4ler5+YSjc5I
	 +KfoV4AOc0SgJKLv7u2kbMTnH5X9BB3GaiImfcVxbyIn7V+Wg1GSsUqmx/nqq8TYcm
	 cSOpARuH3j3xMBQgw2Upas2wWwf+XfMrCkB0WRi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 495/583] usb: cdc-acm: return correct error code on unsupported break
Date: Mon, 22 Jan 2024 15:59:06 -0800
Message-ID: <20240122235827.162559175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 66aad7d8d3ec5a3a8ec2023841bcec2ded5f65c9 ]

In ACM support for sending breaks to devices is optional.
If a device says that it doenot support sending breaks,
the host must respect that.
Given the number of optional features providing tty operations
for each combination is not practical and errors need to be
returned dynamically if unsupported features are requested.

In case a device does not support break, we want the tty layer
to treat that like it treats drivers that statically cannot
support sending a break. It ignores the inability and does nothing.
This patch uses EOPNOTSUPP to indicate that.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 9e98966c7bb94 ("tty: rework break handling")
Link: https://lore.kernel.org/r/20231207132639.18250-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c        | 3 +++
 drivers/usb/class/cdc-acm.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 724ebf82f2cd..493fc4742895 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2485,6 +2485,9 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 	if (!retval) {
 		msleep_interruptible(duration);
 		retval = tty->ops->break_ctl(tty, 0);
+	} else if (retval == -EOPNOTSUPP) {
+		/* some drivers can tell only dynamically */
+		retval = 0;
 	}
 	tty_write_unlock(tty);
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index a1f4e1ead97f..0e7439dba8fe 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -916,6 +916,9 @@ static int acm_tty_break_ctl(struct tty_struct *tty, int state)
 	struct acm *acm = tty->driver_data;
 	int retval;
 
+	if (!(acm->ctrl_caps & USB_CDC_CAP_BRK))
+		return -EOPNOTSUPP;
+
 	retval = acm_send_break(acm, state ? 0xffff : 0);
 	if (retval < 0)
 		dev_dbg(&acm->control->dev,
-- 
2.43.0



