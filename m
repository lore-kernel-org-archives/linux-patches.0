Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C818BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E716EC4339B;
	Tue, 28 Mar 2023 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016186;
	bh=yd9XK92dBvylX5xDPEBYWBCxoYN3rgxRUCTi1OyXLkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEzIFeKmnktsLjKpqoR3iKSgBGlyim24SF0ZkVe1Va6h7io8HI1ZMgQXMXhb1jpSf
	 hD1JpR69qP091wwOloppxmWyLjVueB+vVq3lVyqyE9Tj/ySonrKQnwXozWcOe163hz
	 DwKzrqV6+LgW7tflmwqWR/8VP7LHL/OkrCqrabIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/146] Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work
Date: Tue, 28 Mar 2023 16:42:35 +0200
Message-Id: <20230328142605.462968466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 1e9ac114c4428fdb7ff4635b45d4f46017e8916f ]

In btsdio_probe, &data->work was bound with btsdio_work.In
btsdio_send_frame, it was started by schedule_work.

If we call btsdio_remove with an unfinished job, there may
be a race condition and cause UAF bug on hdev.

Fixes: ddbaf13e3609 ("[Bluetooth] Add generic driver for Bluetooth SDIO devices")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btsdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 199e8f7d426d9..7050a16e7efeb 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -352,6 +352,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
-- 
2.39.2



