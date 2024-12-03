Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2A61F4283;
	Tue,  3 Dec 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237880; cv=none; b=Vu//elozxsaJQx1L3FJ/pcGpJC7vyHrPGiQB+c1SxK9ZasmjhZIQtPfJ4L4IzEDE7J27xdP+Zd4FIpDq4chzu03kgm5IsMbM3B/aFfvAIkt1JzDa17Wtule1IRAWwIYJc43CdlTJ1wcJfcjD8xAADgJVOjgumVT73BPQPa/8kgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237880; c=relaxed/simple;
	bh=wEfd+0k6eiaXMiLnOjYEOuyMH6PZ6Al6+/9H5adGW1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9t0qjA9z2fokAzmdCPIhRKr5PDIF/3v+lQwu+8LQs9HGcH7T+Dfw3V76c6i5lNIa84a7ppQdW5pIqqLZsL5wGWGFs+sXpURjE2tEw863lS+n+iSVLVWYaAv46oDokk29ZduSEcr30uVrPTBBeenvarNodS2QwYMHna0jPIHNjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEOlrqpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEOlrqpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD65C4CECF;
	Tue,  3 Dec 2024 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237880;
	bh=wEfd+0k6eiaXMiLnOjYEOuyMH6PZ6Al6+/9H5adGW1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEOlrqpYoYMReeAn4MO4ru6anv+zt2fhxdIJQXfb4IfeWd11wXyCEe0oMUceQNuXt
	 NkfGrmHw5CLRbDDJTrycoEvPHTITF+6x68L52AUp+3j9KCnofir5WmXo0gnpOPnJFh
	 FsxlICzbjzeTHdUPcuG6uXVB+cZJjZJnosP72YXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 095/817] firmware: google: Unregister driver_info on failure
Date: Tue,  3 Dec 2024 15:34:27 +0100
Message-ID: <20241203143959.413727649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d304913314e49..24e666d5c3d1a 100644
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



