Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3B3B8124;
	Sat, 17 Oct 2026 17:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258767; cv=none; b=metxbJTh8KmLit0dIewNfNbkJh4owM0JHjA1V8Xm0r1Jnh/iAmHgJqSf1VueTf917D6DIXawekcR1mICMVb2F8vRtt9Itqhz2OJMPm+KZxR63Qfb2H2fivC00APnBmTpCfo8aO7OruZtgvjdRA95M6W7R6B2Y6wGy+AFqFO505M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258767; c=relaxed/simple;
	bh=CnrYYf2oKmCmieOY7zRjnf7jFLyxixSwgqoK/yuETLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9bJIx2DzekSZYg0yAaSECdwBzucfgRtDJpS8fJqTaK08A1dCuY+3Gt1KlZyi6AXZsnOG5EyUqkdxoJh43BYKRprTGqrE89W0qFI+X/wvh6c6lLlkyLPpHqTh+AcYfPZrK3TJQz4DzFVXVVBHhxgeyUC3HK23wbEwZWqTwLH6ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcG0oRR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcG0oRR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E402E1F000C4;
	Sat, 17 Oct 2026 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258765;
	bh=Rx8RaeYV+eGuXBfpZgHERkE10/QxE70H3npO+agSIMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcG0oRR+4z/ktUSVpWdNkgwf2cUYpNEik9OFdoteJ0v5w/Jx5v/I+uwsVVGVgLPn1
	 x5BsLDh0/2y2tEpNCA/r/wnh3uN+3lMHC8QyFZEPw+CntR3Nz+QrOSNc/6/GJe5RMT
	 vWX/WHcHvoK5rL5k0/xDXGZki2C0BXU6rIuP8mXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0992/1674] wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()
Date: Sat, 17 Oct 2026 17:54:24 +0200
Message-ID: <20261017160456.581464451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fa81a1c30704b..ed066acfbfa92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -930,6 +930,7 @@ int mt7996_register_device(struct mt7996_dev *dev)
 
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	mt7996_unregister_phy(mt7996_phy3(dev), MT_BAND2);
 	mt7996_unregister_phy(mt7996_phy2(dev), MT_BAND1);
 	mt7996_coredump_unregister(dev);
-- 
2.53.0



