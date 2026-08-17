Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7F9408617;
	Mon, 17 Aug 2026 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977746; cv=none; b=npEQ1d/EEPZLvmruYOv9Vp7V5Rori/RrURTVqfhsdguUjwKe8VjB8R5GOf0Ofs/XiZIocnbEcyl4yNDH3exaLuZEPPognBsZK92uuJqn0vMLffYssoL6RqHPhjum8L2VNvtOJMmdAEkWUd1ogI2pty08/K4JSnSNvFjjyrXef/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977746; c=relaxed/simple;
	bh=98M10K1Zo5L1dDK89/9MuHVNMYr+6BxzQUzMB7hCfEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQivbW8ncz/klBUI4VuRIt4qMntYgm5TY04AVGUdv2heuqICbbGCYuDUHpPi63RZ4xR2tpciqC1+OZDgbRHS/VGK8Lf42UzA1swj8FZlrcUPEz6Ftys3QN/8UN7C2MmFOxUdP28OQI1mrBwC6QkkoSqY/jLpUgpWtxUFoPf1iDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGCrcCFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGCrcCFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7881F000E9;
	Mon, 17 Aug 2026 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977744;
	bh=UXo5siybn4fHXQzXroGRz79D0oDJ9WRS9wmZvp83SF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGCrcCFaxzk6mQ/WW9FSqO0js7FmPBICkZ+PuUi4sOdm4vTbvzYGudX6WKadUVz1b
	 B+eOCV6r/371wvSGuOzZpt4Zby9gMAXXG/1t1ZV1a2hyxMoLotGBVpHmB7SRoHD6P2
	 ZXsvD+JfqlJxa30sgkHWRkMjG6GCVOkosfN2Fuq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 398/456] hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination
Date: Mon, 17 Aug 2026 15:33:08 +0200
Message-ID: <20260817132554.923445477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index e9518221efc4c..f96de071e9094 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -644,7 +644,7 @@ static int vendor_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->vendor);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->vendor);
 
 	return 0;
 }
@@ -654,7 +654,7 @@ static int product_show(struct seq_file *seqf, void *unused)
 {
 	struct corsairpsu_data *priv = seqf->private;
 
-	seq_printf(seqf, "%s\n", priv->product);
+	seq_printf(seqf, "%.*s\n", REPLY_SIZE, priv->product);
 
 	return 0;
 }
-- 
2.53.0



