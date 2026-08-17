Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12214322E5;
	Mon, 17 Aug 2026 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978504; cv=none; b=KqkZbpKlQ7j1kYUaxros6v+d+7MvcMCieGA1V58NNybdoEkWZLn9kZx8o8ATxjEWLvKSgxuse/FmTt2dOfs1GFB/p2hdUlfm4QSUYWAwtEeDV+LSFDcRGdFQ72jgKq9etPGMio6JIVCAr+duP3Qk1gjMGQ2QsUWtRMz2a2IT90A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978504; c=relaxed/simple;
	bh=7Q6KCUsUgI+pi9xFNaalUQ7x2pSamzHPfo9hpBK2pIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA+RR3gYZz99jB/vrYHfffg0h6cjXL+CeE15D65BldU+jXwBlyFzZAp7FeW+14yqoZ7fJ4jKOGHkMKdxfKqEOCStTECXBxiTRPJVONjTJhhoe0KV3bj2a++Ouswpy2WmVfuKj/8w8PKxVW4bjkUkOXPzySuN5RiOvjaKCXhWwKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhhwXE6R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhhwXE6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2365B1F000E9;
	Mon, 17 Aug 2026 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978502;
	bh=aYTWzkKtycmAMGJh+UkeNJ0UAELUmFyPWWW8Ym4OZcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhhwXE6RC7k7pnAYLp7/Qar+raXMiV0MHegOEJht3B31NhHDhZK2h1PAI2EfEN6dO
	 871a2OH0z4ZsdTrsI84hnhGZQDn509Tj7h+98qBV5THZLy3s5551WQce+xmLub0RTV
	 JMV6zD8tXDtvAmlzxgpCI5gSxULSCJ8JTpVIVqJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/156] hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination
Date: Mon, 17 Aug 2026 15:33:13 +0200
Message-ID: <20260817132536.895221882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
index 4ab73bcef1d12..61d1b22bc63ec 100644
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



