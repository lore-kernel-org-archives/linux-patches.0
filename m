Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705644;
	b=5X8kcBlL8/f49SLozQkS5lErnJhw0ritJY8XgrhzKjsyDJ9UC8m5kwHTWPe5QnmdYdAO
	 Ow4KKYGPmAjDApuUuuh0l54UpgUZNsL2wHwZ7LdcmiVSh1f8Z7Nu+gEwU8m/C13+fkdWY
	 +lAb+Dl0e1CZMkykPaJn730WhwwPNfEPE6ySRwiOM3rOnqiU6XqekyAtiZRxIAzrSKCsc
	 7JzU73OX3vjdphwP317XbqFgQrStw/oVmltSeIaLbhgPZIWNOtAuSuu5BxLRiOsfPC38z
	 /LHteOCmxrUfLUc2uAKb6PRjRBQr55mjz1/QVV72SZ09170pMkVX2wrb1nAHDnafeWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdsNumqZv7VNRXHobK6uw0dvh4xDi9xuCz6R2lMGOVI=;
	b=wLU8qBScTvbAluG1FlOkSrguGwaAFWRrmck6zZ5puE+01K3zJYsEeitvpNnV1QqrG4Dh
	 zNd3mizglRvwJCVTw+8bKy3naW1FeyQXblj/o1BALB3KWm2KEVEY5XD+pGDzZc6pJlVPw
	 Z0cFvE0Lp+J+l2q4iwqLw26aAP9w2/aEcloXNTc6cLJVZaTqP4OoOxnXFnn3CH3cIw8+r
	 57SvRaYkv6J42gkq3ZVHG2dUh3SQeHNtNzo7CPrn/ldK0NHAqXbuEL1AE5k76JZQsk6nP
	 /lghQiMfhL4iuzkBIFFpTnifrYUKiYaO0d4Ec/NtGQOgEq2McqdCFB8gq9ykUphgMZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijsniiR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32700606A32A;
	Thu, 26 Nov 2026 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijsniiR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612141F000CF;
	Thu, 26 Nov 2026 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705643;
	bh=HdsNumqZv7VNRXHobK6uw0dvh4xDi9xuCz6R2lMGOVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijsniiR28M5P+46AjPjrPVdSxhBQxYcYDOB9bVr/LPBU/b0N+5FUCVW/htPLUgJFr
	 kSbhGM+fTbQ4RO9jxSZYdH7AYJrEXx8TF035j7cygXJ5C1gs+x9IRQgXSRdKGjfQkq
	 ImXLeF35eSX3D27jJvW+GPwvea/EXiUPcG3yKPP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 5.15 265/319] misc: ibmvmc: initialize HMC state before device registration
Date: Thu, 26 Nov 2026 15:40:33 +0100
Message-ID: <20261126144012.728798563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 2022f170e5655c40b93ed98629f7d0adb98cea49 upstream.

misc_register() exposes the IBM VMC device before the HMC state and
spinlocks are initialized. A userspace operation racing module
initialization can therefore access an HMC through an uninitialized
spinlock.

Initialize all HMC state before registering the misc device.

Fixes: 0eca353e7ae7 ("misc: IBM Virtual Management Channel Driver (VMC)")
Cc: stable <stable@kernel.org>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261028044828.96177-5-yaojiale02@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmvmc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2359,14 +2359,6 @@ static int __init ibmvmc_module_init(voi
 	ibmvmc.state = ibmvmc_state_initial;
 	pr_info("ibmvmc: version %s\n", IBMVMC_DRIVER_VERSION);
 
-	rc = misc_register(&ibmvmc_miscdev);
-	if (rc) {
-		pr_err("ibmvmc: misc registration failed\n");
-		goto misc_register_failed;
-	}
-	pr_info("ibmvmc: node %d:%d\n", MISC_MAJOR,
-		ibmvmc_miscdev.minor);
-
 	/* Initialize data structures */
 	memset(hmcs, 0, sizeof(struct ibmvmc_hmc) * MAX_HMCS);
 	for (i = 0; i < MAX_HMCS; i++) {
@@ -2376,6 +2368,14 @@ static int __init ibmvmc_module_init(voi
 			hmcs[i].queue_outbound_msgs[j] = VMC_INVALID_BUFFER_ID;
 	}
 
+	rc = misc_register(&ibmvmc_miscdev);
+	if (rc) {
+		pr_err("ibmvmc: misc registration failed\n");
+		goto misc_register_failed;
+	}
+	pr_info("ibmvmc: node %d:%d\n", MISC_MAJOR,
+		ibmvmc_miscdev.minor);
+
 	/* Sanity check module parms */
 	ibmvmc_scrub_module_parms();
 


