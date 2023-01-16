Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A76FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155A3C433EF;
	Mon, 16 Jan 2023 17:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888567;
	bh=PaLd9uFhVdmkCveI9ysCyumvFGe0J9CvEbfEt36Jp4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wK8lEbZWTIamoL8gEVEqiEfrERlsgo8PhkwIFRUgLBWCPQpT8xWYGrYrPkrxmKf6I
	 jRAugS8M1wIR28MYkbeVDFcTEBtCD75BpENERzMD0VgFl1XXmkRaChgPA57jCnPaEp
	 +nE5jz6/G4bjCAUopOXMRDhW2GmbfnxCmeS0oHPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 055/338] rapidio: rio: fix possible name leak in rio_register_mport()
Date: Mon, 16 Jan 2023 16:48:48 +0100
Message-Id: <20230116154823.240235525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit e92a216d16bde65d21a3227e0fb2aa0794576525 ]

If device_register() returns error, the name allocated by dev_set_name()
need be freed.  It should use put_device() to give up the reference in the
error path, so that the name can be freed in kobject_cleanup(), and
list_del() is called to delete the port from rio_mports.

Link: https://lkml.kernel.org/r/20221114152636.2939035-3-yangyingliang@huawei.com
Fixes: 2aaf308b95b2 ("rapidio: rework device hierarchy and introduce mport class of devices")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 38d949405618..94843c8a687e 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2272,11 +2272,16 @@ int rio_register_mport(struct rio_mport *port)
 	atomic_set(&port->state, RIO_DEVICE_RUNNING);
 
 	res = device_register(&port->dev);
-	if (res)
+	if (res) {
 		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
 			port->id, res);
-	else
+		mutex_lock(&rio_mport_list_lock);
+		list_del(&port->node);
+		mutex_unlock(&rio_mport_list_lock);
+		put_device(&port->dev);
+	} else {
 		dev_dbg(&port->dev, "RIO: registered mport%d\n", port->id);
+	}
 
 	return res;
 }
-- 
2.35.1



