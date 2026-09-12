Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC26D38DC7B;
	Sat, 12 Sep 2026 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242763; cv=none; b=Wf+LpjFQh4nL2oGC+P/MpEy9e7KF9YVcGMThHhQYAPuJUon+8dzJzegANy31Jr2vfjArDaZPzlIi0JMIOw0I+uGuON8EM0eaNEwlugqAzF7Dc85rIRlPGul0kBGa6gzwk9j5AwsFFHga/AUDeiA4k9vdbRoBX7jsCBr3RA+NZLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242763; c=relaxed/simple;
	bh=d4l/S/Hguv+sGdR33/2AerMgORpdTDip7mS/6N7ATGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4HAP0iid4jjCrvD3mrid6YAifjWPyIucGzIVi4hg/bFR83+bIUs+IWr/pW0/nmpx3C5eplG6A4Kq3PwS+Ut3A6aTXLLOGAlTUh5LwTqzIfNEGbAOTBPTxnVl+yihjJ3ECxb8p0pFuDy0eI7HyXsbkvnoatl5GExVMt3ffwN1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0heya1CI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0heya1CI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312CC1F000FF;
	Sat, 12 Sep 2026 19:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242762;
	bh=RRSLcoi2rdmpK0X9TEr8vBEV7IE9kanULheVzz/BW3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0heya1CILZfFYwEgVeGXfTE/+D6TwPywEvnZgXgbD/e/O/wzzWi3Spopfw0q9333k
	 XqC6IUYffZ2IupadC526Xbf5xt2yiH7PkDHUg2tjpBAVdv4rhrCdz30nzXzdNiJaTj
	 QuaEzIj0fndKrAplKei35Q2SZZ7HCE+CUHlq/X+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 475/798] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 09:01:43 +0200
Message-ID: <20260912065528.030367156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 50b760f1e2a3f..4f9b0f849a8fb 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -179,6 +179,7 @@ EXPORT_SYMBOL_GPL(soc_device_unregister);
 
 static int __init soc_bus_register(void)
 {
+	struct soc_device *soc_dev;
 	int ret;
 
 	ret = bus_register(&soc_bus_type);
@@ -186,10 +187,20 @@ static int __init soc_bus_register(void)
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



