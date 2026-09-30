Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB10515992;
	Wed, 30 Sep 2026 16:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786843; cv=none; b=XwiHfp+GjfMtMATj9W71a3JcCbnI8xnUvljreCiBfI1XLWxNM9tt5xTqX4NZXvf701cMDPZ7e13GVinD8A+6vfENSZKooaqjLiY90gkBYlkw5Jzun0KAZPEyRb1ecQTdDJi9iuTorikP4cWqB5tooO6fe6clCLL8pgIE5EzSEAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786843; c=relaxed/simple;
	bh=uTgHUkBePddTwTRHZiRf2dG2bhXv1TZu2eEQWBUVsWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQl/3D2Gk1RnRNdQQz5j8XTMj5Jm8VFiDBT4m4AD30NcYMffloa449BhC+kt0wvjUJvfEB+7nL+CRAktWP3bGtMMq/Sb7onQYlVRZFAZ0SC78EmxK+5TV8Udo50A675NxfD0fNlNxtHajGux36/pFAC2MICPgALY8YOahaoNhOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRqIdDa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRqIdDa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051491F000FF;
	Wed, 30 Sep 2026 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786841;
	bh=R93B6cefVeEEOAL+/Ca1r9CyYbAowWCX/IAodck9Q6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRqIdDa7hrnaQzQgywvZ+nmEHZzjxzyjY/8Z2M/E/VppexVPei1xU27CHGKtUUwF/
	 Zy5wQeoWIm46wBkgOp3lW7g7BsXYL0pDlhWKDE/OXZ0T9MFPokunzAxqwDDTbxOgjc
	 HI2tGtqx7FGswPuttfqpm8NV8PF2M6xfzHMkXbTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Onier?= <f3nr1l@me.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 022/457] HID: winwing: fix use-after-free in force feedback teardown
Date: Wed, 30 Sep 2026 17:22:07 +0200
Message-ID: <20260930152346.508759837@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Onier <f3nr1l@me.com>

[ Upstream commit a1a5ad37e50ceb192c07ac7e2d7143638cd4d110 ]

winwing_init_ff() passes the driver's private data, allocated with
devm_kzalloc() in winwing_probe(), as the effect context to
input_ff_create_memless(). The memoryless force-feedback core takes
ownership of that pointer and frees it with kfree() from
input_ff_destroy() (ml_ff_destroy()) when the input device is
destroyed.

Freeing a devm-managed allocation with kfree() is an invalid free, and
the same object is then released again by devres when the HID device is
torn down, a double free. As the allocation also embeds the LED class
devices, their timers and work item live on freed memory and the slab
gets corrupted. This triggers on unbind, rmmod, hot-unplug and on system
suspend, where the firmware cache walks the now-corrupt devres list.
KASAN reports:

  BUG: KASAN: invalid-free in input_ff_destroy
  Allocated by task N:
    winwing_probe

Pass NULL as the memless context instead and fetch the driver data from
the input device in winwing_play_effect(): the HID core already stores
the hid_device as the input device's drvdata. The force-feedback core
then owns nothing that it must not free.

Fixes: 42d020b54edc ("HID: winwing: Enable rumble effects")
Signed-off-by: René Onier <f3nr1l@me.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-winwing.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-winwing.c b/drivers/hid/hid-winwing.c
index 9cd25a77999e6..19b92c2c6579a 100644
--- a/drivers/hid/hid-winwing.c
+++ b/drivers/hid/hid-winwing.c
@@ -315,7 +315,8 @@ static void winwing_haptic_rumble_cb(struct work_struct *work)
 static int winwing_play_effect(struct input_dev *dev, void *context,
 		struct ff_effect *effect)
 {
-	struct winwing_drv_data *data = (struct winwing_drv_data *) context;
+	struct hid_device *hdev = input_get_drvdata(dev);
+	struct winwing_drv_data *data = hid_get_drvdata(hdev);
 
 	if (effect->type != FF_RUMBLE)
 		return 0;
@@ -342,7 +343,12 @@ static int winwing_init_ff(struct hid_device *hdev, struct hid_input *hidinput)
 
 	input_set_capability(hidinput->input, EV_FF, FF_RUMBLE);
 
-	return input_ff_create_memless(hidinput->input, data,
+	/*
+	 * input_ff_create_memless() takes ownership of the context pointer
+	 * and frees it on teardown; do not hand it the devm-managed drvdata.
+	 * winwing_play_effect() fetches it from the input device instead.
+	 */
+	return input_ff_create_memless(hidinput->input, NULL,
 			winwing_play_effect);
 }
 
-- 
2.53.0



