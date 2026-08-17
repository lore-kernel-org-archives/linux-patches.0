Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59948432BCD;
	Mon, 17 Aug 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977988; cv=none; b=o2nVBVvIZbnAZT2fSwpxvT3tFvA1kNMopIyERyroeehg8kVVPPCxSF3Lrfg1FkmIEJKLCnecKRt53nnr4E5fDTXltVM5NtEx9B9dlgbIG2cMOv0H60SLRNWpZaxZzoqJwLi0iQgruaNRreDjaHx0AEp7++6JfHnceq+M0NGg8wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977988; c=relaxed/simple;
	bh=X7M+TCils6pfL6RNlfjal/aq9vsMqkNkfbURnKkGe/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8P2QRbTrR04hZul5H9eU8atjuXATM79kjad4mnH1ZMG93TVt8zbdveN9CyLWS7WAya9Vi5pWS9UoDBFCyBlVlUVR/+qsWIo3Qh1WypbzFAjJ11i4MU+PK4wX/nGr2lja55WXx+7hHBvjYpohuOJISeZo2Q4I2KP+NRgkFxzDCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yb9xKte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yb9xKte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F1E1F000E9;
	Mon, 17 Aug 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977987;
	bh=suJPYTtGW3mIVJBjEpifmES2oqTi08r2H3lUe17U1Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Yb9xKte+Vbh9ToYumfxGOtbzTT8NsYD2ZJS3AIx8RuW4mo/3JXLij8pfB7PSD39+
	 JU/QTECTJB/as7X37vdMpcCt0FdyrPFvSaKJKxeqcxEipb3iQKVvb7zcwXadakWqzN
	 pcZQUa5OOFakJ2riUupbOOCvXsAZ6pQic3pQtVZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/181] hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination
Date: Mon, 17 Aug 2026 15:32:36 +0200
Message-ID: <20260817132537.865136809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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



