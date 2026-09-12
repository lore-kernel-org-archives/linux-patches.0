Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E8CA6F;
	Sat, 12 Sep 2026 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223553; cv=none; b=kMvrB6+WFtwd5BK8hcGIaIi4QD2fx2T3CMxuZQFeuAaVo5nfxaMq9JfIBuy57lCXI2llUbKN9qa4h4PwsEavlGVzZaPQCMSZ0dtXkfPRg0wKr8eMCW4rSJ74wIW4Uhh9BN4C8hX0z9cq73sGL+ICj8/166WF9aU3vd76LOSWpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223553; c=relaxed/simple;
	bh=uWOPbhVC+V/sprJnXN9FStJI76n9O53efQ1ssTSeNJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uojTyW/slh2r9SH8v7t8CdCuSbpPEXqgQNp2WQJHhFTxlN6pp/nXF0a/3UDfGug6bUTErWVOn/bMuLP0wTLfSmoUKGcFac6Sdvuh8zOZsTpN2wg5v/dm+REAYL8AQK5BNtAnj+3+DKnr4gur2aMWzPQtacBiomB6RmXPcDmybYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbOqaWrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbOqaWrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E4B1F000FF;
	Sat, 12 Sep 2026 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223552;
	bh=VKk25y0qcZw8VEkUjRPUjUMxdE9zf3arvxbn1rKpQ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbOqaWrwBlHSmMpjwaJrpK7KculBLkj59Um1KGXjT+2ee8wKzbKoCJF6bVSZpEkI/
	 OEoxoUfoRmlF5Xl9LXq8ok8JdljltY1767rAtZH1bRnigKwiJpSm2mYqpMbwblhJ/r
	 UT4juZ5Sf3rmDbpcT1USRV0PKNbZsQjFw4hC2Gfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0811/1424] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:54:03 +0200
Message-ID: <20260912065625.454542153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 45dfa004893dfeae182ec27eddbd153c6d4ddbf9 ]

soc_bus_register() registers the SoC bus before registering a deferred
early SoC device. If soc_device_register() fails in that path, the
function returns the error directly and leaves the bus registered.

Store the returned SoC device pointer explicitly so the success and
error cases are handled separately. On failure, clear soc_bus_registered
and unregister the bus before returning the error.

Fixes: 6e12db376b60 ("base: soc: Allow early registration of a single SoC device")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260615180746.713540-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/soc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 8dec5228fde3d..f215536340db1 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -194,6 +194,7 @@ EXPORT_SYMBOL_GPL(soc_device_unregister);
 
 static int __init soc_bus_register(void)
 {
+	struct soc_device *soc_dev;
 	int ret;
 
 	ret = bus_register(&soc_bus_type);
@@ -201,10 +202,20 @@ static int __init soc_bus_register(void)
 		return ret;
 	soc_bus_registered = true;
 
-	if (early_soc_dev_attr)
-		return PTR_ERR(soc_device_register(early_soc_dev_attr));
+	if (early_soc_dev_attr) {
+		soc_dev = soc_device_register(early_soc_dev_attr);
+		if (IS_ERR(soc_dev)) {
+			ret = PTR_ERR(soc_dev);
+			goto err_unregister_bus;
+		}
+	}
 
 	return 0;
+
+err_unregister_bus:
+	soc_bus_registered = false;
+	bus_unregister(&soc_bus_type);
+	return ret;
 }
 core_initcall(soc_bus_register);
 
-- 
2.53.0



