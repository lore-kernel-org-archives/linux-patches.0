Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CAE2210F1;
	Thu, 12 Dec 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023744; cv=none; b=RFdfH7ITV/wQH5vdu1yfDELKI7Fzc7zcubK1uIGz1O+u3vmJlGwhBg7XmKS8eCLPGb+L1MXOn6nybEvHkfCJFb6n6VvSlNALwkEQWmW/+siRs1nMLFR/18xUXUxT+k511lsEqaWA6wTRDyTwxrGuZBUkC2EPibPwd5reHaLW8z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023744; c=relaxed/simple;
	bh=7dmJ9Nsn4kdfv2SOA/QlMVxXQ6Z+hICxruxEYYz5iL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwbumb9Gmf3h+8E+v5nniT7uOmzj4ocJwHbhJso1CqsfNypKbYuTa/gucKEIr0sVw1W7ed7kuL+4Ux52YhvC0ahdCIa9ZWcNXeZOX65YOqzApudMttvZ6RCiv/W6aQGVuyHMzqb8l0VZYR4BjEFaCNRoIZpMUoe9VbnxpmM831g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBtc9XuN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBtc9XuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A196C4CECE;
	Thu, 12 Dec 2024 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023743;
	bh=7dmJ9Nsn4kdfv2SOA/QlMVxXQ6Z+hICxruxEYYz5iL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBtc9XuNHcM1ZenNrAM//6TM9qB1S7QYGZgfWNzKmqtFOgdZ4R0bZBhhshBLYdPhm
	 zMC/2VIufBmNMbE6xkx4jw/0j2JTCipRtgAUTb2OziIbv8RpS9LPinNsusBxw+vQeo
	 dTVPITUPF0+MFAlHyaUgLXEruRP9YAuQzLHH2HVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/459] firmware: google: Unregister driver_info on failure
Date: Thu, 12 Dec 2024 15:56:46 +0100
Message-ID: <20241212144256.203245561@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 407cac71c77de..c82d38436b9b6 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -917,7 +917,8 @@ static __init int gsmi_init(void)
 	gsmi_dev.pdev = platform_device_register_full(&gsmi_dev_info);
 	if (IS_ERR(gsmi_dev.pdev)) {
 		printk(KERN_ERR "gsmi: unable to register platform device\n");
-		return PTR_ERR(gsmi_dev.pdev);
+		ret = PTR_ERR(gsmi_dev.pdev);
+		goto out_unregister;
 	}
 
 	/* SMI access needs to be serialized */
@@ -1044,10 +1045,11 @@ static __init int gsmi_init(void)
 	gsmi_buf_free(gsmi_dev.name_buf);
 	dma_pool_destroy(gsmi_dev.dma_pool);
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



