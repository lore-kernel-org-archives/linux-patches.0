Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208061;
	b=y0InEULJPTmXbeOs+IOnmHbj/VzCTT8BVt9S1J5h3QaQBVPd8avLE4burOdBwdEoNx57
	 5DRjhXengsJAsF2NrruXR9Z5kVjbFHuImvJbxwnbHnIfXHVL8n3JoChc6eAzADfjGW11H
	 lLN/M9p7BYgIxoPXfXggW7COuJeEUkDsU60DTS5qgqqdYs7tiqpDlKoeGWtvbWCsIEtac
	 yKuevdCq1nI93v8kkxGEw9Np/ND4q4CTvQVxL/ihuZWVSVje6xA25mevQkmMSAC3EwhfH
	 1a3jFZ5VoWSoqw2C82KKLwnXZqMJV/bQgLA3wMri2/NdqJ1YZYfOKcGXskp0WYJCvPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bU2bfFedQwtnH1RkjlWUe1z7NCkicakxYjdxEAHTruw=;
	b=zdH/nWE+3Oc5s3wcO5KiBi3ZHysijwT77O5HwtXYghJ0HvsPHviwEHflxJwdbgE9twS7
	 40zh16wtRT5Xg2MUD0qwisvbF2PuA8f3+LW2rnu+j8s4VHR50TA4xG361PWuYNSixoTM2
	 Yknk/G+JBnr4W9W6MSjWKOKAjp7QE8nsUVD18u0Z0KaXYsBLavpUWYyba7Sh2MmqFJk60
	 ruKdAcbQo4J9Z4Dl7PgY7y12Z+ul2VR/86CtVVh7caevbneO0mSAtWqjCFbNw8rHhHKxs
	 P3mFEVCoc3vGT6cVXTRtpzl3woF95gU21dzsrBKJ8FNP4rqNf0HDfgw/p/2GJZI4Yhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2V+pODf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240B0606A31D;
	Wed, 28 Oct 2026 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2V+pODf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037BA1F01825;
	Wed, 28 Oct 2026 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208060;
	bh=bU2bfFedQwtnH1RkjlWUe1z7NCkicakxYjdxEAHTruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2V+pODfsXigu9lG4VA/GthOTzxfQwHjqF7qBS0fxo5yB0WyAOX51reSreTwqdUNj
	 W0qCDXsDrnQHQQMFJ0S4Brqpv7+lN489HrpD/LZ/PqX856eNkFUxAHvKIbvAQYsiia
	 LWQ2Ph8nyoxXDf43+QARLN3tK+wmGGD6HeJ5TQFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 236/247] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:00:39 +0100
Message-ID: <20261028165953.010121506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


