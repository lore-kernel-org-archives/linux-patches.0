Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210335;
	b=qBsUJBL3m6b7S7fBddp/llZvxZ1a8VWyhBgNT1QFRTzsbnH9yEFu0ykF2dSJu1GYABHh
	 QHLklmE6ZyA0Og65xzd1nB5dyQwIxipIPTRWWKnRg0hjXBqVcPR5Vv56HQWWJi6WjECb1
	 OLsNhZcxxL3Q9lM2lnIAdBfYVkJhAONo5kXMjMU2+N8n/MpD/mZjNk/J5t5++Gz5ircCV
	 zJ0mzIMi4vVbOjVun6b/XPixfgViamcFDzQXAcg7pNmc6rX5y07umRzM0IyFSZS81Rfho
	 napTAtOC1Cg4Ri3XPLOAhHIZ5ecVTY9ttUbbgo8Kva7wjeaWsNIqIVjequJDBR1nzEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHnDj9jiT738vE3vT6X5h5am1jsFRVjK5Fq8mheKugY=;
	b=Kq+GP0sj+GOHXLNd8keG6oOo8l789P0Q9QvpXXKXz2O5gbo8CnIMpojwxPPI1s3m+6/5
	 Xgf8Bx55pV9oEnuXWlcGDzupjk12RQwiPz5ssmkjVtaoW1/ph8KjNq29Tbe5qPTfVZvAK
	 smTxFmxl4l6ff8dEAEJxsOAbksOKy3J+Op19zM+hl5Hvgj6ezilclsY8/3EvTiLYQ4bcB
	 mVmwapdo6EmraySvU10a7BzpD/pR1gxN3fKLtZ5U0EprubSwd1n35y29aU+cjzufZ9vCg
	 /8S9WFZCGuQWvr+Wj91Kni9FycAZuq4RypsTGpVu7y+Fj8DjA5+F0EbWmuYBCEHLqIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBqc7tLK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A22D606A31A;
	Wed, 28 Oct 2026 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBqc7tLK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5821F01825;
	Wed, 28 Oct 2026 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210335;
	bh=uHnDj9jiT738vE3vT6X5h5am1jsFRVjK5Fq8mheKugY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBqc7tLKoHEYz6lNXl9sCpOZPJ7wbC6FfJmiQFOp2YYOtiFjSoLNwyrI66akN4gqt
	 NSdBVvBjbODnyiOPcyG/juYNKFqcqrevwlZAgZfQUdqrg3TenLy7w54oHO/hr61qrv
	 4FdUlEOeHOpk2dNl3rXKRWBxRTGXTanzVeCeYDrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 160/168] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:01:36 +0100
Message-ID: <20261028165946.874391261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

commit f92d0ccb05bf9089072cb067dda0dffd5394c4ef upstream.

trusted_tpm_unseal() proceeds to pcrlock() when the TPM unseal operation
fails. If pcrlock() succeeds, its return value overwrites the unseal error,
causing key instantiation to succeed.

Return immediately when unseal fails to preserve the original error.

Cc: stable@vger.kernel.org # v5.15+
Fixes: 5d0682be3189 ("KEYS: trusted: Add generic trusted keys framework")
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260912062950.279104-2-ssrish@linux.ibm.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -959,8 +959,10 @@ static int trusted_tpm_unseal(struct tru
 		ret = tpm2_unseal_trusted(chip, p, options);
 	else
 		ret = key_unseal(p, options);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_info("key_unseal failed (%d)\n", ret);
+		goto out;
+	}
 
 	if (options->pcrlock) {
 		ret = pcrlock(options->pcrlock);


