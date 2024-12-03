Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC41FF5F9;
	Tue,  3 Dec 2024 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240169; cv=none; b=G84ixPdC4LECeoVExrr43chaaBCTd7lgsBAt8IvI7ZYRkvWBQLI+NErNfPFAMD3wL79wmyjTVC4jKtC6sjBU1+4sWN9C1yPUcvMR9lstjXEEQ95eJ3jffhcvmfQYphAAqxFzYGlnDWoLK3O2k3OZO+hp7KVwEvrACjXzX4Gwue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240169; c=relaxed/simple;
	bh=fwwlWtjbPxxnuFgIUKHk5Khl/PL83S20D+ekPLrMJiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6wChAIk8QswDjmNsuUrjVFS0K027PEZD2v3+Qwflx0lW92SU4OlVuhgZoK9Zj7miTQiinm+mE/AYtbYivv6a41S1mndRvRA1ivOH/kyHihv/9tJ7MQdNptnIElFMjDmBokDQq1/T6qjz81CGW9urDFsZ1ICD6uEzyh9oy4HFfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYQCSKa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYQCSKa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC35C4CECF;
	Tue,  3 Dec 2024 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240168;
	bh=fwwlWtjbPxxnuFgIUKHk5Khl/PL83S20D+ekPLrMJiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYQCSKa7JusFTv9Wy+/lM5DYHLh3j7ngJzybStieS4Roj60F+TZSNryjYPPaMxDx3
	 t4MILMRqA3DiPKYMmSi68pIDkyv771pPsgfGdO5drSp1aUFboYG/2TJEb/vdVzim0v
	 Nw7e1VfAHnIGBv8k1KHQcCzqM4/sTJ843+tyB6yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Brian Norris <briannorris@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/826] firmware: google: Unregister driver_info on failure
Date: Tue,  3 Dec 2024 15:36:14 +0100
Message-ID: <20241203144745.299546716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



