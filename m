Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF84C148;
	Tue,  8 Apr 2025 12:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116696; cv=none; b=LPii0tSi1BkxQtCtC+BdpKSrW1SHI988+4jw2Np5VzQnKPZ6HrnD1id8UD+K1gNXXDGSV0M6KWruf+YFeF1NcZwhpmfZtx2fnO8AfYLda9fYHfRwu4QJIDEU73FoXkqr31pimBopQPb0HqoAI2jMY/o8Q1BtGrINm7K3+kXpD4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116696; c=relaxed/simple;
	bh=kZ2+oqgFesKc5p5NI7I9XaRRvZFXOLGfAVY8HFvE/BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ/JuC9TYWSU7YjqnON1jrbKFRCuCqZkZa7tyW2rZupETVipwvnZmIlpUwtVcE+zMyJBqkMmzNC1W7i81sV5MeBo9kH1srRXm7ydX88ia4sP7vLdatLoE63IbnEnADEkmJpez/B3W1RMLGbNJvLwDJZmlARwkNT8fhBb5SQ0MkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixkVKTHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixkVKTHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5B4C4CEE5;
	Tue,  8 Apr 2025 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116696;
	bh=kZ2+oqgFesKc5p5NI7I9XaRRvZFXOLGfAVY8HFvE/BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixkVKTHFrB//cgr59SK3J85RtjJfc1L5U2ixizrZFHXZ8q4gLKJJeXhlg68mjb7Dt
	 Rzsuf7OaKNujuXxVkwodjwk2nruZ5LhrIFzL/2qiT6luNGGpge8iDQSPRAwH4da5Pm
	 hQVUbdsNcjiks1fvISRLvU2HgD1mdqvrvHs1meE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/423] staging: vchiq_arm: Register debugfs after cdev
Date: Tue,  8 Apr 2025 12:49:04 +0200
Message-ID: <20250408104850.806613963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 63f4dbb196db60a8536ba3d1b835d597a83f6cbb ]

The commit 2a4d15a4ae98 ("staging: vchiq: Refactor vchiq cdev code")
moved the debugfs directory creation before vchiq character device
registration. In case the latter fails, the debugfs directory won't
be cleaned up.

Fixes: 2a4d15a4ae98 ("staging: vchiq: Refactor vchiq cdev code")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-2-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 5fab33adf58ed..ecf6e9635a10b 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1745,8 +1745,6 @@ static int vchiq_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_platform_init;
 
-	vchiq_debugfs_init(&mgmt->state);
-
 	dev_dbg(&pdev->dev, "arm: platform initialised - version %d (min %d)\n",
 		VCHIQ_VERSION, VCHIQ_VERSION_MIN);
 
@@ -1760,6 +1758,8 @@ static int vchiq_probe(struct platform_device *pdev)
 		goto error_exit;
 	}
 
+	vchiq_debugfs_init(&mgmt->state);
+
 	bcm2835_audio = vchiq_device_register(&pdev->dev, "bcm2835-audio");
 	bcm2835_camera = vchiq_device_register(&pdev->dev, "bcm2835-camera");
 
-- 
2.39.5



