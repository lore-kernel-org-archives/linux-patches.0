Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212010;
	b=kUYaASCwEqOUL2HgRjV0fUr/JMaAPWvcaZhtRJesIPRDPqG6xt+q2M7THbsVwqx0NLXi
	 7oYnOJwRCsHbAWqKJp/igFXf/OPgvHdqOqfel7aX6+Zb4vyILbLbSL0+PZIinwBrw9Bsa
	 VZGALpG+qslNTvx7+W86XaSmT1XI98G24vmu/fadN2atdNfEx0EZifm7aF4y/y3sb5q1/
	 EqZyopxW5Zdwo9DFAN54AxkS4riUpchUpA9VdIYeYMTIM4rK6mxyNfU23Aqdi1BFn6TVa
	 pLBDWwjGWuyUFO78GIJRALwUt/CjQn+Z15sHo/KSw2qA07TZGUYyFGe3pl63Eqr7GJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91IJlhXnLhn269IHiWmTDfBaY5TgR63ARtZSL6QMP0k=;
	b=qII/sLlThJp/ZD/BahENpI+e4Mgf5pHW4UR/6WNkY+4TcGEUXoFNUbhkRXYpySP/VucY
	 bLqwaonVPaAkN1/TbuP7umnyEvxUTg+848y0+yXB7KJXbBXWO1offgVgCmpRL5glQsX0N
	 i4nX44xzM4Oj+OO6ZD5CHdld1/PKOup+xPmPagxFq6VurX/bylu/SqAgvSttcYZuR4B8E
	 BcaQMunEmgw3nWm6PRlmnoPKL2sv7UOVqdYLGxu8kiXSSp1qMsWzeEpWBK/vRTfPm/MUj
	 8Tqj654hxguj18DfRmhFs5kCzGfnURMVweJcQfRO7lCtz0hgd3BASZuJK2hlb8YFKXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDKdqdSU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADDD606A31A;
	Wed, 28 Oct 2026 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDKdqdSU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256291F01825;
	Wed, 28 Oct 2026 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212009;
	bh=91IJlhXnLhn269IHiWmTDfBaY5TgR63ARtZSL6QMP0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDKdqdSUVLFlxb6v5Z0U4i7mGEWJ2Hhv8yXsaplLuq2ywrBhQy8s5eVE1HtgBq1aA
	 Caplc60E7cFIy0Yml30Kfo3HhCgVpRNIAfH60KnX/q9WfB9ZXQueTo1HNdYGvGdrv0
	 HqVORllbuxP50Malqrcw8PZA4g5ZX2HSnUWXOxLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 568/571] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:01:55 +0100
Message-ID: <20261028170021.515185103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

commit 11077cbcc2695f71c944a84a5f08c6672ab759f1 upstream.

tpm2_key_decode() allocates 4 bytes more than needed. The ASN.1
callbacks tpm2_key_priv() and tpm2_key_pub() provide the lengths
of TPM2B_PRIVATE and TPM2B_PUBLIC, so ctx.priv_len and ctx.pub_len
already account for the 2-byte `size` field each of those structures
starts with.

I noticed this while reviewing commit 114f00d738f1 ("KEYS: trusted:
Fix tpm2_load_cmd() boundary check"), which correctly reports
ctx.priv_len + ctx.pub_len as the decoded blob size [1].

Let's allocate exactly that amount, matching the data copied into
the blob.

[1] https://lore.kernel.org/linux-integrity/apfoKo-BdwaLXtkT@sgarzare-redhat/

Cc: stable@vger.kernel.org # v5.13+
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20260923173506.41519-1-sgarzare@redhat.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -124,7 +124,7 @@ static int tpm2_key_decode(struct truste
 	if (ctx.priv_len + ctx.pub_len > MAX_BLOB_SIZE)
 		return -EINVAL;
 
-	blob = kmalloc(ctx.priv_len + ctx.pub_len + 4, GFP_KERNEL);
+	blob = kmalloc(ctx.priv_len + ctx.pub_len, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 


