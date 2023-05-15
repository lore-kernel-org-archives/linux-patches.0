Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8DFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D17C4339E;
	Mon, 15 May 2023 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168381;
	bh=k7IX5QJR5FwzdJcUtLO9ziOnSoOHlK5R/5PqTBl+6kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bt7kGPzAXWXMkuq6PSf1faH6EXsQLSZcuStioiQtLgp//Y7JYmgQ5fZ7r1WwYeOzK
	 h3Up2OWXyJNai8ppVnEvtzynfBALnFBr9qqB+q3MaMO35l9x8xKNuCa1V9IzeBaQy/
	 0JEIRuH7jP6LhGFoUus7s+ExEOOmGoDnCPsGXTcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/116] media: dm1105: Fix use after free bug in dm1105_remove due to race condition
Date: Mon, 15 May 2023 18:25:21 +0200
Message-Id: <20230515161659.082605478@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
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

[ Upstream commit 5abda7a16698d4d1f47af1168d8fa2c640116b4a ]

In dm1105_probe, it called dm1105_ir_init and bound
&dm1105->ir.work with dm1105_emit_key.
When it handles IRQ request with dm1105_irq,
it may call schedule_work to start the work.

When we call dm1105_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in dm1105_remove

CPU0                  CPU1

                    |dm1105_emit_key
dm1105_remove      |
  dm1105_ir_exit       |
    rc_unregister_device |
    rc_free_device  |
    rc_dev_release  |
    kfree(dev);     |
                    |
                    | rc_keydown
                    |   //use

Fixes: 34d2f9bf189c ("V4L/DVB: dm1105: use dm1105_dev & dev instead of dm1105dvb")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/dm1105/dm1105.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 7c3900dec3686..df08297911546 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1185,6 +1185,7 @@ static void dm1105_remove(struct pci_dev *pdev)
 	struct dvb_demux *dvbdemux = &dev->demux;
 	struct dmx_demux *dmx = &dvbdemux->dmx;
 
+	cancel_work_sync(&dev->ir.work);
 	dm1105_ir_exit(dev);
 	dmx->close(dmx);
 	dvb_net_release(&dev->dvbnet);
-- 
2.39.2



