Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207352;
	b=D0JQLsD8weFqiqfTiSXT37YuJgcG8TUHVTYhZRtTyUL8qBlYahPIb5RC6K2AINKU9feR
	 Nznr1d69KED2K0awyhzp6WpimKCNa26MhWOfYrY786iWYgOkCiSwE5+lvcW41+Bm4Sk6J
	 nnaLVEM3VwOEDHU2Rq5xgYFlq255YRYCNq+1EBXrLo9OuZuoj287mdRskKbCTKquiCrAk
	 vuZQDR36JruC0K21Fr+/NCHdbwL7U9CyX+Vv0rv0WFgG1+i3yFrlMoqNv6RPyQ4ixXica
	 PW83lcWCTFs+t1YtwWP4MRjcszTwqQEh2ueX4ojysWmmxKMuZ1SXUhUh/uwBBBwrDrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b2WBO+B7N3mmqjc0YYxs+dG1vMH05k63/O1+QJf0Hn0=;
	b=mWjlRX6Lar3+uIbr1CFHunGFClbTs9DTGIsrLJwaoX25GXDC8XIk4TNA3YWG3ByDKOls
	 7gQB98s+rcb5+IcP15kbyCX0t1TtjAwdBvb65jKDtogzt1XU+AAzaNQbruM8Yoyw2EsNF
	 CdW3Nu6JoF1sBo1RZGbguvsIYT0JV2H3wZLf3pEyGNSwSME7gaRFGhgvJsZrUQZdAfalP
	 UkJUSnWUiSPh3MF103beOIChJmfMLvmyImgpVdLVR8vwdBJJbHrT89830euam94sVEV24
	 0BgWVdJB4k92Imb18/WwBDKylW3LaQrOoKHyJ3BSK1la3m97jrbmk3uV1OZ+xTcT9pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5iB8i1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC598606A327;
	Wed, 28 Oct 2026 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5iB8i1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1D51F01829;
	Wed, 28 Oct 2026 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207351;
	bh=b2WBO+B7N3mmqjc0YYxs+dG1vMH05k63/O1+QJf0Hn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5iB8i1OERdd5Cz051IjASgAKtIoaiyWPFVh36rZBx+r8yNeW9EXtl8DxOx2g1PgX
	 iw4kqAdn2AV2bk2aAunCqt5+T0IgOZnDfiLsghU1HPWMOzC+Th8YnwOuknXp9YBlLf
	 2+jDVyngYxqJCD3VzRapYAoxdC2oc47h+MqbtZEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 76/88] KEYS: trusted: Fix blob allocation size in tpm2_key_decode()
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028165943.904109774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,7 +116,7 @@ static int tpm2_key_decode(struct truste
 	if (ctx.priv_len + ctx.pub_len > MAX_BLOB_SIZE)
 		return -EINVAL;
 
-	blob = kmalloc(ctx.priv_len + ctx.pub_len + 4, GFP_KERNEL);
+	blob = kmalloc(ctx.priv_len + ctx.pub_len, GFP_KERNEL);
 	if (!blob)
 		return -ENOMEM;
 


