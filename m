Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0F46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C9C43392;
	Mon, 16 Jan 2023 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885892;
	bh=0g3tAZtvTRB1jTtiX10Zy7WeNjcE+dFdwc+AO9NB8Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdC2tXAdMjP9Y84GHzJErEE7dqbne/SUOgkomuQXyQoKdGcoiCdyvO4TzvaKSdEPm
	 rDH3cK+U71FvT5VrrRhwAHcZdFeiRNDkWXjBLeagyxRcaoWlgIku/1qZoH5lGOB1zr
	 xb0nXqM7shO0gFfbFmQbY0iowgSo2dtkya3PU7NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/658] mmc: vub300: fix return value check of mmc_add_host()
Date: Mon, 16 Jan 2023 16:44:42 +0100
Message-Id: <20230116154918.318360820@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 0613ad2401f88bdeae5594c30afe318e93b14676 ]

mmc_add_host() may return error, if we ignore its return value, the memory
that allocated in mmc_alloc_host() will be leaked and it will lead a kernel
crash because of deleting not added device in the remove path.

So fix this by checking the return value and goto error path which will call
mmc_free_host(), besides, the timer added before mmc_add_host() needs be del.

And this patch fixes another missing call mmc_free_host() if usb_control_msg()
fails.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221101063023.1664968-9-yangyingliang@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/vub300.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 5e1d7025dbf7..a02cc091a978 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2306,14 +2306,14 @@ static int vub300_probe(struct usb_interface *interface,
 				0x0000, 0x0000, &vub300->system_port_status,
 				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
-		goto error4;
+		goto error5;
 	} else if (sizeof(vub300->system_port_status) == retval) {
 		vub300->card_present =
 			(0x0001 & vub300->system_port_status.port_flags) ? 1 : 0;
 		vub300->read_only =
 			(0x0010 & vub300->system_port_status.port_flags) ? 1 : 0;
 	} else {
-		goto error4;
+		goto error5;
 	}
 	usb_set_intfdata(interface, vub300);
 	INIT_DELAYED_WORK(&vub300->pollwork, vub300_pollwork_thread);
@@ -2336,8 +2336,13 @@ static int vub300_probe(struct usb_interface *interface,
 			 "USB vub300 remote SDIO host controller[%d]"
 			 "connected with no SD/SDIO card inserted\n",
 			 interface_to_InterfaceNumber(interface));
-	mmc_add_host(mmc);
+	retval = mmc_add_host(mmc);
+	if (retval)
+		goto error6;
+
 	return 0;
+error6:
+	del_timer_sync(&vub300->inactivity_timer);
 error5:
 	mmc_free_host(mmc);
 	/*
-- 
2.35.1



