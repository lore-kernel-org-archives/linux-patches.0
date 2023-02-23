Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10F2584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97642C433EF;
	Thu, 23 Feb 2023 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157559;
	bh=uq3agZOl51Ax+BE3TqjgYC7xSN1ZcH100dakCXoB3RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ta5vegp8J6t+IqVxoyXUo8F7fblmYMfx89ZQrqrm0NUX8VLlNo3/37HDE8doA0m7
	 9+1ipkdQ9mXoQAB8FZi65pnPI/aIEhUmMiYRXA3ylTvIlYbwFpw6cLkVHXiX1O+BY+
	 9pY+mkhB4fGrG3AdqPd1Ji4ELcP1Ml+JY2Xpnk0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.cz>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.2 05/11] HID: mcp-2221: prevent UAF in delayed work
Date: Thu, 23 Feb 2023 14:04:59 +0100
Message-Id: <20230223130426.400061350@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.170746546@linuxfoundation.org>
References: <20230223130426.170746546@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 47e91fdfa511139f2549687edb0d8649b123227b upstream.

If the device is plugged/unplugged without giving time for mcp_init_work()
to complete, we might kick in the devm free code path and thus have
unavailable struct mcp_2221 while in delayed work.

Canceling the delayed_work item is enough to solve the issue, because
cancel_delayed_work_sync will prevent the work item to requeue itself.

Fixes: 960f9df7c620 ("HID: mcp2221: add ADC/DAC support via iio subsystem")
CC: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.cz>
Link: https://lore.kernel.org/r/20230215-wip-mcp2221-v2-1-109f71fd036e@redhat.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -922,6 +922,9 @@ static void mcp2221_hid_unregister(void
 /* This is needed to be sure hid_hw_stop() isn't called twice by the subsystem */
 static void mcp2221_remove(struct hid_device *hdev)
 {
+	struct mcp2221 *mcp = hid_get_drvdata(hdev);
+
+	cancel_delayed_work_sync(&mcp->init_work);
 }
 
 #if IS_REACHABLE(CONFIG_IIO)


