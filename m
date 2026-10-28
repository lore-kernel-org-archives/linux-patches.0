Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209842;
	b=YLf8gUTzMcfY9/HaDB7qsQP0kGXVVCxxO6UsMsJmY9UOusN7dDz4EimOPha/mspnsJEv
	 kKNRvzfVWrda1iR1TmFFJ9D7bLMAEpsrDH+EoMmE1oxAD4jff1CtToR0Tlpiiv4DjLRIf
	 +VxfzZ/dk5sR0XR8+nZzoj4vrET2Sxo0WBwcfTZg944YSdTdS9odY95J5ECNw8ztyhWe8
	 z4bw3JWDA0012NaAydBKiyZXded3NuLMWRIgRVmT6ZVOeqBMngfbemm0+27k/xP4pTpeV
	 BckF7vXRreCA/WhnUy+HZQI/BWYL1TLu04d7WU16PVsdJHgdB6gx04u+/dRn3TKBGVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRihIxlgiBNPgyjtQ7np4hbdLSKbk3++R6b+HNEJAfA=;
	b=at24WAXXsQ3oxeNXbz9DQl5t0reOBfJ3aAUBcp3flYeZt6P/m4KuORHfHsJ4N8KFcwxz
	 m6K9oaoXoC2Vsjv1seUopW5/UFsR8kmq7/Ni88l2uKMDZjrnjOG3vFxE82WzIYB0q9c8B
	 RZ4qC7pAwAFUAikzxpV+P9wIarJTUr/DcM9D+GN2e1sfmdc0hcEUEab33V1+ZuBBXFs85
	 8ffv9IgCxxeUYKaoASci5EFIsDatln2+Z8w4GJFUuA7cWOwsPl/wVMV/I5dbHtrWhpair
	 ywms83DNlBz0PHRKaG3FV8jn8jQe02dr395zr2ffT3FBnAwi6abtyeg3oQfjYhrBtzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnG1E07A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9719B606A31A;
	Wed, 28 Oct 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnG1E07A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69161F01825;
	Wed, 28 Oct 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209842;
	bh=GRihIxlgiBNPgyjtQ7np4hbdLSKbk3++R6b+HNEJAfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnG1E07Axtdg543X9U21muYI284+Zm5WG18MUJVXB5VphitLN8reNeZSATY2ifby9
	 aAnSisrW8mA004D1+L0gG7aioLNbsAwccemZK+PsUbInlZJtioVAxRTMgopeoAs8om
	 ii5pGBMISMPZAIonxnjqzdBTXNbCu5pGNwN/8ias=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 097/109] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:01:21 +0100
Message-ID: <20261028165944.638239431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


