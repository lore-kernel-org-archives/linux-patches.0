Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C1631E0F8;
	Mon, 18 Aug 2025 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524169; cv=none; b=Yi4Ne4x6xvYyQZ1Ujs/D4oYTaZ+5QfuFUq+gxrlogH+MDzwyBLGbQrHY4rUoMJ1FKY8gjXGtXUjifwz3W6fJmKQyzHHHQSUOuwmxaFNxwDlS4cWFuGqxdGJaqAa8kRS+8xXv4mGXIiqBBlznASHtBOV+c+BANHydKUjBOm19XbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524169; c=relaxed/simple;
	bh=IWUy97tXsIQ0PxhBhZqn58j50AxOUrHq3g09N+e+E8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQZDjS5CTkTHyyOm+XzG2PEMbbBQILDBTOiFU37ALB2wOMA9kiKXb1W5ur6thr9udj+CdtXGgI/g6BPZN59oFwAHJD74LXIvLkci2bKaVbtSBgn18cJTFTbhca53TNY/ZDhf6FTXWPAW+ob6z6IFlVMq59Wtd28A8dtEtTLdX9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnri0iFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnri0iFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8845C4CEEB;
	Mon, 18 Aug 2025 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524169;
	bh=IWUy97tXsIQ0PxhBhZqn58j50AxOUrHq3g09N+e+E8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnri0iFms2iiY1kBchf8qaj4yDZAmSrkFL/3aKLK8D0wCtWNaYmnSHN03BR6H7hjJ
	 G6NLpCylTOz3sqhhL8vX8DaRdt55fZfQ8p3MKTFcqrjZ+/JhGY6p5p2ZxBgbE4EanB
	 2KXMtPzm8ZmtRUS+h54GaOF6o3EOKl3n4EH0SFm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 388/515] soundwire: amd: cancel pending slave status handling workqueue during remove sequence
Date: Mon, 18 Aug 2025 14:46:14 +0200
Message-ID: <20250818124513.356659304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit f93b697ed98e3c85d1973ea170d4f4e7a6b2b45d ]

During remove sequence, cancel the pending slave status update workqueue.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-4-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 3b335d6eaa94..7ed9c8c0b4c8 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1074,6 +1074,7 @@ static void amd_sdw_manager_remove(struct platform_device *pdev)
 	int ret;
 
 	pm_runtime_disable(&pdev->dev);
+	cancel_work_sync(&amd_manager->amd_sdw_work);
 	amd_disable_sdw_interrupts(amd_manager);
 	sdw_bus_master_delete(&amd_manager->bus);
 	ret = amd_disable_sdw_manager(amd_manager);
-- 
2.39.5



