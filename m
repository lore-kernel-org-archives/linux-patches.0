Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D75926B2AF;
	Tue,  8 Apr 2025 12:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114944; cv=none; b=GK6BwINDGJKk4bR17St/w4UyGu1L3HzHs8O0tSEkQpAYSUpb72qgoBWWBa//rglhAGgQ0trSLzzokVUgprQ/r+P+OU/XHQvIAzwPP8oS9ni0XiGrSJllMYPkhdpW2KcmQip8a7UE4qNiJMLuYkC550X0QK1q3B7wpOwDeuM2HWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114944; c=relaxed/simple;
	bh=h5GTD/fmQ9y99ZmJyJLDenLIbF6tys+4QQEZKO/ps4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LL/Fim3a3dL5M107fmfjGzQhYCRlvbtKXqhhEEyjleMPKpdWCAdGVZu/y29doG/uHVd+mrIEtMqGd493W8cmYaYvIImBXrCQmmYx/yEpugdN0oq8/lD8md/f/xQYOT6mXmaTbWgrCkHyk9q9ioIGHkG6e1684Od3rRAcHueLFR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuMefpZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuMefpZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C74C4CEE5;
	Tue,  8 Apr 2025 12:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114943;
	bh=h5GTD/fmQ9y99ZmJyJLDenLIbF6tys+4QQEZKO/ps4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuMefpZnnEQNS/Xaq6QKqyWmXRiSV3GvK7C1e/Aq/fIooXpTvxmqpqrVvr4xMThEv
	 PqfYKfcgPRjYVMjhgvRKKQJs1Vt3GXSrhQTv37LlUvjz7xdaFOTNaDoCA68D8cGCSb
	 t6IFuRuyyzBpd0Q+BEjm2UJFHB+RiTOgEuCsaej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 255/499] i3c: master: svc: Fix missing the IBI rules
Date: Tue,  8 Apr 2025 12:47:47 +0200
Message-ID: <20250408104857.572630709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d6057d8c7dec4..ecc07c17f4c79 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1037,7 +1037,7 @@ static int svc_i3c_update_ibirules(struct svc_i3c_master *master)
 
 	/* Create the IBIRULES register for both cases */
 	i3c_bus_for_each_i3cdev(&master->base.bus, dev) {
-		if (I3C_BCR_DEVICE_ROLE(dev->info.bcr) == I3C_BCR_I3C_MASTER)
+		if (!(dev->info.bcr & I3C_BCR_IBI_REQ_CAP))
 			continue;
 
 		if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD) {
-- 
2.39.5



