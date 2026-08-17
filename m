Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74241F5EA;
	Mon, 17 Aug 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978137; cv=none; b=TiR3mSETqX1QGsUonflrMy2pBgunr0XXaF0t0JwG9vBRtrV3Z4BoWeMdk/bmHo+0AVVMoUCMSD283JIllduwX6tNjdJ6J0SHvUT0kzPK9deX6FB5YJp2rkpWqyy/gnL17o4TtBzp058hLOsw2dSuEMTulY208oEYhJFhExKzdhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978137; c=relaxed/simple;
	bh=35r57YEhN8MD5Q1sfB4G7RDmbvPmLo30U1mYDIKTXhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjWQx8jAFq0MAqo1ZQVOg9ORjA5Rk6V7xjEGgoGP763enDbklPPMKPuItceGxx1ijorAuAM3yS0t7WoXBsOq1+MRpTjDElgf01foP6C48vPu+hUEE19Jn9KAv6mlzBZlf8hTTyObVbX1Qn2dRGTJ4+eOD/Pjt7dk2XmplBP4r2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJzhohPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJzhohPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEF71F000E9;
	Mon, 17 Aug 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978136;
	bh=LcJcmU9V6cLxwGmqDRy0Au3uKaB7J54OXNRVdZqPWf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJzhohPAHwGl0HTTPlhM/7GoB1ZTc0KBO53cVSo6PRIeLeRI18byCRXXSFCDNvDgJ
	 3kFjRcxIl8fsmS/4IHSOf8WmZyL3Lo3sL6b6boyKSdGcr1Uy6VGSzgM06FmXnDRire
	 QKtiAyvJ8UDm0RzC+qmu/8lZ7+i6X/vwiELx4VtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/181] crypto: ccp - Abort doing SEV INIT if SNP INIT fails
Date: Mon, 17 Aug 2026 15:33:27 +0200
Message-ID: <20260817132539.968949017@linuxfoundation.org>
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

From: Ashish Kalra <ashish.kalra@amd.com>

commit 6131e119f5799bec55535530fa2fc44f5c7be1f1 upstream.

If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
be initialized before calling SEV INIT.

In other words, if SNP_INIT(_EX) is not issued or fails then
SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6e08378eb5fac..d6a0773d6da8f 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1118,7 +1118,7 @@ static int __sev_snp_init_locked(int *error)
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
@@ -1357,12 +1357,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
 			rc, args->error);
+		return rc;
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-- 
2.53.0



