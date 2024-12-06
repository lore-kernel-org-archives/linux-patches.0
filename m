Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646931442E8;
	Fri,  6 Dec 2024 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496813; cv=none; b=Wuubb2otE5PITDpAxJQ1fR2pDTl9coAh8PUF4T2X+fO8QsqcDeXzFqIiKmkPc7lFPEER2pQtr7wAY5Xh6KecyY0khg0epyAnXm2o9D0h1a3rxDlUWem2PcEy76Nd9XKQwMK2MaEHHYAg6XlUzcbJ45FuijekV071JwwHl1Y9Da8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496813; c=relaxed/simple;
	bh=ewINBQeapnQY1EwEgMVeAaL6GYwRRFTWE1SJ4Nm5ebY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFNS7RmrafLbWB0ZpWF3e7qKbegP4FJ5AFo7Nr3rzwexurbuGSarFu+UzhSkdT1l9ApviLcgh6Ht4f5rFc+fSYQgUnR2k0rq6WZ4J5I4IWZau9TAv/HHRQPgqltGOvBsg6ofjxHFBDUUwa0FXMGJzrDfkv5v0mrsd93TAcjZC3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLXxnYJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLXxnYJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7FCC4CED1;
	Fri,  6 Dec 2024 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496813;
	bh=ewINBQeapnQY1EwEgMVeAaL6GYwRRFTWE1SJ4Nm5ebY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLXxnYJemB/HHrWVK4/OrFu5L6J4EceeYZGK0JmttNTj40uGOe5KmN1edK4k1ToB2
	 /XYl2J4icKYrZ1pWdYAP9uG7GFbETXHr7ImARjzo3pryI9n/XCSfpqkDyAda6d7Op5
	 RbCMQKf1DA/671gkSUdemxIgyvjC/QV9z0G/FMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/676] firmware: google: Unregister driver_info on failure
Date: Fri,  6 Dec 2024 15:28:19 +0100
Message-ID: <20241206143656.491696928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 32b0901e141f6d4cf49d820b53eb09b88b1f72f7 ]

When platform_device_register_full() returns error, the gsmi_init() returns
without unregister gsmi_driver_info, fix by add missing
platform_driver_unregister() when platform_device_register_full() failed.

Fixes: 8942b2d5094b ("gsmi: Add GSMI commands to log S0ix info")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20241015131344.20272-1-yuancan@huawei.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/gsmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 96ea1fa76d351..854d488e025e9 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -918,7 +918,8 @@ static __init int gsmi_init(void)
 	gsmi_dev.pdev = platform_device_register_full(&gsmi_dev_info);
 	if (IS_ERR(gsmi_dev.pdev)) {
 		printk(KERN_ERR "gsmi: unable to register platform device\n");
-		return PTR_ERR(gsmi_dev.pdev);
+		ret = PTR_ERR(gsmi_dev.pdev);
+		goto out_unregister;
 	}
 
 	/* SMI access needs to be serialized */
@@ -1056,10 +1057,11 @@ static __init int gsmi_init(void)
 	gsmi_buf_free(gsmi_dev.name_buf);
 	kmem_cache_destroy(gsmi_dev.mem_pool);
 	platform_device_unregister(gsmi_dev.pdev);
-	pr_info("gsmi: failed to load: %d\n", ret);
+out_unregister:
 #ifdef CONFIG_PM
 	platform_driver_unregister(&gsmi_driver_info);
 #endif
+	pr_info("gsmi: failed to load: %d\n", ret);
 	return ret;
 }
 
-- 
2.43.0



