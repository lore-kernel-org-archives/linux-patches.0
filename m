Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D177B33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3A0C433EF;
	Mon, 16 Jan 2023 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884921;
	bh=2+MFT7diB5sMkEISLd3RnsiPr72cymYaKRU5CfejL48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MVoDxaF6nxwq5ZfMFWVnhvFksZzlcHotSujRR2+R6KVQwv73U8+1zJQpg/YoYQCP
	 NSkNlkerTXKWVI5ILtVnwyc5HOuvGtMyrG86z0JikyAzPq8b282BO2Y6M3jC1Pb2ct
	 V6eP8IwMY/J1ExmTt57F9a/yvTwzKFAzWIn3eJ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/183] platform/x86/amd: Fix refcount leak in amd_pmc_probe
Date: Mon, 16 Jan 2023 16:51:36 +0100
Message-Id: <20230116154810.606736211@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ccb32e2be14271a60e9ba89c6d5660cc9998773c ]

pci_get_domain_bus_and_slot() takes reference, the caller should release
the reference by calling pci_dev_put() after use. Call pci_dev_put() in
the error path to fix this.

Fixes: 3d7d407dfb05 ("platform/x86: amd-pmc: Add support for AMD Spill to DRAM STB feature")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221229072534.1381432-1-linmq006@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 439d282aafd1..8d924986381b 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -932,7 +932,7 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	if (enable_stb && (dev->cpu_id == AMD_CPU_ID_YC || dev->cpu_id == AMD_CPU_ID_CB)) {
 		err = amd_pmc_s2d_init(dev);
 		if (err)
-			return err;
+			goto err_pci_dev_put;
 	}
 
 	platform_set_drvdata(pdev, dev);
-- 
2.35.1



