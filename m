Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C0844236B;
	Mon, 17 Aug 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979860; cv=none; b=jYKH8j3ecU3K2F1D0cE/z8c+ysFtJ7mJ7E4lUTjUUW5qM5LdVbMaKFq/T2LU6cfBUgvrxd6wQ8r0tLykwvFUzKf193HdNS2DWR0ngAvGc/ZHPFbw2fF2PrlxEvERVzSsr0SZmn+RICczEKuYOauHmvM3ndOQYdEwYxx3DOtJ7Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979860; c=relaxed/simple;
	bh=JmJaRD4f6UOIJEwlksLBmrhqXmaD6TMananKCzdU4qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIjxRqkcYDkMjKJJ7UIndof0/liQ7iHmlFqmI7pqGKeqZ5B94Jwa8+5nSjurzdZJDy92efqV6biYKalM9wwUtOp/2KTCXUuRGXmhAElvcBdqtNg917CintiP6sX1mObWI7ZTW8Tst4PoJVGlZqwSFnrm4wbcEJTrrBLdUm44flA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/hTe+v6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/hTe+v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE26F1F000E9;
	Mon, 17 Aug 2026 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979859;
	bh=PTMKs1hTH5dYE+wTlI4wf19hXnQ7VrwPf/nhsV7FtDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/hTe+v6bGVN/QAaJAt3Kj70GFD1BWPIFLWITI3Dj2se443Ic1eD3ri0XdKiFYZ6b
	 1dSh8xXBfFNJwHPFTuopuPA3lKHO3KmLbQ9FQmp3AbitOEWUh8MD+DxzQf1PFM7vGC
	 QQM2IcS6jfPO7PFSIS2CMC8k5okrs0CzoHSFi0Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/609] can: isotp: check register_netdevice_notifier() error in module init
Date: Mon, 17 Aug 2026 15:31:09 +0200
Message-ID: <20260817132556.763092506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 6ee4849e4b789..645e0bd16782d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1825,13 +1825,18 @@ static __init int isotp_module_init(void)
 
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



