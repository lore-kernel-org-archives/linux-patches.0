Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207103;
	b=ORsUdU/WvqEOhdd+tmYNHxk29C8UXvQlf3AFfTa7r/UoLtnk9b6zt3EwtuStMG1B7BmW
	 Z5XGjj9I7nHL3871OZS/y8pzcs36EY78UhAsNMsVZIUFcUluQcoxf3JWOC73ggIRb+hTo
	 YJcL1JQbdsfo98bhE7nkOtxITCCPeOiqOWnKB2lvVhKvLz/m0ezwuWp7mzH5JoLhhKaeC
	 0GavEzSwQ2SBKnv9VjapKHaMAnGHxwCCHYF8jmjAoRBjn4ColJ91KtTRK6aXnJ0/j+SyB
	 1sC1jUx1XMKhnRvDKIq6fQXeVpH07eXXjvYJCnwwEqUgB1cL8Lg1ggFtNd1AYhW/qFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyP5LZrIQ75rEydjvK1Ba0uZsrq6aL8p0izVpiR6gss=;
	b=Rb/qNgoDlBm7+0wpMZuHJtVGwFZQJLBdALfYmydS3kqtyeku0Cf3RYP5ySqMh0VfeF5L
	 6uWct8q6vxvVglBPcxH0a1Dt6n+sKHHMsm+7wc+4qB/xLZZdEylq97bAZwKSb46oNKLLR
	 VqRfYllD+4e4FBnHbeBU+zZNDbIQH4S+VQwjHw1N0G/Kx5dNwjYhkiVxjeuw7o4MX7gC4
	 GNk3qNH1RyR6WVnWtz0MWRplh8MD9csUfcilxmdLZI5obJyNEu5+H9o6VtFG4+wy7HMd7
	 0GmOeylXhzuuMqGnJjF8lXX5Ir0XK+g4KWYzTm+wwshTdMXCqXI+QYDIZ57Jpf33rgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+5Y2oFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15F2606A330;
	Wed, 28 Oct 2026 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+5Y2oFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423B21F01829;
	Wed, 28 Oct 2026 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207102;
	bh=jyP5LZrIQ75rEydjvK1Ba0uZsrq6aL8p0izVpiR6gss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+5Y2oFSJ8KgTA1gqcXIDfXHVa18kHfNNbyfSQnqKSyHJ0qMAbfz6S40C/24HX8pc
	 84/r1X/tuOZgMZ2lPH1AtBjN1UcJj1bmPY3r521SIHaq2wmoNSORgk+ME2MtfXVEeB
	 0IgGsY+epOi2sQCElZk9VWomUHdwk0euZp6xo18c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 26/38] keys/trusted_keys: return immediately after TPM unseal failure
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028165941.069218448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -923,8 +923,10 @@ static int trusted_tpm_unseal(struct tru
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


