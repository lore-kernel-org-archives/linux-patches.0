Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020511DF727;
	Tue,  8 Oct 2024 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394149; cv=none; b=Xu5DGdRHq8sdmenq7dQENGPXJs0ABsrHbr1JLCRhvEbWhmobYH0bqSltRsV2A8BoreH3mR/JTsYlJt/AsPfKejCFAtIOFwzURC8PsSb7omcBGCnZ0Y54owMzkrsFFYzuQwxPJIoa+6a4/Tet9P8Dkzk0QnBKPfgxtJBoVYMGE4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394149; c=relaxed/simple;
	bh=pAR9Dc1zk3JK8m7/aCoQsZTJY8W/pEj4qrgI0nb12r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfC+iaQfP+cwwgPtW4uXk+gUFOq+Xs0wJYThBnuVYWVwdLEv/RX34IzImk3r5QK7WG3WUbV56SvimyLtTCX65kHQ/EVFu24Uqey9QyHm86hnIor5T/QqC2dSKvoWfvLFu1kDgnRLN3gfNSGzURCz1cdDqevH9uhQXQNxaMbfNks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVXLZcIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVXLZcIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B401C4CEC7;
	Tue,  8 Oct 2024 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394148;
	bh=pAR9Dc1zk3JK8m7/aCoQsZTJY8W/pEj4qrgI0nb12r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVXLZcIn7RXaN6RbYvYywYc8pRGOPZUi4yFO5464TDmiGG17maj60K/OxIqwswZi/
	 F3dQMbYWFHtszfDj8VA0wBq79mq5DsT9iEHQkuSGWSQvLLJnSjh6ew4vi6PU6CqhwX
	 xW+U5g/tAaFZlx02prv1aPVofbzdsX4whm1bM/KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/386] platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors
Date: Tue,  8 Oct 2024 14:09:35 +0200
Message-ID: <20241008115642.371087358@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2fae3129c0c08e72b1fe93e61fd8fd203252094a ]

x86_android_tablet_remove() frees the pdevs[] array, so it should not
be used after calling x86_android_tablet_remove().

When platform_device_register() fails, store the pdevs[x] PTR_ERR() value
into the local ret variable before calling x86_android_tablet_remove()
to avoid using pdevs[] after it has been freed.

Fixes: 5eba0141206e ("platform/x86: x86-android-tablets: Add support for instantiating platform-devs")
Fixes: e2200d3f26da ("platform/x86: x86-android-tablets: Add gpio_keys support to x86_android_tablet_init()")
Cc: stable@vger.kernel.org
Reported-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Closes: https://lore.kernel.org/platform-driver-x86/20240917120458.7300-1-a.burakov@rosalinux.ru/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241005130545.64136-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index ebfd9a3dac957..a0fa0b6859c9c 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -339,8 +339,9 @@ static __init int x86_android_tablet_probe(struct platform_device *pdev)
 	for (i = 0; i < pdev_count; i++) {
 		pdevs[i] = platform_device_register_full(&dev_info->pdev_info[i]);
 		if (IS_ERR(pdevs[i])) {
+			ret = PTR_ERR(pdevs[i]);
 			x86_android_tablet_remove(pdev);
-			return PTR_ERR(pdevs[i]);
+			return ret;
 		}
 	}
 
@@ -388,8 +389,9 @@ static __init int x86_android_tablet_probe(struct platform_device *pdev)
 								  PLATFORM_DEVID_AUTO,
 								  &pdata, sizeof(pdata));
 		if (IS_ERR(pdevs[pdev_count])) {
+			ret = PTR_ERR(pdevs[pdev_count]);
 			x86_android_tablet_remove(pdev);
-			return PTR_ERR(pdevs[pdev_count]);
+			return ret;
 		}
 		pdev_count++;
 	}
-- 
2.43.0



