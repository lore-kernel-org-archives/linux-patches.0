Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D00044238F;
	Mon, 17 Aug 2026 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976177; cv=none; b=GAcG0Cy1wjj7zXojqeS8v/Q9DMtgvNbrB7Nm3Jsn+NiPih/xquOmZCW49KL8mgaKHWzDpr2d1WB1s60uMbwR3eVF13Cu16KCeRD52txs6cvaHSeXcEqOWQ2kmHiDJTcKZpvOwxpo79N1qJASbGrsM3JJ8hFu/YPJJQJPV43vTbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976177; c=relaxed/simple;
	bh=2bYKyDzKFeUpZA7zaJ4468UBRtVRl2r6g5jxV6DP6OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5nkUtq4Rw+uE114NQgkhP6AMcs8MdH3pOwZ1My9HRUzHLyEqNNgNIPgWAlS5lJrPs+6UWOhb+KOFQKglK3x+9mlSXPG4WX6DLhq6k4cblJY9IbkvnIbUBdsYKt9EPds2+llrSVWdhRgOY8BLn9j5jrE6g4eVNzICXrusXeNKhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCqIt3Jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCqIt3Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F301F00A3A;
	Mon, 17 Aug 2026 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976176;
	bh=0BSvWpboMOy0Bhc7yeVDxYU+uhLzGZldp7n2JjsQNDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCqIt3JgIXjgholG7lbIwNixzQu7ihogslF8AV9SIzWLXQLKR6U/LwWMydg+5moeT
	 EN8LplHRwPlJElYgm3AxOYvFG1DazcJ759H5ua9QYIB02Uw0GJQdbO6x47b4+n4CRt
	 yxuS0BQWJEq4GZ6gRm5ZKzzjFCJNJpdfqKzDGBH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/389] can: isotp: check register_netdevice_notifier() error in module init
Date: Mon, 17 Aug 2026 15:31:13 +0200
Message-ID: <20260817132548.391609040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit ef09a13c5afac41a3c4b5f22b8572820d9e7518c ]

Register the netdevice notifier before can_proto_register() and check the
return value. If protocol registration fails, unregister the notifier
before returning the error.

Align isotp_module_init() with the reordering already done for raw.c
(commit c28b3bffe49e ("can: raw: process optimization in raw_init()")) and
bcm.c (commit edd1a7e42f1d ("can: bcm: registration process optimization
in bcm_module_init()")).

Fixes: 8d0caedb7596 ("can: bcm/raw/isotp: use per module netdevice notifier")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260729085656.134523-1-heminhong@kylinos.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d493b66ae8d29..f23862b465ca6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1827,13 +1827,18 @@ static __init int isotp_module_init(void)
 
 	pr_info("can: isotp protocol\n");
 
+	err = register_netdevice_notifier(&canisotp_notifier);
+	if (err)
+		return err;
+
 	err = can_proto_register(&isotp_can_proto);
-	if (err < 0)
+	if (err < 0) {
 		pr_err("can: registration of isotp protocol failed %pe\n", ERR_PTR(err));
-	else
-		register_netdevice_notifier(&canisotp_notifier);
+		unregister_netdevice_notifier(&canisotp_notifier);
+		return err;
+	}
 
-	return err;
+	return 0;
 }
 
 static __exit void isotp_module_exit(void)
-- 
2.53.0



