Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E021A340A57;
	Wed, 20 May 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300115; cv=none; b=ZWBrx/PUxAJHjuUEviUevSVcdSxgkHlsSSwtLXxfyTX6kzxwtgjFxqD4FwPuTQ1etWIkN2NcAlHylG7vUUTDuabLqNBoMr8a3ooAU7gnG0qsKANyMCz9AKiwmKx6afmwsGiLPDC3cLujpwDxX0Ld3Q7YXU4tRAsbn7Mzye7ulVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300115; c=relaxed/simple;
	bh=jUR5tZTZC9msgWco17VWGu9LA/uQuaWSNG3PiWvrCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkuwORTftPovVMbvtLFwjq9A9SlaQ4WyFnekpdm7CgQi6MszrpqLgM9vzbpiF3plUGMqAtZkOk7QYRa7cndwFVe9p+1nyEq/1F7u4VyDzgbkGLwNE1nH80fil77sdw96F98v2GVe0gcN5jvgptoi3vf6jOzbKm4REksFb544mvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/k4Fjdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/k4Fjdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795801F000E9;
	Wed, 20 May 2026 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300113;
	bh=NtrRMvKRVQ0RiRshimCYXh3WFGwtn0Nn+zb0N4CrdNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/k4FjdhfJNrV5RWs+Dx6NmvFBsmeUYlAcFLryPJzRNT/Fica0FhDyZ2Gn0P9jayY
	 zYEZ6nHraMxgftZB1Gil+13sUDeKcFiMYhzBh+d0z0i2SUvTjTlRpbZflX61pkfH4n
	 r9ll2b3ULDhhTNbHqW+eq/VDXJXX3oMFhQNM1byc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/666] wifi: mt76: mt7915: fix use-after-free bugs in mt7915_mac_dump_work()
Date: Wed, 20 May 2026 18:14:23 +0200
Message-ID: <20260520162112.366984874@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 83f062fb95d5a..b2220ff7d6758 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1275,6 +1275,7 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
-- 
2.53.0



