Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFB479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED629C433F0;
	Thu, 12 Jan 2023 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533084;
	bh=kl0CodyMbrocKVnEKECy2YB75Dtw4XXACSGvrZ7Vjps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+gZENva6ugLuK2ieuZKEzfl64EOffaWpePqLlDcVoY1xxgf0BfbYXbn7u1vG84Mo
	 pq0JzfIxDLnXky/yJfRSSi+UlPf45+Gl4cIPReRwUHjFK5HkvMR+kD4rra7mqSLvNm
	 Fii8CY1FOH2J0Y0rh4NS4E/mAi4dP4g23F7GJ4CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Joel Savitz <jsavitz@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/783] firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()
Date: Thu, 12 Jan 2023 14:51:20 +0100
Message-Id: <20230112135541.220519421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7b51161696e803fd5f9ad55b20a64c2df313f95c ]

In rpi_firmware_probe(), if mbox_request_channel() fails, the 'fw' will
not be freed through rpi_firmware_delete(), fix this leak by calling
kfree() in the error path.

Fixes: 1e7c57355a3b ("firmware: raspberrypi: Keep count of all consumers")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221117070636.3849773-1-yangyingliang@huawei.com
Acked-by: Joel Savitz <jsavitz@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index 1d965c1252ca..9eef49da47e0 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -265,6 +265,7 @@ static int rpi_firmware_probe(struct platform_device *pdev)
 		int ret = PTR_ERR(fw->chan);
 		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get mbox channel: %d\n", ret);
+		kfree(fw);
 		return ret;
 	}
 
-- 
2.35.1



