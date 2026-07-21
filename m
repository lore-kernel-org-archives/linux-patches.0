Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A16747141F;
	Tue, 21 Jul 2026 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664500; cv=none; b=kTNSs+mPDtztNeAL05UIh2WIrxeMyos8S3+oJ67fxR0qWHARIF1kBjyLVZ8G8JZWfpELiCh9MtSglMOiw6Hq9kBp0yOajZllWjHwGHNdnhfgvfjIoiymK244M61tCmgU9ZvMEmR3HNDOHw01lID+MnAKheUSEki6Pm035INRY0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664500; c=relaxed/simple;
	bh=rpN227LQmXckWKcgOPeS3ir+F/ICWaMNHr8rItjOWnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuuJnXU58SRBxg1UFUXARfevDsX23Y7+yiVeKirzcTRiwVCQSynMJLsht0e/Yh+8JlWs8iaUnEzybW4mw+nFMzHP0wbpx0nD+MlIwgb4DNWmuJtqAgujPiJ2VTrkqJog21TdFIBjvghpYFVK1WwUWeW5T/zFRxWVZryuJJBkmUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwJxg10/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwJxg10/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1042C1F00A3F;
	Tue, 21 Jul 2026 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664493;
	bh=qqwwVj+N2n08CUmVRRZNc8PI2oeMhHnXPkNWtLC2DtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwJxg10/vPYVS37+m+PerR6MmPfBOXG0JyLDYRReQemenA0ovonncj/6HrRL7mg+4
	 AnJ4JZ4CsRLIvT6Y3Ww6dvGJ/A9LitFgEu/x1ojqzJOqm8hxv+wuWNvW5Nsz9UFvkx
	 lLtSRZpm1yVZQBxjeVfRX/VWAv0oPHCHbbiTTUSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dionna Glaze <dionnaglaze@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1221/1276] crypto: ccp - Register SNP panic notifier only if SNP is enabled
Date: Tue, 21 Jul 2026 17:27:44 +0200
Message-ID: <20260721152513.398731084@linuxfoundation.org>
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

[ Upstream commit 19860c3274fb209e36ebcba562dc5da301a53cb3 ]

Currently, the SNP panic notifier is registered on module initialization
regardless of whether SNP is being enabled or initialized.

Instead, register the SNP panic notifier only when SNP is actually
initialized and unregister the notifier when SNP is shutdown.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 08f0e65e784c ("crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -105,6 +105,13 @@ static void *sev_init_ex_buffer;
 
 static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg);
+
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
+};
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1196,6 +1203,9 @@ static int __sev_snp_init_locked(int *er
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1792,6 +1802,9 @@ static int __sev_snp_shutdown_locked(int
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2488,10 +2501,6 @@ static int snp_shutdown_on_panic(struct
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2537,8 +2546,6 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			args.error, rc);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2555,7 +2562,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }


