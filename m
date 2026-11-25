Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626096;
	b=Ohn4RjACEgR1ga6la2c+SbrO8tQ5GMzFbVKwxFPX9b69qtnDvFLGjHlJmPXXv2eERqT6
	 eh8gx15FsJs21BR2M6f3Jx8obSeFoVWuDL34NbPJLjKQ5wWhPq95JAypfldISkgvZwimd
	 YAcFBH+/kL6fjthCh1iXqqmt4YV7hVZLSJ81UYoGg8k+B8vxTfjedw6C0DKbXTMGU+A8t
	 xNOrataSvxfhq/wknUyARimPmx7kO+MQ34zq+4FC7ewYM1fRWPrKWOm9/hNXy2wOcCH7r
	 iPU8HhzYIxvT9FvUBTFLmgb1f4L/TRjJmGPFWoQUxQH2tTcv1ynQEsDEA2EjU8Ty3AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=buh712O8SspdDbTRyHhkFR8y7kUets46CXh/68QpVQY=;
	b=d2NRaXo29hXTp69i8FeDCbxheljdl46l8TJK2oqdyUGnTssnFC73MVcDUVhx2F8n25uT
	 v6ouc1US6IMFktlKMO2GtiGQMcZR8Zk7A66sgHcERaGrmwywo1r/hbjYYMhAnNecUZD1F
	 H7jVws3i35m/y95C3V577E79PSgYj2goIYwgxkRneJqbFtkl0gJpl2Cs03OgJnrw9+twf
	 96FW7YoOXYSOhHBBzVNmP1i1bt4GMvJsrLu2uwLy4M4ljTAzltJm3P6SxN4hcFC0OYMZw
	 pWKlAhFnzIW35lk/4OEo7T3ipVyMiDI6GrI86yKcuIb15pIHz3Zg1+d7Lyaa1hPpV5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4kxWBvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B37606A31E;
	Wed, 25 Nov 2026 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4kxWBvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE541F000C4;
	Wed, 25 Nov 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626095;
	bh=buh712O8SspdDbTRyHhkFR8y7kUets46CXh/68QpVQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4kxWBvEXK0XStA1cvB26NjKTvyiQ6KHsq5AJD6mUNZUc82+EmIWU9n4KsulplBIE
	 Jf0oAtX62M/c6xzlaY342/y93F233Ov1fx3oX0LcoNWqydGqfM6Mn64CVs/ESNCnyW
	 /v2VweXQJbK7mj1SJ5J1WtO2H8vwyqc3QN01PGmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 6.12 730/816] misc: ibmvmc: initialize HMC state before device registration
Date: Wed, 25 Nov 2026 15:37:58 +0100
Message-ID: <20261125143906.078932504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


