Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74A8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CC8C433D2;
	Tue, 28 Mar 2023 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016085;
	bh=R1zRr2EJy9Wv5fr1GIPxfmQgwsee4XkJvJPAu864KeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhN38WX6LUDoxxEJ/Tq369Z0VP+vaeoa9aSoUnzYbfvp5UlmDuYVn0WiL8nX4YeGs
	 yuu5NIPHm26wZEArvaFsrB7dQPPG3PK1aqTBIlO1yup14rHiTVQeSa1DDeZAYkD4a8
	 8P7ibxtFmmNPZVAFRqGTYEeqSkWRlG8GcmpaWnY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/146] xirc2ps_cs: Fix use after free bug in xirc2ps_detach
Date: Tue, 28 Mar 2023 16:42:01 +0200
Message-Id: <20230328142604.051316436@linuxfoundation.org>
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

[ Upstream commit e8d20c3ded59a092532513c9bd030d1ea66f5f44 ]

In xirc2ps_probe, the local->tx_timeout_task was bounded
with xirc2ps_tx_timeout_task. When timeout occurs,
it will call xirc_tx_timeout->schedule_work to start the
work.

When we call xirc2ps_detach to remove the driver, there
may be a sequence as follows:

Stop responding to timeout tasks and complete scheduled
tasks before cleanup in xirc2ps_detach, which will fix
the problem.

CPU0                  CPU1

                    |xirc2ps_tx_timeout_task
xirc2ps_detach      |
  free_netdev       |
    kfree(dev);     |
                    |
                    | do_reset
                    |   //use dev

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index ae611e46da6af..f8bbd1489af15 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);
+
+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
-- 
2.39.2



