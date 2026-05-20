Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F3C35AC18;
	Wed, 20 May 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297610; cv=none; b=e1WCK9SbadiRorJ1RDBzOhZrgpkBXcdowThDX9jQDY24xw7pundNcNzttZc9Xa2TZwzcbyQ7CGq61BdGaT8lUdOAFweTlJNmSGPqO4MWz2OV0lFq6tUypgAeuOx8OLeASbmoal+0KU1tYY+FASUs2M8YbDrZr0tBmj417R1TLKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297610; c=relaxed/simple;
	bh=zqbeO7O99kojDgQP83L9V2j8OSi0nlIiqgmmeZGXWXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8uJOU8FmrHti2qJP9TFrxPin3ixdXiKUQX41UtR9rSt5EYtjoCQvzKjJHKtovUBBj7J/H25O+zMsxloAwRtSUKG3m5hRXtWREBmUlSOmfWU0Wopsc5jGJg94F4cZY6OGHxe7vsZz06l9q0wV179tu5WFteuq5teD2GYW4jqFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEUUsxE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEUUsxE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413A61F000E9;
	Wed, 20 May 2026 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297608;
	bh=i/BRn6VBE3YyRx7bwGS9wNRDZno3XfiaoaAcj1LFDuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEUUsxE/7qV9DUl7Z/cM+S+rpqLzHeGGpn+81zXo+uzUgvhPDFWkD7/GSfaN+bTSg
	 AQ9TFGZ+K7G3TBM6PwgSyvjZPBt6bMXxQq1vy6CFSGFhvdRM/DiMH4jyeSn/YNYvmm
	 5hup+n8DbLw1UNI+Nk09yTtoM0HtAry+xosysAlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/957] wifi: mt76: mt7915: fix use-after-free bugs in mt7915_mac_dump_work()
Date: Wed, 20 May 2026 18:09:40 +0200
Message-ID: <20260520162136.663354696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 1146d0946b5358fad24812bd39d68f31cd40cc34 ]

When the mt7915 pci chip is detaching, the mt7915_crash_data is
released in mt7915_coredump_unregister(). However, the work item
dump_work may still be running or pending, leading to UAF bugs
when the already freed crash_data is dereferenced again in
mt7915_mac_dump_work().

The race condition can occur as follows:

CPU 0 (removal path)               | CPU 1 (workqueue)
mt7915_pci_remove()                | mt7915_sys_recovery_set()
 mt7915_unregister_device()        |  mt7915_reset()
  mt7915_coredump_unregister()     |   queue_work()
   vfree(dev->coredump.crash_data) | mt7915_mac_dump_work()
                                   |  crash_data-> // UAF

Fix this by ensuring dump_work is properly canceled before
the crash_data is deallocated. Add cancel_work_sync() in
mt7915_unregister_device() to synchronize with any pending
or executing dump work.

Fixes: 4dbcb9125cc3 ("wifi: mt76: mt7915: enable coredump support")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20260130145759.84272-1-duoming@zju.edu.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 5ea8b46e092ef..d2b163a5fce5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1287,6 +1287,7 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
-- 
2.53.0



