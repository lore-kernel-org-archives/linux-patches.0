Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54709272E56;
	Wed, 20 May 2026 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301948; cv=none; b=G0/RcMR+fe0Hcr/HbYVFErw2P20d1dpDcOpCbNGsepnF7qDqDBraGyyeIJxDHOHSKkrlFC39o29Ou4RP+BAnah+FD5yTlyBVgT5BkTmnDuBNmIeqDk4u7uoLF1ileiDbXhNRl1gl3otp5AMW0UfgswVZpxZ8uvyqwlVccpnqfGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301948; c=relaxed/simple;
	bh=ZdXgRoi/fS2dVJegs5KaPEuG+RNu/4Zz3VNfnkzdois=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szLqepB27j4kuOSM+t3Qa6dMkTCcOMg/ieHiHJd0EvujlYNl5MXNGqJ1DKNP2kmWoKa1SX3PyPOdhbUuprznLLfLcqXEicndVWAnkBp0uoNRN90n4PyoORjNLCnybGNQNVJtM9U262PhNlmHL7vknF/6SFZ8ZdSnGLrEQPUAmdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L17v88YD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L17v88YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8811F00897;
	Wed, 20 May 2026 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301945;
	bh=2YAfLDk7udvkWSKdCy6epWZgt9LGD7hsYZV4BIIDvBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L17v88YD342OLd9hcH2YIpia9Tqu2E4w3eaFJTy7j6pyfs5h1ZR/hwVWtW0yPItUZ
	 pm9jK+HyvlvsdknMKxnKU51rbM5lCzUs4zVZE6dBapj8xvVowxybPZ7+H+ODJuRJKV
	 PsnGhsjwO14IFi/ZBdm/Tx9bujVOFUkNVDr2TqaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/508] wifi: mt76: mt7915: fix use-after-free bugs in mt7915_mac_dump_work()
Date: Wed, 20 May 2026 18:17:41 +0200
Message-ID: <20260520162059.417352956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index e9068718b3d1f..529a3640944b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1254,6 +1254,7 @@ int mt7915_register_device(struct mt7915_dev *dev)
 
 void mt7915_unregister_device(struct mt7915_dev *dev)
 {
+	cancel_work_sync(&dev->dump_work);
 	mt7915_unregister_ext_phy(dev);
 	mt7915_coredump_unregister(dev);
 	mt7915_unregister_thermal(&dev->phy);
-- 
2.53.0



