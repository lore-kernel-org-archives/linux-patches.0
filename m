Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6B92931EE;
	Sat, 12 Sep 2026 15:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227712; cv=none; b=nGQV8OYzN4Q2HK+WYUiczrhgrSD8Uzr55E21qP0r77RkqKw1HSFYMCG0wFTdsCduJua9csNSIOTilRYrtfvsbd8gVHjSi2VU9cAeaE7pfhkSfpBxkDUYxczj+d8+02rfwb5oklhabenJFDaiJLe6xNlkf4XM6s8Pe0JT0FknP70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227712; c=relaxed/simple;
	bh=S8R3TLKCD5heR+THiauqpUPChg7gVbGh7rkhFO0Zq8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsn2AO3pMI5W7RKW9yIBj3LFjkPxdjRXZ6nbn9pO5dCQvzx8NO4JD37kKdBnoy2SSV9KBupJP9S9icNqHwSRGb0ZuZL+DSZZd8bQrd5tKh0ED8Ysc9FaqWEM4n1yzNozTaSf/RgZ/gfbcCm3lt0y4JwFf/GV8L+Uvrhh96apgGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4SrYR94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4SrYR94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300B51F000FF;
	Sat, 12 Sep 2026 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227711;
	bh=jMnAJfXet6e4A7ahxc65o1eFqaRRWk6S4Ykg3J5dDJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4SrYR94qSlrDYAng+WZM9e5x71Ckg/ZAAEy/MiJ+xKKdcKrlOHHP5P+R/HLW/u4r
	 SMyMXWcyekpPiU60S1e8QI6PwKJhiEAoX+VeFUx7oblQy1IzVZ+Hz7kNk4/ccYgaeC
	 js9eBhoGrry2rdG9y0d52JiB3zDdtJxtIcehJXNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 0235/1191] i3c: master: Fix info leak and UAF in device unregister path
Date: Sat, 12 Sep 2026 08:49:23 +0200
Message-ID: <20260912065553.488696704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d2c743efd2d1ee64e94324664808f623dd865872 upstream.

i3c_master_unregister_i3c_devs() clears i3cdev->dev->desc before
calling device_unregister().  During device_unregister(),
device_del() emits a KOBJ_REMOVE uevent and unbinds the driver while
the device descriptor is still expected to be valid.  As a result,
i3c_device_uevent() and a racing modalias_show() can observe a NULL
desc and fall back to an uninitialized stack struct i3c_device_info,
leaking kernel stack contents in the generated modalias.  Driver
.remove() callbacks may also encounter an unexpected NULL desc during
unbind.

Keep desc valid until device_unregister() has completed.  Since
device_unregister() drops the device reference and may free the device,
take an extra reference with get_device() before unregistering.  Clear
desc afterwards and release the extra reference with put_device().
This preserves the release-time invariant that desc must be NULL while
avoiding both the information leak and a potential use-after-free from
writing desc after the device has been released.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260702190003.8BF741F000E9@smtp.kernel.org/
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260723075747.34049-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2500,11 +2500,12 @@ static void i3c_master_unregister_i3c_de
 		if (!i3cdev->dev)
 			continue;
 
-		i3cdev->dev->desc = NULL;
-		if (device_is_registered(&i3cdev->dev->dev))
+		if (device_is_registered(&i3cdev->dev->dev)) {
+			get_device(&i3cdev->dev->dev);
 			device_unregister(&i3cdev->dev->dev);
-		else
-			put_device(&i3cdev->dev->dev);
+		}
+		i3cdev->dev->desc = NULL;
+		put_device(&i3cdev->dev->dev);
 		i3cdev->dev = NULL;
 	}
 }


