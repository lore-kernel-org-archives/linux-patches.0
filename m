Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217165;
	b=p8Vr89JWgF2Ia8BQoaICVzbQEHIGUde3nPkuKlidlYqLuSYEaEyqFcM2yIDv54Fw7PB3
	 5qE3lcr4CeKh8agBYUUeAqTU0+Wqg+SSkxz9rOSp4MUUayr47+IqUJdq+0DkufCIJ7lcN
	 vUBC71Y+0trd0EM44fBgC+wKTQAJ4wkMPB6MiUrrgliIxbXX8FzlLhmQo1B9GfndCKPkp
	 Yz6um3ipCVrNZyC2aia/odg+5fXBNDJC+6jK7YgUTU5DtuQsWZ8Qx9jFO41l3n6Svjlqt
	 33FjzuF6vDvxpEBeQ613O3JpT3RvMOxp9xUlL988wZg7SXViOUJwsfX2Gv5lYSDCR6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCyVShO33lGqpzUaFc92MV+2/Z6v8PZhHD/Al7Y09Yk=;
	b=Dtme/7ON4L4Hj5XLgVr4yHDwVYSiQi13+nYZVtPhDpnc9D7mV96gI0Wr/ZdWqBPO1qdv
	 QIHJPHbxj9LGFZevcaH+BtxLfP8MYNYpN0begCuadtNuvJJtwQN8NctK+NPSdLLYIPjJE
	 Q4Q9CYXK5/5C+/vNPIboNHKq5JoOX1gwBIk8sIx5ed94UZ9M8Urc+3Y4kAtpLRsf9QIKm
	 J98OqsS9i0VFZrX+FU4lept10Q61MHs0ZP3N152cDiCkuG5bvIUoD2Zwi+Uulz7ZM0Zza
	 lfBwcv69fpY/gj7L+qyrvzDnca+YGwXqOc9lYg8JhBstnFCzAhKF5unQ+fvYmpIo03Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ccO3KUc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91800606A31A;
	Wed, 28 Oct 2026 19:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ccO3KUc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCB21F01825;
	Wed, 28 Oct 2026 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217165;
	bh=UCyVShO33lGqpzUaFc92MV+2/Z6v8PZhHD/Al7Y09Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ccO3KUcXDUWmDBTYjds4Rg7+t1OgfE2XdaIioiIgj2K/t+PJKRhixoAuvn7iVdhI
	 uU+N2C6Ue77tK4ZJQe5Xh/FKb5Da/arz9E4sxblDKVnWsh86FKC3+BZ0wy2SC3N1pA
	 fk7a+jqVZoWsJIr/5pj0zQ9ucTiYoCzY93qlb61U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 1811/1887] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:05:07 +0100
Message-ID: <20261028170540.658332862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


