Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D9269892;
	Tue,  8 Apr 2025 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113364; cv=none; b=t7Fsq+hDGKY1IFatee/C9npbcd8Wg4VQmYYluzb5qIhv+a/5ZJZ6PeK1QqQRjRmFnA7Io2hHdp0NmjbhCg0YP/SwgtmgQ1I3kVmmdRlTQpPWVq7UJ7ZGJ3CjpgiIOoJZNHr1EbYxVGyuME9HZ5pAwE+Pjz6aKCMfhKgJLf+Weik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113364; c=relaxed/simple;
	bh=DivnzFOKAd7ppnWTuhe0JY2uE65zzwpvAK59xr3SspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqhlivJSO+ZTnukGQmLzt71LRHpIvrkZLKsI7FzcylumApAcDnXUcJhR5OIVfINs23G0AWW8g80vLAAniiM4zmGQUJ5zShk+7pG0TcqqZKc/x4svFSjavEsu5k1kzzTJvumjnN906ndQi+USZ5Pzq6wFfTxypICEUoJ+x2ooQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHNmb+w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHNmb+w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4464CC4CEE5;
	Tue,  8 Apr 2025 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113364;
	bh=DivnzFOKAd7ppnWTuhe0JY2uE65zzwpvAK59xr3SspM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHNmb+w5VBaODCsZPdHYteu63PMFJlDZzSV0R+uTkDMln7NVEsV+uCz5HVBfoCr5V
	 C0QaljTOSre5XC67eB/0hAKxG+wDYRFk4/QZK4LTnJHnhy6KvyD+QcZiXDVwJvPWRO
	 pLPJVlRkm+D0GPzvaSSjd+MrFIU1ljr/TjvCsnFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/268] i3c: master: svc: Fix missing the IBI rules
Date: Tue,  8 Apr 2025 12:49:03 +0200
Message-ID: <20250408104832.069601977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 9cecad134d84d14dc72a0eea7a107691c3e5a837 ]

The code does not add IBI rules for devices with controller capability.
However, the secondary controller has the controller capability and works
at target mode when the device is probed. Therefore, add IBI rules for
such devices.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index c5ab39f1e755c..652a666909a55 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -951,7 +951,7 @@ static int svc_i3c_update_ibirules(struct svc_i3c_master *master)
 
 	/* Create the IBIRULES register for both cases */
 	i3c_bus_for_each_i3cdev(&master->base.bus, dev) {
-		if (I3C_BCR_DEVICE_ROLE(dev->info.bcr) == I3C_BCR_I3C_MASTER)
+		if (!(dev->info.bcr & I3C_BCR_IBI_REQ_CAP))
 			continue;
 
 		if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD) {
-- 
2.39.5



