Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FBB1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FBCC433C7;
	Mon, 11 Sep 2023 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441788;
	bh=X4G/AWkmIJicMDvuC4Yup2HWdyOxg0+OG9Cr6rCHizY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQIITdZOPqRP/On+4wTpyxrFPsSyMCplY3QvMVbhZVg5EZGZhi+czzjhXOet1JEjw
	 w8pI0+bBPVdHCv9ayGqYZhHXE304fWcCiDqAfvjNEKW6EaRvDVGnjAbVVNv5ZkGad5
	 c2b1kvzXh6NDxF9blBnF93pzaOwSxn57inx9DH+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 537/739] HID: nvidia-shield: Remove led_classdev_unregister in thunderstrike_create
Date: Mon, 11 Sep 2023 15:45:36 +0200
Message-ID: <20230911134706.101024692@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit cb818a047f2b95f3d9e08568ff7f8f513832ff2f ]

Avoid calling thunderstrike_led_set_brightness from thunderstrike_create
when led_classdev_unregister is called. led_classdev_unregister was called
from thunderstrike_create in the error path. Calling
thunderstrike_led_set_brightness in this situation is unsafe.

Fixes: f88af60e74a5 ("HID: nvidia-shield: Support LED functionality for Thunderstrike")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nvidia-shield.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-nvidia-shield.c b/drivers/hid/hid-nvidia-shield.c
index a928ad2be62db..4e183650c4478 100644
--- a/drivers/hid/hid-nvidia-shield.c
+++ b/drivers/hid/hid-nvidia-shield.c
@@ -513,21 +513,22 @@ static struct shield_device *thunderstrike_create(struct hid_device *hdev)
 
 	hid_set_drvdata(hdev, shield_dev);
 
+	ts->haptics_dev = shield_haptics_create(shield_dev, thunderstrike_play_effect);
+	if (IS_ERR(ts->haptics_dev))
+		return ERR_CAST(ts->haptics_dev);
+
 	ret = thunderstrike_led_create(ts);
 	if (ret) {
 		hid_err(hdev, "Failed to create Thunderstrike LED instance\n");
-		return ERR_PTR(ret);
-	}
-
-	ts->haptics_dev = shield_haptics_create(shield_dev, thunderstrike_play_effect);
-	if (IS_ERR(ts->haptics_dev))
 		goto err;
+	}
 
 	hid_info(hdev, "Registered Thunderstrike controller\n");
 	return shield_dev;
 
 err:
-	led_classdev_unregister(&ts->led_dev);
+	if (ts->haptics_dev)
+		input_unregister_device(ts->haptics_dev);
 	return ERR_CAST(ts->haptics_dev);
 }
 
-- 
2.40.1



