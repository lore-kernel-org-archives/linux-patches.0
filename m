Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A227381E;
	Tue, 21 Oct 2025 19:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076543; cv=none; b=L/w9rXm+P01JiRIOWVIqRE3cRp25mKCKi6NRM38Mvlia6oriuSrA1FMrBPWR7pr0x0y3iTEDiwLVn32xQgcVhb9+1xEYflZlNw48DzVjDvAcrZOXHMs9NHsNXWwvEsO/o61qmM6AafFp9c8TnP8+Bbalj9FGesg+V7CdNfGJ78w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076543; c=relaxed/simple;
	bh=foI71qDENRnCphzbn796UsLtUwZEaP+5ICgXEZhQV9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZYUPlG9n9P+MbzmupA6NVmmMkRsB6rZm1EdiF0P9OI+wvyjiWGXDGM52MSdjUbgiUmPLFDn9T/eSmlYoAdEkNgRpJicGVunAaZJLqLxdwTEOWfau4Ob+SToJzuBtanIIdEb7bXadue6gNtmXP1e0NhnqkUVX7h7jyyH5lZGw+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsQIWeVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsQIWeVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76DCC4CEF1;
	Tue, 21 Oct 2025 19:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076543;
	bh=foI71qDENRnCphzbn796UsLtUwZEaP+5ICgXEZhQV9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsQIWeVy1FkCtHCAb+8MUcMVdFUFdUDBfwq0sEkH4D8GcUNjEonYpDi910TNOR8SB
	 skA2rUnIAvOws6R1scMHeYQsCP7Kfe4Tiivj/L8yesLfliIuOTDZrnp1iym/p71L8X
	 QqVDymuxgXgatIlfDmZFUrsB0yWc9gNk8uqj/J1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/105] HID: hid-input: only ignore 0 battery events for digitizers
Date: Tue, 21 Oct 2025 21:51:17 +0200
Message-ID: <20251021195023.280260494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 0187c08058da3e7f11b356ac27e0c427d36f33f2 ]

Commit 581c4484769e ("HID: input: map digitizer battery usage") added
handling of battery events for digitizers (typically for batteries
presented in stylii). Digitizers typically report correct battery levels
only when stylus is actively touching the surface, and in other cases
they may report battery level of 0. To avoid confusing consumers of the
battery information the code was added to filer out reports with 0
battery levels.

However there exist other kinds of devices that may legitimately report
0 battery levels. Fix this by filtering out 0-level reports only for
digitizer usages, and continue reporting them for other kinds of devices
(Smart Batteries, etc).

Reported-by: 卢国宏 <luguohong@xiaomi.com>
Fixes: 581c4484769e ("HID: input: map digitizer battery usage")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f5c217ac4bfaa..f073d5621050a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -622,7 +622,10 @@ static void hidinput_update_battery(struct hid_device *dev, unsigned int usage,
 		return;
 	}
 
-	if (value == 0 || value < dev->battery_min || value > dev->battery_max)
+	if ((usage & HID_USAGE_PAGE) == HID_UP_DIGITIZER && value == 0)
+		return;
+
+	if (value < dev->battery_min || value > dev->battery_max)
 		return;
 
 	capacity = hidinput_scale_battery_capacity(dev, value);
-- 
2.51.0



