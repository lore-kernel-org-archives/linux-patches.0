Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704706;
	b=gqbZOs2DdqxjBklNOfzDrXNUDf/7LKTJ2uOBrCTPYQ3O0SsMRcX12HeNPa4lV1VM8guH
	 1Ts9+rKis/vdIh3fceaDUKR9ltbLUPyTY9RgPZgnqRHQtpcia+BSTVZn9pwxPrdBUHM6j
	 wBkK9RjUR5x30VBcLhRjS1eWUiJcW2vM42jOeq8JMA8eLaMh1BGoPwuRc7lDOyaM3WkUy
	 5mLGVqMANGv87guXt+hLVSIrWBIEppedyvsKElyBCUEJyWUTrQ1H0kWDD2bNL0lvZth+6
	 /ucx0YBRwoJxYDXeGho6twNZUSAtjml8AMx/lrj+/c+Q4n2ZHSf3wiR8VqlF1JVb0Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fMH0gv7ZrUvoU1lEkdNhb1ITFjmPN2q+FNOOJ/+23ok=;
	b=LToZjiB5xG9ayrgEjkN4asfqfxbn1MKhbMqlL8alsYZszaxEZ0A1BlEyWyTNA3DJnBme
	 lcgXuzV4wLztpvrm8Crn8PTAbr9hsMDU1mG0H0iJyCb5oaAjqTFo+mD32cO1lsCKG8pLJ
	 c2507oDJG+AqymFpi57oZFvOdIiTuVp6Ri7+f9IW04pcoudIPPpYupOwtxwUpW70WEQJb
	 HXKe1SSK+IbDu4d8vttd3S21noJQoeDEdAIfg3iljUQhbb+k/9lDyb3BOZfqF70c0RmB0
	 43sa5wBqlO0r5+gj1hbX7gECAMbqnh84w/4v70ILMO2DznrF5h5X84vdeFDDWWKCp0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSMVlC1X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684E3606A31E;
	Thu, 26 Nov 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSMVlC1X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4499F1F000E0;
	Thu, 26 Nov 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704705;
	bh=fMH0gv7ZrUvoU1lEkdNhb1ITFjmPN2q+FNOOJ/+23ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSMVlC1XgLx+vHXM/oF61DpWMzp+iJj6vrKpxjai1e6q8B2jza22gj7vNTCkJtqjp
	 zbRfVQqWghbB9aDCLjZk1kKl2Wt0LlbJJJzDQrMAaG6EqRyt4h/RywPaHmR4yG0g3e
	 4fdluy76t0Rjhwl05HcrPle9UAJ7JwfR56+y/qHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 5.10 216/265] misc: ibmvmc: initialize HMC state before device registration
Date: Thu, 26 Nov 2026 15:39:06 +0100
Message-ID: <20261126143620.336245774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2361,14 +2361,6 @@ static int __init ibmvmc_module_init(voi
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
@@ -2378,6 +2370,14 @@ static int __init ibmvmc_module_init(voi
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
 


