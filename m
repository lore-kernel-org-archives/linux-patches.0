Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A5333FE0A;
	Sat, 12 Sep 2026 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238917; cv=none; b=g2o5v5DcHt/lYxdZaX8Ni/HkyvMP7hFtm7plOWw3hK7uYs9N4w8MSSOBScpiBp9LM27Uq9mGnmQYhBrLyU7pE1zfbWPTm8f1qEmu0eWjxbKEQiJRHB3s64TkV1WQ1N/CqFzr93jlM5rxOH7kUjNXsPyn5Twbo86ETwo9cDrv9OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238917; c=relaxed/simple;
	bh=ZD6MlELQbn31bPPLEVgNpbefcIi1NrvFWB2EJrybLzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sur4775MOAHleNv+vBObiAw+x1mAm98qoK3Tw3xLTElP8yWRzvIfJnQQIiu/T8fmuU6StfclBbaprB6tvVWpdXeTlDNFlpTCJBmWcbAq8kLVeR7/FmJADDuocp15IQlPyJ4j17S1VXng3fmQein+QZiWjf/avksIvobtCiHnj44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNyR0qUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNyR0qUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D951F000FF;
	Sat, 12 Sep 2026 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238916;
	bh=Kv1jNFJ4Ybh5hIeqP6E4CpmvPEEX77/q2AeP0kBjOvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNyR0qUEkghiZDZnchfhGbNcvyVz5lOf6xZzq6jIF+NU7DFr8i6cJnwgxKYwC/wJq
	 S+3nY4lZjeAbZrc/AzQkCptuflnkrJnOFYGutZ0dyf+VTe1H3XGVvo54AiMBj7suPu
	 z/ZbFoHdGXduPu63L4HVibgrUjI7t7zZFnm08pxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 559/935] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:59:49 +0200
Message-ID: <20260912065539.652909243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ea57b8ddb1510..5b1d8c3f8bf6b 100644
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



