Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30C2C433D2;
	Wed, 28 Dec 2022 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240735;
	bh=B+qOLWrrcjScKG5mowKSnO1AwUThhJxyTge94gyLfJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDi07xQgteeSjew+eyGdEnEQBn7Mx7ynh7erc99M757M4BYZ/O+JWfyl+MBNbHF7Q
	 f2ABWEy35cwdCQK8Rq791ft1SfLVtMxga1m52b1rPTdWrXtfEzZzzkE6Y8+VVpQk7t
	 dykqwuI4D0Yz/lyAJU2LKH9+rYFDovb1zNrO2N24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0161/1146] rapidio: rio: fix possible name leak in rio_register_mport()
Date: Wed, 28 Dec 2022 15:28:20 +0100
Message-Id: <20221228144334.532988647@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index e74cf09eeff0..9544b8ee0c96 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2186,11 +2186,16 @@ int rio_register_mport(struct rio_mport *port)
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



