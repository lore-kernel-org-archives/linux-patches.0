Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732A35AC1E;
	Sat, 12 Sep 2026 07:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199135; cv=none; b=KJZqddloQ31X7fwWGlH4jFPqP0OwZw25NipWmnEGLQ5ZiSxvUjldhfkBGgraxFDYsvuuntJPs80z8QmBMc8UcPqirBaPSotD6DrtOizPrwsqHEGRrizHh7FLw33fSzxR06/TAYOkCV3a9esb8cYTAIgXQh2hgikoeGMk19n62mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199135; c=relaxed/simple;
	bh=ihnaQthkfVIWIcYjEiGbRgRKQOKksdPf3dQXgRI5gZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q12OxFwGBvE2PY0gU0t2xN5bQ6j9/JPpSYlDP71WdpiwFr0GWvXIJCsQvncf2BtnF1t1MTKnnycqmtrk1+FdB23E5UU44yjbGoix2YdU5QxJZ3X/NS0rlNURvXrYpWoiZOJOyldgdZ+m6JGOhf5fSlE68+5LA4VKVTs8MVp8g48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+e46h8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+e46h8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3311F000FF;
	Sat, 12 Sep 2026 07:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199134;
	bh=S3NjKGuRXuRl1Degf4t81YeqSev9+TrB88/mMzppxRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+e46h8fAXPM6mijzNCrRc+3Rm67+EOTzNxtHFIFWi1tfZOXnYw33+b0k0UtbppML
	 JqYofXA5SP6yNHIeopQBB28alTtjA184dpjYxjXAAdWQBENTmlkerfQ1YTChTdS3Mx
	 CrWe2xPKZlNP2q/xEkCQC8K0u71qdqYQDTFMaSb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0523/1815] driver core: soc: Unregister bus on early device registration failure
Date: Sat, 12 Sep 2026 08:37:53 +0200
Message-ID: <20260912065701.168228345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 65ce72d492303..af7d71393774b 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -191,6 +191,7 @@ EXPORT_SYMBOL_GPL(soc_device_unregister);
 
 static int __init soc_bus_register(void)
 {
+	struct soc_device *soc_dev;
 	int ret;
 
 	ret = bus_register(&soc_bus_type);
@@ -198,10 +199,20 @@ static int __init soc_bus_register(void)
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



