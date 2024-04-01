Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7431DFF4;
	Mon,  1 Apr 2024 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991096; cv=none; b=AzdEQtX42CY+zLTVHCVNfuBwBjr/BicBGFyX2REVsmxl5dr+kMvrP1oN2WulBZFr6+zNi4Ya/zgXIcMz/bksAPIvvLicFAW4x2CLgk1cazKlE7Ziv7lCMnAdH+IP0wcA8VE8PIXOFr9Qr5jeacTtMjWhsFz/SQ7LW/BkBgPDJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991096; c=relaxed/simple;
	bh=0DC+0sR9P/EnnR1WCZo85et8kAXT/cgZnIZaOaxlKP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfJP+laUcgwCk8S8mZBAKDw7YBUU/mNQqWzcQqeqzkUkj/uCLjeI6rl+NkAE3LAhLW/g8XsmpxuzcqxMWd8LMGTZkeyiV69lPOJRyZvekTESrdot6YNrW/3+5mCX4E05N5snAsQ5Z+bqfUtB6IyP20wiHOj+z2EVNUGdE4kAr3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+8M5vk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+8M5vk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF35BC433C7;
	Mon,  1 Apr 2024 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991096;
	bh=0DC+0sR9P/EnnR1WCZo85et8kAXT/cgZnIZaOaxlKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+8M5vk5BE+uT7mgVuLHoXPP2qTLRM34S9bAxhQXQm3Va3rvHiaOiVIjeYvzWoMde
	 B1xIxKZAAnHU1as2XmnjunfT0i14bfgdtGTjl/LW2g4t3e/on3FnJbedXNicgraeRR
	 Kz2dleNw4Db5ozbfvLk2GFwLOOs812s0QYkCiE+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	regressions@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 162/272] misc: lis3lv02d_i2c: Fix regulators getting en-/dis-abled twice on suspend/resume
Date: Mon,  1 Apr 2024 17:45:52 +0200
Message-ID: <20240401152535.799855415@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit ac3e0384073b2408d6cb0d972fee9fcc3776053d upstream.

When not configured for wakeup lis3lv02d_i2c_suspend() will call
lis3lv02d_poweroff() even if the device has already been turned off
by the runtime-suspend handler and if configured for wakeup and
the device is runtime-suspended at this point then it is not turned
back on to serve as a wakeup source.

Before commit b1b9f7a49440 ("misc: lis3lv02d_i2c: Add missing setting
of the reg_ctrl callback"), lis3lv02d_poweroff() failed to disable
the regulators which as a side effect made calling poweroff() twice ok.

Now that poweroff() correctly disables the regulators, doing this twice
triggers a WARN() in the regulator core:

unbalanced disables for regulator-dummy
WARNING: CPU: 1 PID: 92 at drivers/regulator/core.c:2999 _regulator_disable
...

Fix lis3lv02d_i2c_suspend() to not call poweroff() a second time if
already runtime-suspended and add a poweron() call when necessary to
make wakeup work.

lis3lv02d_i2c_resume() has similar issues, with an added weirness that
it always powers on the device if it is runtime suspended, after which
the first runtime-resume will call poweron() again, causing the enabled
count for the regulator to increase by 1 every suspend/resume. These
unbalanced regulator_enable() calls cause the regulator to never
be turned off and trigger the following WARN() on driver unbind:

WARNING: CPU: 1 PID: 1724 at drivers/regulator/core.c:2396 _regulator_put

Fix this by making lis3lv02d_i2c_resume() mirror the new suspend().

Fixes: b1b9f7a49440 ("misc: lis3lv02d_i2c: Add missing setting of the reg_ctrl callback")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/regressions/5fc6da74-af0a-4aac-b4d5-a000b39a63a5@molgen.mpg.de/
Cc: stable@vger.kernel.org
Cc: regressions@lists.linux.dev
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> # Dell XPS 15 7590
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/20240220190035.53402-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -199,8 +199,14 @@ static int lis3lv02d_i2c_suspend(struct
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	if (!lis3->pdata || !lis3->pdata->wakeup_flags)
+	/* Turn on for wakeup if turned off by runtime suspend */
+	if (lis3->pdata && lis3->pdata->wakeup_flags) {
+		if (pm_runtime_suspended(dev))
+			lis3lv02d_poweron(lis3);
+	/* For non wakeup turn off if not already turned off by runtime suspend */
+	} else if (!pm_runtime_suspended(dev))
 		lis3lv02d_poweroff(lis3);
+
 	return 0;
 }
 
@@ -209,13 +215,12 @@ static int lis3lv02d_i2c_resume(struct d
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
 
-	/*
-	 * pm_runtime documentation says that devices should always
-	 * be powered on at resume. Pm_runtime turns them off after system
-	 * wide resume is complete.
-	 */
-	if (!lis3->pdata || !lis3->pdata->wakeup_flags ||
-		pm_runtime_suspended(dev))
+	/* Turn back off if turned on for wakeup and runtime suspended*/
+	if (lis3->pdata && lis3->pdata->wakeup_flags) {
+		if (pm_runtime_suspended(dev))
+			lis3lv02d_poweroff(lis3);
+	/* For non wakeup turn back on if not runtime suspended */
+	} else if (!pm_runtime_suspended(dev))
 		lis3lv02d_poweron(lis3);
 
 	return 0;


