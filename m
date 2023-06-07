Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9CC3AE43
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC50C433EF;
	Wed,  7 Jun 2023 20:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169384;
	bh=wEHtG6VLel2QgpdGA3+37ZL/FZd5p2AoGEukOfRRNbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltojKeFm6tkDRZxhMRlF4Ke5joEGo/olzqaNZoWpeBDMGVWED/G3Z8Cqdwc4K7xr7
	 WnFlcdywqVticrjO/2XqiKpYrBOrV/SqNXuS9x8NA5hLvRx/oIl7NbbwZ2f2JMwxXj
	 LrWTTCiLzz+ddANbc0sTcWcoaA5a6hqli7zJpK1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Mark Lord <mlord@pobox.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 060/286] HID: logitech-hidpp: Handle timeout differently from busy
Date: Wed,  7 Jun 2023 22:12:39 +0200
Message-ID: <20230607200925.030740504@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 6199d23c91ce53bfed455f09a8c5ed170d516824 ]

If an attempt at contacting a receiver or a device fails because the
receiver or device never responds, don't restart the communication, only
restart it if the receiver or device answers that it's busy, as originally
intended.

This was the behaviour on communication timeout before commit 586e8fede795
("HID: logitech-hidpp: Retry commands when device is busy").

This fixes some overly long waits in a critical path on boot, when
checking whether the device is connected by getting its HID++ version.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Suggested-by: Mark Lord <mlord@pobox.com>
Fixes: 586e8fede795 ("HID: logitech-hidpp: Retry commands when device is busy")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217412
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index da89e84c9cbeb..0853114e16a08 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -311,6 +311,7 @@ static int hidpp_send_message_sync(struct hidpp_device *hidpp,
 			dbg_hid("%s:timeout waiting for response\n", __func__);
 			memset(response, 0, sizeof(struct hidpp_report));
 			ret = -ETIMEDOUT;
+			goto exit;
 		}
 
 		if (response->report_id == REPORT_ID_HIDPP_SHORT &&
-- 
2.39.2



