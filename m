Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043FF3BE643;
	Sat, 12 Sep 2026 12:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215753; cv=none; b=fKxV5Vbo1za9x4oCQp/+1Q9mrJK5ahoSRQc6Zah2w1VE6EP00VtGtbLSZeJbaNewMTinLJyjKFHZnuDv/Pk9zOmXQ7sdJGluKlpJvCsT1BuufQPsqzqtk2/7G1BDM9UDfaOIrcMGcUEJCHQ8vS+Hol5E8jetfOB7uJvh3ibCcJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215753; c=relaxed/simple;
	bh=EklqqVn8NgLULMbYdtW/PIcU99p0RCVq9yR3vWSklBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj0HngV9fGMRXJp1K42Kle50EchlPf7OZWl1QDkgEYYCOK5NZi7g3kbX+OhKJ7+PgeYolrUu3G60XbOhoelAfCJcGpxuLctPo/5M7MabZH7+mGcl6UjgbKXfunSzGpy9AMPVaMO2sZa+SCmkf9ZQ4M48+5pwTYg8EcPtjTth1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j400tUv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j400tUv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BAD1F000FF;
	Sat, 12 Sep 2026 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215751;
	bh=jwQnvP6j6kzBdzfeYQnCBXlUeJyaKX8JjJoFwd74oyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j400tUv71e6GbPhgjbD8AFy7Ze0/UVDvT394f7Ra9TLzIrE2nqHlRvdlQHJb64hAy
	 kdiXCs451MFRIJTqK3Qkt6Siwh+rGATOqDr+EcZhWuPZxeGZ6Y3p1rr1GYWyVaNIqh
	 9jP3HLsHNeHOIH5OELJ04yEtyebFQLulLP0KcCYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0595/1376] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:50:21 +0200
Message-ID: <20260912065620.796207532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 282c38aece0de..c43940940aa34 100644
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



