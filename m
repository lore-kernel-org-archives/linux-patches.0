Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0371472553;
	Tue, 21 Jul 2026 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664500; cv=none; b=kGvc+RzmhYbUSL78Vr7zNS0d3YFXdmTucYx88Nf0s5JeKo894zZVe/AFLNeRD0lhqwqGatZXuvo134hZRlrk+2YHv9M2zh5ZKK3/tN/11bMtaEWjsRwGtzhSeIRQ5yziiVb4QuuEwJh1Jlu2Knd3TvC/UfVUDFDFkw046OuLdZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664500; c=relaxed/simple;
	bh=RVlvhqveK7+FHRHU+NSpbUVkrHB+UjkR+hcp2FkH8pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdQzIhrVS9KmKEprEVNUG4tQV8+b+nNeMV8rakh+yU4IS1D84CmyILXKN86Ttr0UlN978LW7er9vJ/4Z9nqFB8nlg+v5TR5jYjHJxdf9gkoQB4zqAjeomNkdJeafeNAz+GkS/PGiIKG+WLf8G16VAJtwo50UKqIVtST2rTzh7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRN8v82N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRN8v82N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6998B1F00A3E;
	Tue, 21 Jul 2026 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664490;
	bh=oXbiDN1PFdMy3mDJJR3Vs374W5mIajl1RHXh8pi2us0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRN8v82NEyuO5L60uxtm0H1KV4Kta1fbgNDcolH/UH8n4EsMyU4bJqmhWTohTTEG8
	 mfH5HKEy/B2l7TzxBayGltlzTkLjYVeA1IdcYmYZpCaQJBWeGje3+QCBvK5iPj8b/7
	 1BHI1JfuPnweALIOsqOPhzYBauconqpOKUFN8UuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dionna Glaze <dionnaglaze@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1220/1276] crypto: ccp - Reset TMR size at SNP Shutdown
Date: Tue, 21 Jul 2026 17:27:43 +0200
Message-ID: <20260721152513.373835822@linuxfoundation.org>
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

[ Upstream commit 65a895a44e641fe47f3419b064288d1d713024a5 ]

Implicit SNP initialization as part of some SNP ioctls modify TMR size
to be SNP compliant which followed by SNP shutdown will leave the
TMR size modified and then subsequently cause SEV only initialization
to fail, hence, reset TMR size to default at SNP Shutdown.

Acked-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 08f0e65e784c ("crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1792,6 +1792,9 @@ static int __sev_snp_shutdown_locked(int
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 


