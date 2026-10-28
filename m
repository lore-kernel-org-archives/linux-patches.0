Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210332;
	b=LDvKGpeO0yqNYKs0TjNti5p14DlNLcuB7ZyubbwiD0DZqgTryHs9OyMSx1wPwVZ/kF4B
	 fvyFwkozo7U+jojeeYYNWfVsaqmW8lTH2rxXgL2cmAiSvLzCtI/viGJGF8QWBU793og7C
	 OQyQiiPfDyp8mi8D+Oz+mpkuDS/7otjV+LM/ozqzpSta10/xW1V17Z7hwg8fRQ56Jukks
	 Wy+2ln4T51MPzzC+fnjmlJTmg4uiJN+g2yp5Yslo06pgthpS82LhuY7g9Kw+zWfEeoe6S
	 uFK3buMDJxDENojfbkUYKoo6/sklhjSVAtzKpa7ZAKQv12duKYA2gPw8tJaqb5RwiQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tjKqjj9CT7GMonJEswQMJlZpU2G8/RQUWcFjUKC5W+I=;
	b=NT+QF880fwLEhojtTbO1tuBGi+WTaUZXTLHTaEizKSVwGH6LysS0gS84R2oOcLkX5ndf
	 jqr2u+E6iqKw0nzgDHvVhI7As2+qgCpf7l8la0aCxFQKqIV4g4KUEYoBxZ/nagyPwdNnP
	 O6YhYU8Chq3R5PbHB4xvJveWaUie8YkZYAFvDGRugemJ4dPDx3fwwebEYdq0z8YKWU0eg
	 Htr8S3MWV/ztWbGmZV4fxD63EtmDKzEwwIbkH0c4De2yVh6y5QSQyBaHq05+o+xPve7jU
	 SDEiJdCiEQPVIX0KFrgHSHyIfFnYpuK+1s9LlnPUFqb79b4+vAvbsNTPsRpJX8RQrCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buKmO6LP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC8606A31D;
	Wed, 28 Oct 2026 17:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buKmO6LP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994BE1F01825;
	Wed, 28 Oct 2026 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210332;
	bh=tjKqjj9CT7GMonJEswQMJlZpU2G8/RQUWcFjUKC5W+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buKmO6LPXyztj2QScZ+AOIkmIdo2Gez0KfQnHCbjk2Tv/pOdpqGe8zygxwzExwEIZ
	 zdSN22xN73KUhAbBlIoTgb7KZiItfHUPDQTzEbSZIxhf74LCt1IL+khngobMqMhxh9
	 eo97VG1eIBQ2x6YnT3OY0gwWI7cfH/3jRuxfmkW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 159/168] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:01:35 +0100
Message-ID: <20261028165946.849731341@linuxfoundation.org>
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
 


