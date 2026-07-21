Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FA47252C;
	Tue, 21 Jul 2026 20:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664500; cv=none; b=VhooZbdZMW9vq71nquwECy4JreW8uxhwhoq+ZhwuhKcmcmm3QQuT8RpkElcg1l+FP+SOoHyfv8KtrxEna5wk4F96ch9Cbb/BS6q9t84Eqm9bLewuqcP5OiD06lqORwpd0g9ocrJb5cTbIWLH1rHX5uyNlBGVMNcy+tdQmluzoFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664500; c=relaxed/simple;
	bh=yeXbFUUQ/xmRc+esBMyk9RkkDwVYlGrw/jEfzEMeRpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3m+Yc6K73HocyW3y7aJD6LOuwL2GiLGE1f7MHGaol556q96gTBmKO+YVHxSPG1RgOJcXxiy/xH+SqOnw0iQjmKd9t5mx5vo0rQwdOdZVsCXL1W/HLJi/qDFTZTrhO0/H5+bQ+fNYrGFqxCvbuuI89M4bcqqFoxM/1mca4GpSXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5ll3sQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5ll3sQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A211F00A3D;
	Tue, 21 Jul 2026 20:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664496;
	bh=30AuL7Qs8DR4Sr59dR/aQNm4mGzP/gnsg4zVAzdceXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5ll3sQDNOwIG7Xz60NA2NAX/m6aYHsrVYtPQBt4xPseu2lFHUhDbACHD9sf9DGcl
	 O7xrXGD0e42FxRaKjXD8hcuxi4sv/mfz678I5m6js9Ernrtz/nsqP6cdELsPElET5Z
	 m/vv01/RFBpBHwKDdgh/NIczuxV9pQgydxwkcbYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1222/1276] crypto: ccp - Move SEV/SNP Platform initialization to KVM
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152513.422634999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 3f8f0133a5fc9b32d0c308530320c3f2430ba5ab ]

SNP initialization is forced during PSP driver probe purely because SNP
can't be initialized if VMs are running.  But the only in-tree user of
SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
Forcing SEV/SNP initialization because a hypervisor could be running
legacy non-confidential VMs make no sense.

This patch removes SEV/SNP initialization from the PSP driver probe
time and moves the requirement to initialize SEV/SNP functionality
to KVM if it wants to use SEV/SNP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 08f0e65e784c ("crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1352,10 +1352,6 @@ static int _sev_platform_init_locked(str
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
 		/*
@@ -2514,9 +2510,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2539,13 +2533,6 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
-	/* Initialize the platform */
-	args.probe = true;
-	rc = sev_platform_init(&args);
-	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			args.error, rc);
-
 	return;
 
 err:


