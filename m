Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940794071DA;
	Sun,  7 Jun 2026 10:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827465; cv=none; b=WrOTo1tahahxh/2Kp/ZvQQcwEY2VExVIyeQlgABySUqu5caX49HT5rcfj9hl3oR+AfG6N4sm0bk+QuVLjMDia/xABpi4wRagEhaO83YfaY0oxhz9sZZagJt9OznKZHBGkbrYUha3yHAGYxzYswdIwLwesFshNsv1H4puJStbhgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827465; c=relaxed/simple;
	bh=ATOx6oS6cCL6NVwTOagWFiT9R8uZOyadfS9FSUE8dz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I98j0Utdz92d4KC3KAdLwY1wiw2Yd3ZLLz/rJVsmuQlSGuJ1VqKu71YPQfmcDrigA7KvgBKbRYcvrsw5dHp14GSV/JDwcg/groYRM6QGc6evQqVCRDP4ZIIYHKrLHEr1YktlOaYAHQ4P95RJAHeTt5tl0z2NES3q1T3H3hQAivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXOFyXZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXOFyXZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C61F00893;
	Sun,  7 Jun 2026 10:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827464;
	bh=YR1YZKPjp85GxxBrbY/ANVoVMNNbGkPFJmvvdn0mJpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXOFyXZnE1dbuqZu5sgKtUaSS7etE1UjN1jM3jcaVZQMNbAgG8w7blK1DHdh1TxMG
	 3lm/RGJxBaM/LRIJ3Oaea4GZNW+gcRDzTLtlx3yBza//Jiv56xdfJOE+D3qNAyPjVx
	 y3YZFsxWM7Nm2Yr0ypL2SIo3l7yJqjO39mSfmVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/315] net: hibmcge: disable Relaxed Ordering to fix RX packet corruption
Date: Sun,  7 Jun 2026 11:57:43 +0200
Message-ID: <20260607095730.406714160@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 463a1271aa26eac992851b9d98cc75bc3cd4a1ed ]

When SMMU is disabled, the hibmcge driver may receive corrupted packets.
The hardware writes packet data and descriptors to the same page, but
with Relaxed Ordering enabled, PCI write transactions may not be
strictly ordered. This can cause the driver to observe a valid
descriptor before the corresponding packet data is fully written.

Fix this by clearing PCI_EXP_DEVCTL_RELAX_EN in the PCI bridge control
register to ensure strict write ordering between packet data and
descriptors.

Fixes: f72e25594061 ("net: hibmcge: Implement rx_poll function to receive packets")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260525144525.94884-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
index 0b92a2e5e98694..cf0f14aa014cf8 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
@@ -420,6 +420,9 @@ static int hbg_pci_init(struct pci_dev *pdev)
 		return -ENOMEM;
 
 	pci_set_master(pdev);
+	pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL,
+				   PCI_EXP_DEVCTL_RELAX_EN);
+	pci_save_state(pdev);
 	return 0;
 }
 
-- 
2.53.0



