Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829050;
	b=RDddLLyuhJTQPYOWcwGZdApyciqekWuulxBrpWXYwwrs+nsePzdVoB3wpWs5sCFy+O6u
	 G+Zh6e2teSvCK5Z7vWideUJMp0UMZxJ1EdXNrLmMCNXG3McayLZUnQsQpGJEdZx2k5l2v
	 iSTdXK58BqT+RXO0Tlmd4ujtgXOnLdzbC9O7jmTmEfFIaNxtW9b6cKzekRhBHf07pPBZO
	 /Gts2v7vcN0V0nIsmYWV5mJyPEyGgUpRyvJJK4WhMrZCcnD+pYcF/02LtcUAqVnWlmBZO
	 fu/RrJjNo7oITkJ37soa38MFtUL2GN8j1dlBRy9YkX0NBn/pzr9meuW6d5fdDEo4dsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5IwVFg7BmKz4WwCDHMYdYkzYIwszuKX532PyZMWjrNE=;
	b=Y9B2kxp6CmrhgBUaTOKMKFxAdtoCdG7rmp+UB2XyMTc4qNpw1/rRDec0DMnx1S42Bagt
	 T+zhVyOmwpYOY/LFb7RKOhfzG9HJxVKYO1K8NnO7XsA0i/bEgqIuPErnE6oMEqX08Ozm7
	 VSGSJk55aw6I7luKEkTY5sAhaXIGOeXhISdKeVHcJ4i5CNPLeKsfufDQvDPX1YqIqmvjQ
	 v5zbImZmi6XK5M5BJOk1gewbPkN58ZWXZ407zkeg7IGN9m2KhtfsSSeOFl3lyQwkEqGsi
	 L/CnoTvEwSRzf8jb/AwE6ZcnUhj/iS6o0q5pf6TBhUHkdnoqgo0K+jWtsoLKRxIHxUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7TTLvkR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773E660807B1;
	Wed,  4 Nov 2026 21:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7TTLvkR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD621F00A1C;
	Wed,  4 Nov 2026 21:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829050;
	bh=5IwVFg7BmKz4WwCDHMYdYkzYIwszuKX532PyZMWjrNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7TTLvkRxccLzk3rXNB8wmX//22X3AfjSqlXfpER30k1J7RGfgIt8pw7M0xhFebVC
	 eVN2kU8CL0AGv04PwA49kOEUWoPOc+oVBZgKJ8CbzSveltxqbyA0imZXl3V+lL5yOm
	 XqRQkXCQIppQpWbhv5T35o+v6XTIQogdfBtZnDW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 412/547] NFSD: copy SETXATTR data from all XDR buffer segments
Date: Wed,  4 Nov 2026 16:09:56 -0500
Message-ID: <20261104211050.025310624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit b01319947c69b0e3ea0fcd4b675eb892f9cad8a0 upstream.

nfsd4_vbuf_from_vector() manually copies the head followed by whole
pages starting at offset zero. This assumes that all remaining data
starts at the beginning of the page array and that no data is stored
in the tail.

However, nfsd4_decode_setxattr() passes an xdr_buf returned by
xdr_stream_subsegment(). Such a sub-buffer can have a nonzero
page_base and can span its page and tail segments. Ignoring that
layout can copy the wrong bytes into the value passed to
vfs_setxattr().

Use read_bytes_from_xdr_buf(), which observes the complete xdr_buf
layout.

Fixes: c1346a1216ab ("NFSD: Replace the internals of the READ_BUF() macro")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160022.3105295-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2320,10 +2320,8 @@ static __be32
 nfsd4_vbuf_from_vector(struct nfsd4_compoundargs *argp, struct xdr_buf *xdr,
 		       char **bufp, size_t buflen)
 {
-	struct page **pages = xdr->pages;
 	struct kvec *head = xdr->head;
-	char *tmp, *dp;
-	u32 len;
+	char *tmp;
 
 	if (buflen <= head->iov_len) {
 		/*
@@ -2338,19 +2336,8 @@ nfsd4_vbuf_from_vector(struct nfsd4_comp
 	if (tmp == NULL)
 		return nfserr_jukebox;
 
-	dp = tmp;
-	memcpy(dp, head->iov_base, head->iov_len);
-	buflen -= head->iov_len;
-	dp += head->iov_len;
-
-	while (buflen > 0) {
-		len = min_t(u32, buflen, PAGE_SIZE);
-		memcpy(dp, page_address(*pages), len);
-
-		buflen -= len;
-		dp += len;
-		pages++;
-	}
+	if (read_bytes_from_xdr_buf(xdr, 0, tmp, buflen))
+		return nfserr_bad_xdr;
 
 	*bufp = tmp;
 	return 0;


