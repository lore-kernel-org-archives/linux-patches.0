Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207100;
	b=HvUCfKndqP/F8ZonoJXpWzUeiLd96DihnN6lsxW4spYHLZL+4b8r2HeDjtl3Z8p5xgDN
	 3I8DGy857W3ob3DI0tul2tw918xdNcIfcMMcsx1/MEJ9GwA5vEP4jbfI27DVhsrQetPR1
	 XISKJlzwNz4c0O8TuTA99sCZj5Ctp5f9VLNt/6KE4AW97BOy7Lr52JU4+DFdnsJzWVz3s
	 kpfFqTyuyWhEq7ZYu55DOrliTdy3c7S02bNrvLltIFg+VrKmQP6Cia5RkHTzeYF23/yV9
	 Kr3RuhAW2eFxiJxenesoOewxDJoX4luStQyl6OsU/bXoSOsLiyLSP0/sjbpvQrbxpPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBScRbvBWbZWhOjIyYO7tWZwYUcgenphww5bfRNzQ50=;
	b=ONkuI+9b+i7XUiSznG6D+CL7Ad0A+c4kg+eUHPNJ3/2Gb2pLqYTMpz/Y4cUQUL5CxRQ4
	 dIchGL1K9sXUYV8C+C2HjFv0SW5hBOzoearr0FLFY1Kr3zvrKy+jBHjMX4TaQIiTn0R4r
	 jzy7lG5t8nLGXqBlAo3tKc96b/55qwsViSURtkouGN/D/sxHEowYdrDCgmDIFuV+7AWhB
	 GKXJpLywp92SrI0qyVZ9ah6fi+7od/jy4kQDEjt9llQAx/o4FmM8qqBAOzqV1rycrqSAI
	 xttG1yLQgm7yMwwMbLXihSMn0k8xGuA/3mi/i2nnOPdCE+YP+KQsTiXWZw8vcNHPfKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBqJ9CPy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2A606A31C;
	Wed, 28 Oct 2026 17:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBqJ9CPy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4C1F01825;
	Wed, 28 Oct 2026 17:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207100;
	bh=cBScRbvBWbZWhOjIyYO7tWZwYUcgenphww5bfRNzQ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBqJ9CPyvkZaDVpRbUKXcUOdIAPMTjOno+PGXkqrsQs20ushwy8zwUXy2IqrD3k1M
	 pu/zkecFxdup+GIEGDnUv/dM/ROj1G7sRgCeVGNd613lP2WXuvMKc+vHBtoaBk0V6W
	 Zu1fB/nkHR8NoO8K1wNWDZaqLTl3OdF4O0XYroRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 25/38] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:00:12 +0100
Message-ID: <20261028165941.045179099@linuxfoundation.org>
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
@@ -115,7 +115,7 @@ static int tpm2_key_decode(struct truste
 	if (ctx.priv_len + ctx.pub_len > MAX_BLOB_SIZE)
 		return -EINVAL;
 
-	blob = kmalloc(ctx.priv_len + ctx.pub_len + 4, GFP_KERNEL);
+	blob = kmalloc(ctx.priv_len + ctx.pub_len, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 


