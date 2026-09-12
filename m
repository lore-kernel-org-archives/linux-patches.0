Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20C246BCD;
	Sat, 12 Sep 2026 10:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207709; cv=none; b=Bwu/IzK7hQRk4qQ6B2cChSTObm/H9GzfnzpO33ucPJGMAH9SnV00eKL9uIwyahm/kA330QUoXQgFKvUXwUevSxgG/zIhY3HvQjHverVSasgbAlJqZ17p7vkWTWOxAanRxq6wIsfp519VZY8PXbuhwWukbN+MvyEurpGeSzdExd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207709; c=relaxed/simple;
	bh=3eU6HR1jdmKT9vb3At6ndMMrvcs/aAZhkfWkMi1tIUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCVbWjR6vpyJiYDCRcwSYG53+3C293lTHDdKDHEB7L5dHavbpLf+2uvLolrr+R3zxo/eG2FipTMioLzCjMqHF7Vqn8HBGAoBkCKUbmPhX2X02Oigycv7Q7SGYjB3bZMNPfjk9xDh6y8bTlYzDmxnl/Y5HDUYXFo20XFPftgGTJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Joc5MO1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Joc5MO1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6591F000FF;
	Sat, 12 Sep 2026 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207707;
	bh=klIEuH8yKdnu6xaGh9ahsQImZ+kyAK4Hl0DvB1A6p4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Joc5MO1q1a+Eww1BqML2WCpXEEcNZSBQgpMwK1fqM94L4VduUYlhfKNiQK7OY3zsp
	 E70+gCHBl2CxwIOdcnxVx1lG5/7/FajnhopBtAY+55D85SKut1zbOXloZ8j4vp3YsW
	 xbQ1El9NF2ko7nJLRYjVyBOucmV2rGbYxhBb64Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0469/1518] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:43:58 +0200
Message-ID: <20260912065634.058253268@linuxfoundation.org>
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



