Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E268BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB7C433C9;
	Mon, 19 Jun 2023 10:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171776;
	bh=Jymx44z1iSgD3yMJLBhiJFfnCFgTfXcvMi/u8kKELJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwjuAS1MeOei/6IT+PyYw4NJ18aCQmI/MR6AmJp32TrBxFC8pTTG5Y/mFE5AbOqdf
	 F290zui3CdbWrW7j9+yqS8ByNXjIG0nhy+uD6nSoW8MoouQuFB//TgiwX91OkyG73L
	 waWUi5B5CT+p5GxNZbRDYkcPw3sKY33CsiUVAtSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/166] octeon_ep: Add missing check for ioremap
Date: Mon, 19 Jun 2023 12:30:30 +0200
Message-ID: <20230619102202.109872619@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 9a36e2d44d122fe73a2a76ba73f1d50a65cf8210 ]

Add check for ioremap() and return the error if it fails in order to
guarantee the success of ioremap().

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20230615033400.2971-1-jiasheng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index b45dd7f04e213..8979dd05e873f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -928,6 +928,9 @@ int octep_device_setup(struct octep_device *oct)
 		oct->mmio[i].hw_addr =
 			ioremap(pci_resource_start(oct->pdev, i * 2),
 				pci_resource_len(oct->pdev, i * 2));
+		if (!oct->mmio[i].hw_addr)
+			goto unmap_prev;
+
 		oct->mmio[i].mapped = 1;
 	}
 
@@ -966,7 +969,9 @@ int octep_device_setup(struct octep_device *oct)
 	return 0;
 
 unsupported_dev:
-	for (i = 0; i < OCTEP_MMIO_REGIONS; i++)
+	i = OCTEP_MMIO_REGIONS;
+unmap_prev:
+	while (i--)
 		iounmap(oct->mmio[i].hw_addr);
 
 	kfree(oct->conf);
-- 
2.39.2



