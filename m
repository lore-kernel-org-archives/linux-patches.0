Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB36261B99;
	Mon, 18 Aug 2025 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525971; cv=none; b=YzL5ihnmMLpxn/EocBpTC0Qgt8dN7OHbfCZm1yKAG0iRcwpd97FTrwjnxn/UlYChsK93fzigJ2qaJF5PLm7M5eN2bjBCRp5+OIGPa45+s/65cTI1C4u8ilm2ZSLGN6gw5enTposamB2Ngzj7EbOXdS/vLVk4AJVppGZrz6xgbQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525971; c=relaxed/simple;
	bh=BXRk1snFcGmZh8uQ6yncQAZ83oDglGRol2ecss6Ltgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAIIS3STXFw0xGZPEw7ZXIwa2+jB3FpM2s5lz3yPt/tG7ugm9Egbd5B2mMGaTN15R7t8V+0BUxTlTMrGeeNEm/IBM77JFnIhCUgA49zCSgQLFaxrtamurW0ak3PDaXYT3qS76FqwL99zRWD3wSekoCZpBFrFpQPMOZnLV2YR9dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jo6AYWzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jo6AYWzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71308C4CEEB;
	Mon, 18 Aug 2025 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525970;
	bh=BXRk1snFcGmZh8uQ6yncQAZ83oDglGRol2ecss6Ltgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo6AYWzXFxmybBY7EJ66gqT0xn5evyvPdiI51PrtRM3uh0lNE7QTJ5RqJekLap6Vp
	 Ez+tdXDWQoCyWPXkrW5hC8Fh5ekK6dOe3vxEVhcyltAzkNATgZuZC+SSuzm11LMoqG
	 oymj7pC48YaVEh+70+KG05v+FK1rmu+0gAUtnbu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 421/570] soundwire: amd: cancel pending slave status handling workqueue during remove sequence
Date: Mon, 18 Aug 2025 14:46:48 +0200
Message-ID: <20250818124522.056723969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



