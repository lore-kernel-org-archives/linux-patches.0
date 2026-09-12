Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD473859E6;
	Sat, 12 Sep 2026 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229791; cv=none; b=fAZwNewdKCHZl/8SnYrQ39gPEFLAN5NpEm6t6SmMa4BdbcCyBOhBJCbmGroT8hIzoEuqlJDoFNgfo3S7FJRs3biOeLOjq4R0AlON4VNRvwFDuS7iUn+gaQRPkqoW9upwSduTqmy8E7j+cmNjrNLVFZx4goQor9a6KJ5ilVIxhnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229791; c=relaxed/simple;
	bh=f5kQPADyrWYI3qWj09XcwmnI9QjCrCBXHYse1lDpgRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCUKNGmQcz1NYVbdFroiiPPjOk19uvbmuAPYg+IL0qQyXshpFhWtYkJxWPu6dUpSz87//itLj5t4vb+EE2ULC6QjJHXu8jZ+uWMSitG4t/D/ln5Lri5LP9ChfLNFxswcEV8jjHf1lZDoVCzCWJinvlirdEA2QrdvPWgBibI3ung=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB3TXmyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB3TXmyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E874F1F00893;
	Sat, 12 Sep 2026 16:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229787;
	bh=X3VC6C35sqfmRZ6hQnMaCBWI2uRxVTNAdy1WXBtb6tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yB3TXmyWcMC/P9ERTn6Ki99ky72MNoTT9QksksKtzeIEwfz2C85uu15XBkQ2NcT95
	 i0qVYYv65P5hZpOMQJbUZg9o1gL+Xn73DpaG8338Ai6NyiL2gd2duy1VOX67IY6n1c
	 +Eyv3KDieLj5YMVuq81i+zSLORbDk2xsEb7zU9uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0662/1191] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:56:30 +0200
Message-ID: <20260912065603.126226902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0fb1d4ab9d8a6..7a4032846febb 100644
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



