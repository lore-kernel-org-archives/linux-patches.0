Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211795;
	b=kEUodJ9Kapuwjb3Emuu+z6SFM+0Sk2LwnZ9+U3NmMeDsJx6k3orlWQQf6VkhSgIJ9RXQ
	 M5wtXkNnvlHy8O+PW0/Zc/GiLlDLBcL0BznW5HKtjU1z6BbM+6/gWdJ13y3gF4WVe5neA
	 NVSCkAdU61UIi4LncurMyyIXgeqqKVgoEzKS4nxTlJzC8AlbBROLdseuOInR369iWhvsz
	 /1drpk7LyLP5TNM2p07BkLTXf/Ruobpw9/QdNQW8mbpmXMtP6jjLD1hPNHshKjk6vyhjT
	 4bwIsTlbQrzKp50NOEla9UoSbHsMj6dJhl9gC3feFYHeNYHnqwd8w6d7bx+kAy1H/3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ryTn+yiarbtWoTtdowm6rQsuC+Sm8B6+v6snQLGr9JY=;
	b=QlacJvS/rx7H+PNTxD59fgX1TpXG1zaq5XwIkiAnv9CTjFPOTdhtuIshENNBRKi0OVtj
	 qLJlNnZ+lrcIyGx8bRkqeoht5lh/4bqHHeDzaVZ0khNYoDvmEpfLM9fFsZIhGLePO4QgG
	 uwZ3u6z+6UAuLBGBSWhA+STIi1RqAQmsZevBxNF/1lIohyrMsDBIr6z14G91cFbLKBu/L
	 8bIV8S9QVoKF2krhiVbmb8hZf8G2Pai5ZWOidOWqFt3+/rbQvo9+iXQQ+mZr/q7zufHKx
	 nL22kmIqT+I4cBJnigNrlLTvr7NBdPIDtdG/rLGM+mbvgeJ+FLKmEM1gejXllqZcM6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HL6rhtSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DD5606A32F;
	Wed, 28 Oct 2026 18:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HL6rhtSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76501F01825;
	Wed, 28 Oct 2026 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211795;
	bh=ryTn+yiarbtWoTtdowm6rQsuC+Sm8B6+v6snQLGr9JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HL6rhtSDGExRhKwgfVpAcrHw6S3lC/YiHljQo1RV3debfg4p24UsOYUYE2WGWS98z
	 X8AJ3O8FW8ug6dwidbAFn6amOemyvcbOHkTd6/3AD4cu2pUd8rmHeZaNaWZW4gxFDc
	 ZodisV3WGsKUXO4K3x4ettX7i0ppXJJPl9di05Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 466/571] ksmbd: fix heap out-of-bounds write in krb5_authenticate()
Date: Wed, 28 Oct 2026 18:00:13 +0100
Message-ID: <20261028170019.080185542@linuxfoundation.org>
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

From: Ilan Dudnik <ilan.dudnik@safebreach.com>

commit 23a0be6a84a38ac169eeab49017934e8e27c65f0 upstream.

In krb5_authenticate(), out_len is calculated to determine available
headroom in response_buf for the incoming Kerberos AP-REP token. However,
when SMB2_SESSION_SETUP is processed as a non-first element of a compounded
SMB2 request, the calculation omits work->next_smb2_rsp_hdr_off.

This causes out_len to overstate remaining buffer headroom by
the cumulative size of prior responses in the compound chain. Consequently,
the length check in ksmbd_krb5_authenticate()
(*out_len <= resp->spnego_blob_len) passes erroneously, allowing memcpy()
to write the AP-REP blob past the end of response_buf into adjacent kernel
heap memory.

Fix this by subtracting work->next_smb2_rsp_hdr_off when computing out_len,
ensuring it accurately reflects physical remaining buffer space.

Signed-off-by: Ilan Dudnik <ilan.dudnik@safebreach.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1612,7 +1612,7 @@ static int krb5_authenticate(struct ksmb
 	in_len = le16_to_cpu(req->SecurityBufferLength);
 	out_blob = (char *)&rsp->hdr.ProtocolId +
 		le16_to_cpu(rsp->SecurityBufferOffset);
-	out_len = work->response_sz -
+	out_len = work->response_sz - work->next_smb2_rsp_hdr_off -
 		(le16_to_cpu(rsp->SecurityBufferOffset) + 4);
 
 	/* Check previous session */


