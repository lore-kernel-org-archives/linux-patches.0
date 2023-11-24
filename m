Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB42D787;
	Fri, 24 Nov 2023 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulMSFbhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE5DC433C8;
	Fri, 24 Nov 2023 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851484;
	bh=LeuySh723+ahPH15xaU1SoDDSzVfZNLUZF9VCrnmRgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulMSFbhdgjWW23z9sR1I9OU+wc8jPKws0WoLqjlJBN/jnGO/69DXgtT+2F17yJ9jR
	 i6PRoS8+vbIHuH7WGyw3Jnkw636dS10p+MB4+IkjlRkXMFC8Cnain+Cb7aXTg8xCti
	 dkM5Ri6sQLFJP92p1wEkn8JwtoSX6KUprmdNNdQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.5 432/491] NFSD: Update nfsd_cache_append() to use xdr_stream
Date: Fri, 24 Nov 2023 17:51:08 +0000
Message-ID: <20231124172037.595160560@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 49cecd8628a9855cd993792a0377559ea32d5e7c upstream.

When inserting a DRC-cached response into the reply buffer, ensure
that the reply buffer's xdr_stream is updated properly. Otherwise
the server will send a garbage response.

Cc: stable@vger.kernel.org # v6.3+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -582,24 +582,17 @@ void nfsd_cache_update(struct svc_rqst *
 	return;
 }
 
-/*
- * Copy cached reply to current reply buffer. Should always fit.
- * FIXME as reply is in a page, we should just attach the page, and
- * keep a refcount....
- */
 static int
 nfsd_cache_append(struct svc_rqst *rqstp, struct kvec *data)
 {
-	struct kvec	*vec = &rqstp->rq_res.head[0];
+	__be32 *p;
 
-	if (vec->iov_len + data->iov_len > PAGE_SIZE) {
-		printk(KERN_WARNING "nfsd: cached reply too large (%zd).\n",
-				data->iov_len);
-		return 0;
-	}
-	memcpy((char*)vec->iov_base + vec->iov_len, data->iov_base, data->iov_len);
-	vec->iov_len += data->iov_len;
-	return 1;
+	p = xdr_reserve_space(&rqstp->rq_res_stream, data->iov_len);
+	if (unlikely(!p))
+		return false;
+	memcpy(p, data->iov_base, data->iov_len);
+	xdr_commit_encode(&rqstp->rq_res_stream);
+	return true;
 }
 
 /*


