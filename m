Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623534;
	b=0KDGCtWH56mW4ApUvkKjPo/+0f3eYRMU+hnReEqusgLvt3FBURPGGRnjXlpNfq4eXdfm
	 adQ3ajGEvzAo8BLQ4SR5vj/soTi790zib7hc4oaM6w5qs3iZgb6Gdr4E90g5yERxihJsE
	 tmKnDIZB9bHgk0i5aIWVkUqXn/wQzDzFrraUR7olZJSfWELnbYBMqF1WilBfY+DgGJp1d
	 BK8FF46OVLGOhUonTi7GxpNMAG4BDzUe8JEze3FL47b7SF1ywwWTPLvpnpLSP3qhJXg5S
	 Znu54jlFTB+caSJ9b9hQwlnkSF9Y4cdguOkLk5VA8/IYWi6eZnKlzlX1taJ3P0Jftvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EhY7F4iNTrk222ygMng5qQku7j0N5LdaPn4cxQK98Bs=;
	b=gXOHqdxjrfdGQbqknusTTNxzK2iXAGb91pXfeJmqPq1cW8xU5SL93EcKS30mXW0s8p/0
	 +TNEZoKkPzCO2mt/yR/7tavBINwkfHIpZdwn65O4PPXis0+uqECRKa0PmAk+03VG74BB0
	 ef0Gpg3JEXvU2I8503/lgqjaFyqqqFTXQQx0ZiapXcQsc5v8jU+Oy1xZKFgteHax667je
	 0xFb6jA8Mr8derKF5FGgtTrix4A/G1P4OxM/EUS1Fknuk0ekG61dAnTuVJUoTZvuw/H62
	 HKlVN12sEGWGsNN/Qtj9GCKX3ragpaMKXy0yDWGaJbYCmwfapjr9OZZZr8DmGRU8c5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kd8z9r/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF72606A32C;
	Wed, 25 Nov 2026 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kd8z9r/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716231F000CF;
	Wed, 25 Nov 2026 16:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623534;
	bh=EhY7F4iNTrk222ygMng5qQku7j0N5LdaPn4cxQK98Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kd8z9r/HGePYz7jqusHUedwhKuOIZWfzaintV4qTgnRY+dU+MEGVmVPzlPfQ3w27t
	 /BclvN2hyhuZrZ7ShctogroCX2kdimuJM4ssa22jgG3jni/B1TL8BMeRBZzlMrc6K2
	 tdIikrQRxqTKC2dZv2aZV7vR/qKDHtNIFH7z3HNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 6.18 892/990] misc: ibmvmc: initialize HMC state before device registration
Date: Wed, 25 Nov 2026 15:37:39 +0100
Message-ID: <20261125143842.906031875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2365,14 +2365,6 @@ static int __init ibmvmc_module_init(voi
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
@@ -2382,6 +2374,14 @@ static int __init ibmvmc_module_init(voi
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
 


