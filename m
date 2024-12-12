Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C21239BA7;
	Thu, 12 Dec 2024 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022010; cv=none; b=pnTjTJjmxjleodDqI06U9/Yu0O3a3UDWKo3TpvXhAV4OWJOpwktPyjPY6JY1STyeHW62fwIO7zZmbcPdpnryt04gpykRtPiuGVOnIJJ7UoLAvPcNlCPVYx2S0gmyR7Ifjs9Prl0o9YQvFlT+8+XbpfVfqOkAFKU8QSlLPOeTIBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022010; c=relaxed/simple;
	bh=Ur0ov/XDhD0i06o/PcGuOJdWKPNobZnwWdWIXsk8zFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmiomYz7sdc2UJbDB0cssXVQyhH2/C01VZiT1kzzCKDUrb8ZKpeKHlEYCvAmYnbS9ytFckQh2AaQSshNzZNW6CNEsrzN+DNpzZzb/uKtvhTh7N9fOiaC3gtJ+a3OUoi/RkxCjccQY0f/oWHFdoOHOZvFxO2b2Bw2Aw24NXTOWmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x3l+JxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x3l+JxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68997C4CECE;
	Thu, 12 Dec 2024 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022010;
	bh=Ur0ov/XDhD0i06o/PcGuOJdWKPNobZnwWdWIXsk8zFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1x3l+JxVmpJ4fqCs+KO8XVuZWTATaNrkQVFmURrTKHz85C9KoAFjJQeLhKHNU1iD8
	 FTTdLlZez1gp5rInXfieUc9N7hcnYYM+vlSAYYWGD1ifX0HO/mR4OEFREpaRk4esuq
	 qwiZuBZtqMXwwkIL/MF7iLchnEs8aqr3JVILAcBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/565] firmware: google: Unregister driver_info on failure
Date: Thu, 12 Dec 2024 15:54:47 +0100
Message-ID: <20241212144315.122754710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 871bedf533a80..8c75308b01d5d 100644
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



