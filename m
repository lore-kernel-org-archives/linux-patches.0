Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C873C3458;
	Wed, 20 May 2026 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294679; cv=none; b=HPWjROAr3GDN7QbM4LzvOt/G6X7TQzACPRrwZvRb5SmloO+82seBVJbbZA/YW1VQOoUnCVGzkI6K7EIdumurHnf/HJg5bSiixbevT7hb50BHkSdBR3utlJHwuceka1xPVzIMuF0TIrSCjLjzh7Od/QiP/LfCmVb1qjAwvcBMgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294679; c=relaxed/simple;
	bh=jlX4HIRSkuQ2qm9aR6g7x9qMVFCc+cDOqfggpZCS+wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPoBleHf69rwSOeKCqgdz315ZxajR7MJ683maYbwiyfYODOD14WRR4u77tj4uTM1nrhWvwjKZ2OgFM2DxQbNQhQNtL8koAx5yS30GKwNhhArVVrxgrjLqDCXa/G86lmuWxx/Soc/KfiQVbFz/P7uAxKApVPInq1qFRiHRA6IwO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyi72T4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyi72T4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5832C1F000E9;
	Wed, 20 May 2026 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294676;
	bh=B1QIgliA26mV4bg4vdCkXaa+5oc/o6O8b/Yau1pjnOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dyi72T4w464MHv+7uxl7xjPqQWQQ3jp/Mw2nMpHYlCD3IqGT3iHPrY86mjH1XJJeP
	 9mxsKF/7WIF1ESMPG97PPmAN/zhz64SdBEt1Gm/bqWsJ3aJWEZA5puI4QlN8y5QAiR
	 6gnz6igT+TlC6CJjlcyEJxIgQ/XGopU+vjM3stZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0123/1146] wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()
Date: Wed, 20 May 2026 18:06:13 +0200
Message-ID: <20260520162151.113889879@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit c8f62f73bbced3a79894655bdb0b625462d956fc ]

When the mt7996 pci chip is detaching, the mt7996_crash_data is
released in mt7996_coredump_unregister(). However, the work item
dump_work may still be running or pending, leading to UAF bugs
when the already freed crash_data is dereferenced again in
mt7996_mac_dump_work().

The race condition can occur as follows:

CPU 0 (removal path)               | CPU 1 (workqueue)
mt7996_pci_remove()                | mt7996_sys_recovery_set()
 mt7996_unregister_device()        |  mt7996_reset()
  mt7996_coredump_unregister()     |   queue_work()
   vfree(dev->coredump.crash_data) | mt7996_mac_dump_work()
                                   |  crash_data-> // UAF

Fix this by ensuring dump_work is properly canceled before
the crash_data is deallocated. Add cancel_work_sync() in
mt7996_unregister_device() to synchronize with any pending
or executing dump work.

Fixes: 878161d5d4a4 ("wifi: mt76: mt7996: enable coredump support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20260131024731.18741-1-duoming@zju.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 20d4c8d5b3e89..6a0c199ce3622 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1741,6 +1741,7 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	mt7996_unregister_phy(mt7996_phy3(dev));
 	mt7996_unregister_phy(mt7996_phy2(dev));
-- 
2.53.0



