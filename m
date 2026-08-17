Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFCC439F77;
	Mon, 17 Aug 2026 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974949; cv=none; b=bVciagZoQftwyYhw4GdgpfAKKt1NkjBcr/zhtT6pXDQ3eKEotJgtWJ5p3696zVn87OO5bKtzKKRmL4EM+GAUe+FTUXqGsHZdm1sPn4gwhfNdPitHb2M3JWbxvKZJurmxR4cB25T8KE8/boAGTSW/6GSsfWdZ1+Fef9N4zJI3xKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974949; c=relaxed/simple;
	bh=yKmtvri3TRgJf71qfoaxFfKE/P56x3PZvfOsTMzlO4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajYQhb7SP15uNDmgBhg6Btrrp3BG7lKKJQaQKCvCU4o486EUHZjsu9hh2cwiTTk6uqgEBto2ecB+9NqtSmw4Q/gKb9q7nOMVGenQzdR2ZcASlvfM+DzbV7rq9Z1P0OuI4Kg1W8EdSvmSoEaaqCYQdLp9vAj9aApB51kgCADFNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUr8ei+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUr8ei+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC241F00A3D;
	Mon, 17 Aug 2026 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974938;
	bh=WA3cwTE0jSwoetOfm6RQNd7sSc8JLgq5t1lSrdytnw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUr8ei+s5xe+glA7vTPY2t3xPysQT5GMJqj5xokV0nMcrnyJ6tnaLe8ARiTg4hM9K
	 CxzMEWM1fTXLP4W67mfkGE0F/zfsjVZhEK0BFMs5PX8KDF1EvwpMafC0ScALsfHdlD
	 Hppx3rs/Nth3ZZRC+eyJ+CSSEju7lI5LFPZCFglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/250] hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination
Date: Mon, 17 Aug 2026 15:31:06 +0200
Message-ID: <20260817132540.825852323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Wilken Gottwalt <wilken.gottwalt@posteo.net>

[ Upstream commit 36c4d73ce05d1d8896c2669eb0730d35a02a2ec1 ]

In theory it could be possible that the REPLY_SIZE sized buffers for
holding the vendor and product strings could be end up missing the null
termination (for example by malicious hardware built on purpose)
required by the seq_printf() call. That limits the debugfs printf calls
to a maximum string length of REPLY_SIZE.

Fixes: d115b51e0e567 ("hwmon: add Corsair PSU HID controller driver")
Signed-off-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/anLj9gPWRoRDbQBV@monster.localdomain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 4681af6843596..679fb30983465 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -709,7 +709,7 @@ static int vendor_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->vendor);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->vendor);
 
 	return 0;
 }
@@ -719,7 +719,7 @@ static int product_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->product);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->product);
 
 	return 0;
 }
-- 
2.53.0



