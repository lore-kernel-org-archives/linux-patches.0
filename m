Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7271B258EE9;
	Sat, 17 Oct 2026 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260451; cv=none; b=XHq/+5ECqbOEQ35s+iUU1TPQ/BJ0N3RkcOyLLLitRWowRVP7X4NA8bXGlTcEcTBsEcAC3pmfRTPiYixbajWrbZz3kGkuQJcdRzQEj8YvnRukQjChv0mtfQuN5zzFMMo9MGOG43DJjzEBgnVBLebBzCx4WB3E1xTAw2Q3vgCPh4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260451; c=relaxed/simple;
	bh=v6AidjPsmQPe8ZKTPm19dMIjZTB+27C1MckQL7/8rZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4MbUQkcb+4kUZnAvx5XIGrtl/Kmc4pwKT90tfAiGh1R7c2iNl8qQKBMtdiFU/HY5nc8dB59HhYmMmQfF2MUdQVG9DmlyZUMc/YqB25+m2hGHIIt+Hemc/S8MjSmGcQX+oREWp+HU2n5qzlKOEXlaTanZF/R0Z6nk8CtI2s2RSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgrU9sMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgrU9sMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656C41F000C4;
	Sat, 17 Oct 2026 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260450;
	bh=nPe8QuyygvmFKHPwLBrBdi95Ecwh8yS5EEX636vPN+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgrU9sMdIPordYowoL7uW6ZA9u7aWzx4YSprdYjVX+obag2ti6BmU4cprMCTzPMxD
	 fjjIwFdjXRRbLHzZI7wYE5qIukR4wDvU9r28z95WMJRvcGnrh744yP6zq207ydzOnP
	 GvxuRJ6ahH9ifrNMXRC2kIsE+yisak4cnUkymYgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel J. Ogorchock" <djogorchock@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1550/1674] HID: nintendo: avoid bluetooth suspend/resume stalls
Date: Sat, 17 Oct 2026 18:03:42 +0200
Message-ID: <20261017160510.891596096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Daniel J. Ogorchock <djogorchock@gmail.com>

[ Upstream commit 4a0381080397e77792a5168069f174d3e56175ff ]

Ensure we don't stall or panic the kernel when using bluetooth-connected
controllers. This was reported as an issue on android devices using
kernel 6.6 due to the resume hook which had been added for usb joycons.

First, set a new state value to JOYCON_CTLR_STATE_SUSPENDED in a
newly-added nintendo_hid_suspend. This makes sure we will not stall out
the kernel waiting for input reports during led classdev suspend. The
stalls could happen if connectivity is unreliable or lost to the
controller prior to suspend.

Second, since we lose connectivity during suspend, do not try
joycon_init() for bluetooth controllers in the nintendo_hid_resume path.

Tested via multiple suspend/resume flows when using the controller both
in USB and bluetooth modes.

Signed-off-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 115f496368e58..7e272e79e00fb 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -301,6 +301,7 @@ enum joycon_ctlr_state {
 	JOYCON_CTLR_STATE_INIT,
 	JOYCON_CTLR_STATE_READ,
 	JOYCON_CTLR_STATE_REMOVED,
+	JOYCON_CTLR_STATE_SUSPENDED,
 };
 
 /* Controller type received as part of device info */
@@ -2418,14 +2419,46 @@ static void nintendo_hid_remove(struct hid_device *hdev)
 
 static int nintendo_hid_resume(struct hid_device *hdev)
 {
-	int ret = joycon_init(hdev);
+	struct joycon_ctlr *ctlr = hid_get_drvdata(hdev);
+	int ret;
+
+	hid_dbg(hdev, "resume\n");
+	if (ctlr->hdev->bus != BUS_USB) {
+		hid_dbg(hdev, "no-op resume for bt ctlr\n");
+		ctlr->ctlr_state = JOYCON_CTLR_STATE_READ;
+		return 0;
+	}
 
+	ret = joycon_init(hdev);
 	if (ret)
-		hid_err(hdev, "Failed to restore controller after resume");
+		hid_err(hdev,
+			"Failed to restore controller after resume: %d\n",
+			ret);
+	else
+		ctlr->ctlr_state = JOYCON_CTLR_STATE_READ;
 
 	return ret;
 }
 
+static int nintendo_hid_suspend(struct hid_device *hdev, pm_message_t message)
+{
+	struct joycon_ctlr *ctlr = hid_get_drvdata(hdev);
+
+	hid_dbg(hdev, "suspend: %d\n", message.event);
+	/*
+	 * Avoid any blocking loops in suspend/resume transitions.
+	 *
+	 * joycon_enforce_subcmd_rate() can result in repeated retries if for
+	 * whatever reason the controller stops providing input reports.
+	 *
+	 * This has been observed with bluetooth controllers which lose
+	 * connectivity prior to suspend (but not long enough to result in
+	 * complete disconnection).
+	 */
+	ctlr->ctlr_state = JOYCON_CTLR_STATE_SUSPENDED;
+	return 0;
+}
+
 #endif
 
 static const struct hid_device_id nintendo_hid_devices[] = {
@@ -2452,6 +2485,7 @@ static struct hid_driver nintendo_hid_driver = {
 
 #ifdef CONFIG_PM
 	.resume		= nintendo_hid_resume,
+	.suspend	= nintendo_hid_suspend,
 #endif
 };
 module_hid_driver(nintendo_hid_driver);
-- 
2.53.0



