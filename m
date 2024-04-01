Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C46446AC;
	Mon,  1 Apr 2024 16:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988717; cv=none; b=FVgRhXUs7b0g160oZbpBS3aLFQVCzjuXrLtQcjJO4ShMK9DM53WCEAmDH7dgvQRW8Lqj7pScw9qPZST32K0khQIDKrldnRtFF8btHOC0mrAs0EIXOO2Y8qHja2ur+QgUkXcndBS8ymlan44hukg/GY5zYSKqvhcz+vPYg8HGTt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988717; c=relaxed/simple;
	bh=buDAD1XiVbMMNDOJxpslMhg3x/gVnt6LMMX8xAH6dI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntswYfOsa8wBgxenn4+EZaRgrulZ1lXPXWfoTOMfpgADE+FXVDTEH12k9F9kd1bmcGbTsMGBEt0UEGh9QgSEAt7P4HIMLRzoxXM8PkAnDXDCWIb8tzCR6P3gnJ+w5Mrt3BKcQXrPvcpseFvig0T2DGIDDSqDdzEKDWWeuKtFf8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNswvILM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNswvILM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811C8C433F1;
	Mon,  1 Apr 2024 16:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988717;
	bh=buDAD1XiVbMMNDOJxpslMhg3x/gVnt6LMMX8xAH6dI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNswvILMkN88eWfSE+tqe0G3ZAkNOmKuNA3Z/M0blLkM7WwMPey6cJJ8uZKGGI4ue
	 jo+sGN2iKBr8T4kXuMOSYeacONaPpvIy5OZBrD2F9z+xOZ1EeDPOtFwO5eojUgFfre
	 C3FXwl+nq69pTv0CvMMLIw6oF+QBxqW8jcHVbE4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	regressions@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.7 268/432] misc: lis3lv02d_i2c: Fix regulators getting en-/dis-abled twice on suspend/resume
Date: Mon,  1 Apr 2024 17:44:15 +0200
Message-ID: <20240401152601.150862272@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -198,8 +198,14 @@ static int lis3lv02d_i2c_suspend(struct
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
 
@@ -208,13 +214,12 @@ static int lis3lv02d_i2c_resume(struct d
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


