Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7438E1C701E;
	Wed, 19 Feb 2025 09:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955799; cv=none; b=YHYy+J0ndM2m83BOI2rLa1hE75Y8d1ywb2m5G8CfvihuXPCjjDFqUo1v1YkDI2kPbD57xy9pREb4rvMvRWQGBY/h/gCUVsvGtu7QAKBi6EPpIRxxYKLD+ZQzZ7tybp+z2IysT7wWhLv5MBMIAXA/QErfD87K34SaEz3fGCStmUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955799; c=relaxed/simple;
	bh=79VTrdTOkEoAYDL+5qsuwgJxyMiTomsh+3toKmhAjoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HzAxRh6O32Kn0VLskOwzF0Mq5TDL1RYXtSRNKHTK8lS++xJldA291HB/4Ep3uPMMWqiBoUbF/1J0F1N/R0Lf9DWwlN8kBVqI2MwZlx7kjbjDNCSxChI+L6aZyKeGvF5TyzfzoHM4b5VictDJPipO7cKRfOAMopR87S2zR3xR2Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka9+Geje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka9+Geje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB866C4CED1;
	Wed, 19 Feb 2025 09:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955799;
	bh=79VTrdTOkEoAYDL+5qsuwgJxyMiTomsh+3toKmhAjoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ka9+Geje0VOaVivbOjpvbwbKEQLWLMrIVmoYWauKGoyHmzj77/HzHwulQ2CIY4BFF
	 MQlzRJ0RqJe5nMSAaSCli3DtT/+Wc88e3V+mUakCOnFEGkpKxaQWCrZZFvHoE/PKLt
	 VNSi3XV92Byi1GvcGW6dpmTtokFOZqaz6Aq8HGG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vicki Pfau <vi@endrift.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/152] HID: hid-steam: Fix cleanup in probe()
Date: Wed, 19 Feb 2025 09:28:50 +0100
Message-ID: <20250219082554.684680910@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a9f1da09c69f13ef471db8b22107a28042d230ca ]

There are a number of issues in this code.  First of all if
steam_create_client_hid() fails then it leads to an error pointer
dereference when we call hid_destroy_device(steam->client_hdev).

Also there are a number of leaks.  hid_hw_stop() is not called if
hid_hw_open() fails for example.  And it doesn't call steam_unregister()
or hid_hw_close().

Fixes: 691ead124a0c ("HID: hid-steam: Clean up locking")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/1fd87904-dabf-4879-bb89-72d13ebfc91e@moroto.mountain
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 2f11f77ae2153..59b46163bc526 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1127,14 +1127,14 @@ static int steam_probe(struct hid_device *hdev,
 	 */
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_HIDRAW);
 	if (ret)
-		goto hid_hw_start_fail;
+		goto err_cancel_work;
 
 	ret = hid_hw_open(hdev);
 	if (ret) {
 		hid_err(hdev,
 			"%s:hid_hw_open\n",
 			__func__);
-		goto hid_hw_open_fail;
+		goto err_hw_stop;
 	}
 
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
@@ -1150,33 +1150,37 @@ static int steam_probe(struct hid_device *hdev,
 			hid_err(hdev,
 				"%s:steam_register failed with error %d\n",
 				__func__, ret);
-			goto input_register_fail;
+			goto err_hw_close;
 		}
 	}
 
 	steam->client_hdev = steam_create_client_hid(hdev);
 	if (IS_ERR(steam->client_hdev)) {
 		ret = PTR_ERR(steam->client_hdev);
-		goto client_hdev_fail;
+		goto err_stream_unregister;
 	}
 	steam->client_hdev->driver_data = steam;
 
 	ret = hid_add_device(steam->client_hdev);
 	if (ret)
-		goto client_hdev_add_fail;
+		goto err_destroy;
 
 	return 0;
 
-client_hdev_add_fail:
-	hid_hw_stop(hdev);
-client_hdev_fail:
+err_destroy:
 	hid_destroy_device(steam->client_hdev);
-input_register_fail:
-hid_hw_open_fail:
-hid_hw_start_fail:
+err_stream_unregister:
+	if (steam->connected)
+		steam_unregister(steam);
+err_hw_close:
+	hid_hw_close(hdev);
+err_hw_stop:
+	hid_hw_stop(hdev);
+err_cancel_work:
 	cancel_work_sync(&steam->work_connect);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->rumble_work);
+
 	return ret;
 }
 
-- 
2.39.5



