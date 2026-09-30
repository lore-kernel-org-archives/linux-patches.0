Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AF85172E2;
	Wed, 30 Sep 2026 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787705; cv=none; b=EcjW2o2oltScqTW9tVsdr5YSAEkd04tnkZwikS1uy7FBq9zF6fwsDfIlA1qUHiaEboCzkB0l/T+MyKdYiUGf9FUdA3kKBazn7ky/XFyF7mN3Ige4gw0vFE0anM3IddEb/aUd0ETXEeb2f7bLgR32nRdVyuT3Ti+DVRvvJaB4M2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787705; c=relaxed/simple;
	bh=ZfBUYlOM33/tspZRuga4WvxXYsrurc4koN3OiH0Hghw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwGk1I3B6xaViQ4h4VviP838MA/goxdRTM9CqpX7YYr312xGsVuX9nBX1KWJzk8oHVZREvDcuB/3PBnil6nxk5bdIWkLa5vdqxJiyH10MVuAV46BDOcIOqDG6B8qWggPAFa8zfl1B4esLluamKjcXqouvSg5z9SEnbO82xc+8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R12mIdTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R12mIdTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E97B1F000FF;
	Wed, 30 Sep 2026 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787704;
	bh=5HHVQLfkNKsakWCag51j0c9VwcV4K1dtcVzubxd0iNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R12mIdTVOg8HrjoEzGgB4ur9xVguEvJO1FSf0sKp1Ss5v57ca8ciPvbYdnH6jR1Rt
	 hVaWYJ7jvnQAv9jApHsX3sc7sVWNnPtuoQo6uGG5NIVlxxNXXfaEQKpdg8PRCJQDH6
	 ePzU32PZE1TYpvuOTA5mA1IlR1UKurUEUfK1SUoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 324/457] HID: hid-oxp: use cancel_delayed_work_sync() in remove
Date: Wed, 30 Sep 2026 17:27:09 +0200
Message-ID: <20260930152353.014508095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit abd24922c2a9797d6184be0561dd85e7bcdfd091 upstream.

oxp_hid_remove() uses cancel_delayed_work() for all three delayed work
items.  cancel_delayed_work() only dequeues a pending work item without
waiting for a currently executing callback to finish.  If any of the
work callbacks (oxp_rgb_queue_fn, oxp_btn_queue_fn, oxp_mcu_init_fn) is
running at the time of removal, the callback continues executing
concurrently with hid_hw_close() and hid_hw_stop(), accessing the HID
device after it has been closed and stopped.

Use cancel_delayed_work_sync() instead to ensure that any in-progress
work callback completes before device teardown proceeds.

Fixes: 84910c459d65 ("HID: hid-oxp: Add OneXPlayer configuration driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://lore.kernel.org/r/20260804-oxp-fix-v2-1-b2d56e4c8a2c@cherr.cc
Link: https://lore.kernel.org/r/20260804-oxp-fix-v1-1-51a4fe787167@cherr.cc
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-oxp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-oxp.c b/drivers/hid/hid-oxp.c
index d2ded6b08ce9..1e691ebc1199 100644
--- a/drivers/hid/hid-oxp.c
+++ b/drivers/hid/hid-oxp.c
@@ -1552,9 +1552,9 @@ static int oxp_hid_probe(struct hid_device *hdev,
 
 static void oxp_hid_remove(struct hid_device *hdev)
 {
-	cancel_delayed_work(&drvdata.oxp_rgb_queue);
-	cancel_delayed_work(&drvdata.oxp_btn_queue);
-	cancel_delayed_work(&drvdata.oxp_mcu_init);
+	cancel_delayed_work_sync(&drvdata.oxp_rgb_queue);
+	cancel_delayed_work_sync(&drvdata.oxp_btn_queue);
+	cancel_delayed_work_sync(&drvdata.oxp_mcu_init);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 }
-- 
2.55.0



