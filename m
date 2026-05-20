Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574653A4526;
	Wed, 20 May 2026 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297613; cv=none; b=Vx96bWXe9GmOInIXOJyzOC9NaQbz+48njJUWbv+XjWQ9Q7dEaciSKOx0BeGn98sgGFxFmQTC54Yv6AeWur2bGgAPeoGVowwPfXkKWxojkE6CpuT3dVAmztcJp4ClHK6lEzqEvkBn1TWlwB3v3Vozn7mwSJLunsQoV0An9kwnxe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297613; c=relaxed/simple;
	bh=EMjmzyVV3R8a6vdJ4cW9E/7zRKg8W2dwJyfcz0isp74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai0GnRQ8L8FT/ciOA06jhG2L1f5V2n57rh95aEHDwPBoeBOaP/VSNdzxijkZaPiwa+c5XMOXk0KbHN3U+iFd6i/II0QaNMNT5dBqZVi5Z2z/QjZciaMXGYGcK8GJoG5cPJiR2vrOJ5d+RYYP89A5ZTUcRSlJxRwrqipOr2GZMh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcIVK912; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcIVK912"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC16F1F000E9;
	Wed, 20 May 2026 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297611;
	bh=u6Lxb7fJeGatdN/kAnPrLXpT3QoDpLtDbi172IAWiqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcIVK912/TFi53skTRH/g1YLZlGJHUq4WdbL3HYwNtS7Nkqp/OOuFZrwDP+0Fbf22
	 SfXsnPx1goZ3wA19kXFCetipKxwJCKuNE74cvBInUAudai2MHyfx8yG4sV27Xw39HE
	 4RWG819Immfalksqd7vH7syGHIivXb1fXXWhHobE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/957] wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()
Date: Wed, 20 May 2026 18:09:41 +0200
Message-ID: <20260520162136.685570001@linuxfoundation.org>
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
index e26f8e9e4f8fc..ba769e6de76d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1732,6 +1732,7 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	cancel_work_sync(&dev->wed_rro.work);
 	mt7996_unregister_phy(mt7996_phy3(dev));
 	mt7996_unregister_phy(mt7996_phy2(dev));
-- 
2.53.0



