Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743D6472541;
	Sat, 12 Sep 2026 11:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210895; cv=none; b=PT8RExDncuGoXJ5N9fr3bnfAA/49hqn+bX/8EmgnkGOL18vU0Dmjfuroz1zIe80YTBEkVamY5yyrwfWjt9msN6kTJwoiVrTR/gl1Z9sdPs+FITAt4i+ifJEhIPynmRBe32SJ+77G6GNNfgeZz0mRuyLapV3DlPxibnTTb8YlNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210895; c=relaxed/simple;
	bh=qV/wm6DqYxulU6K1xu9btdhosk147aBNEWREUffx8nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAqzVUjGreRhajlpf/Qy8oogbl/jmOXmrPgjNDBIeC/FRNblJ7MfVTr06MeBkHe6qDzhxnYbc0Pb9yu2qoRfMEm3WpBh1H/2V+9NHzYU5sKBnHlU/J9bvrgjV+bbsUM2cbtvdIgaWETJ3klY4pr2B9Jt41Qkn6bz9yKLbdfuYqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVusi4nO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVusi4nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED641F000FF;
	Sat, 12 Sep 2026 11:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210894;
	bh=FoyDdNYZQO3M7sAAXn04AtHNnDFhwqKPMSl94rD+Lkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVusi4nOIuZZmdBh05oWGVaOSoxacHqgwJtcwQHP4n0dFBPkFZirrrogWjhpPq0zH
	 2I6T3xucuAqh8z6o0RA7tsS/zcyfgfdyX5stl5sYw5tRHou+/2ugPHQIT9hMI4ijiq
	 CCh3aYBOO8t0BpOGX7nJ9l77nO0ECWnSdghtwdZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Janne Grunau <j@jannau.net>,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1120/1518] nvme-apple: Require page aligned buffers on the admin queue
Date: Sat, 12 Sep 2026 08:54:49 +0200
Message-ID: <20260912065648.788934207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

[ Upstream commit ea2160c7b78187ea9ab08c3190eef237c4ee99a7 ]

Now that we have a quick to align buffers on the admin queue to the NVMe
controller page size use it for Apple controllers. This fixes pre-M1
controllers, which always rejected unaligned requests, and also makes
this driver work for M4 SoCs and for M1/M2/M3 SoCs that have been
updated to the firmware shipped with macOS 15.

Fixes: 5bd2927aceba ("nvme-apple: Add initial Apple SoC NVMe driver")
Tested-by: Joshua Peisach <jpeisach@ubuntu.com>
Tested-by: Janne Grunau <j@jannau.net>
Tested-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 16f092c7c4d98..18e877cec0e18 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1599,7 +1599,8 @@ static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 	}
 
 	ret = nvme_init_ctrl(&anv->ctrl, anv->dev, &nvme_ctrl_ops,
-			     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS);
+			     NVME_QUIRK_SKIP_CID_GEN | NVME_QUIRK_IDENTIFY_CNS |
+			     NVME_QUIRK_ADMIN_PAGE_ALIGN);
 	if (ret) {
 		dev_err_probe(dev, ret, "Failed to initialize nvme_ctrl");
 		goto put_dev;
-- 
2.53.0



