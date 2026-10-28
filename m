Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216972;
	b=S8Ad7VKJcYSSL29COXUXAmJUIrS4IJN6jQycYgf29wvcRodh/E2l/1pqLs3zzexAGHge
	 8S87CLDcx5Fh+a2Nfyygd7Um33OQ17NhZAElpTSp9APhwrwkq3RSNv3qIRSRW/eU0ZoF9
	 GYtlxndTZWCknhJLMyKxkHNBRbYGf12TRQLlWrpbwnMiABGvB0zZBvD2MPa6GCLeph5a5
	 8gAxa0FOahmEn0xoA4M7ddYigfmqOfSQquU13MrQnHG2uG5e/P+Yj/m1pkuh9d8fabQkg
	 dnpCo8bXZjSVmvB8Rl4RW8mWDv8rrEyCLd0w5ONQutclCY0Ob6b4HglRBA6+5sfrAFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIw3yr4lmmUImYePpAynhm5ySf1EoHHAoGbW5VqVZGI=;
	b=5DaQRHgzkzKaVDf/46QE+L+pXmSQpVxaO4aVkkruIJOj9rN2VOfBAQB4a0Jk/8b0CJVi
	 daHz7Gvqgc2Hhbjt8BHuzSQWHMzQjFY6+ADf6eaXZs8CmCyiHZ6SInu1q6U5kvkWDqX8c
	 +04yMUmZzGQ8nojNuetd+ed5klXFM9Mb4a3UR2ZAN3U2yke9WlYtihRdZzBe1pUOYvEsA
	 E7ajRz4m6HkEdAmXEKxclgjZ/rCV4gYr8UnsB9IcGZBBLoGndnCpDLfWb6HYMB6xlSWiz
	 1fNo1QnJCfywUYyZ3c3jj7H93J0jJOQu3K1eT5dgGKb5P4wf5NN280sYjb7jU1BkzXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4tOETbq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF5606A31A;
	Wed, 28 Oct 2026 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4tOETbq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32DA1F01825;
	Wed, 28 Oct 2026 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216971;
	bh=UIw3yr4lmmUImYePpAynhm5ySf1EoHHAoGbW5VqVZGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4tOETbq5TyX2sOKtZFMqK7qv+x+qtNIARjT8BIEvQn1u/OTsY4qEgtjyl5FU1N2S
	 ynf3DchtRzciEWYbVAmMuVu4h62YLyg8DkdlFSY8BTYiXuQJUiJcQBz3Dqz+tUaAZr
	 f+fTPDO8F7ZVEJb8YCTEa250q1mHBcn6IDEiNxHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Dudnik <ilan.dudnik@safebreach.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 1699/1887] ksmbd: fix heap out-of-bounds write in krb5_authenticate()
Date: Wed, 28 Oct 2026 18:03:15 +0100
Message-ID: <20261028170538.116813694@linuxfoundation.org>
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
 fs/smb/server/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1625,7 +1625,7 @@ static int krb5_authenticate(struct ksmb
 	in_len = le16_to_cpu(req->SecurityBufferLength);
 	out_blob = (char *)&rsp->hdr.ProtocolId +
 		le16_to_cpu(rsp->SecurityBufferOffset);
-	out_len = work->response_sz -
+	out_len = work->response_sz - work->next_smb2_rsp_hdr_off -
 		(le16_to_cpu(rsp->SecurityBufferOffset) + 4);
 
 	retval = ksmbd_krb5_authenticate(sess, in_blob, in_len,


