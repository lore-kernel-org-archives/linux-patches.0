Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A82142649;
	Wed,  3 Jul 2024 11:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004968; cv=none; b=LTJkLF+r6Fipl7s9fDsRNQAtI3q4BYklAAJrQA6mrk9ERMJT5tiqdbIls4wkORQNPhG0gMOWKIaiw87aR7zt6hoQfAhNTzDNewdQG5IPFmAe/huM26/2oB7IuOsNB6ixnuDV1YLk2Ui8xQEpfMzzaJgSI40bhHxRb2zK8UdxsO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004968; c=relaxed/simple;
	bh=UsX8lIttw7rAQ0FIOQUUysP6Zch16Emc+B5l9nmbMGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSBSkuBzQecHAHvHSNLMl+SGdzOxKyyoCUFftA8t0h1+kNMrLUXin2PYot6kGbCw82QWTBVLbu+ELZAZ1Wilu6kKgdWykwKPyOmvE+o9fl2bXZbfro7r5Sp4D5I4vVVRmgvt20QuFEIDaGzJPeCSBqEPkgzm5Cm82MXJyZZYhLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf8cAF14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf8cAF14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B128DC2BD10;
	Wed,  3 Jul 2024 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004968;
	bh=UsX8lIttw7rAQ0FIOQUUysP6Zch16Emc+B5l9nmbMGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uf8cAF144yg86U8Kx3U7C6hoVgpVSeH+Jx5TJ5i2ztGH12inZEJOCH6RhUK3YiNPg
	 Z6eM4s5efHxDTP+60f6e8Y/Fu279PmSuQfD2WhWLOgytwx8FR1irmZN5wYlpcU7CeD
	 d/ZOvNq5yJt6RnKrHorkjjURng3UMAxZVoqFnDjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/290] SUNRPC: Fix svcxdr_init_encodes buflen calculation
Date: Wed,  3 Jul 2024 12:39:57 +0200
Message-ID: <20240703102912.317258252@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 ]

Commit 2825a7f90753 ("nfsd4: allow encoding across page boundaries")
added an explicit computation of the remaining length in the rq_res
XDR buffer.

The computation appears to suffer from an "off-by-one" bug. Because
buflen is too large by one page, XDR encoding can run off the end of
the send buffer by eventually trying to use the struct page address
in rq_page_end, which always contains NULL.

Fixes: bddfdbcddbe2 ("NFSD: Extract the svcxdr_init_encode() helper")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index f0e09427070cd..00303c636a89d 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -579,7 +579,7 @@ static inline void svcxdr_init_encode(struct svc_rqst *rqstp)
 	xdr->end = resv->iov_base + PAGE_SIZE - rqstp->rq_auth_slack;
 	buf->len = resv->iov_len;
 	xdr->page_ptr = buf->pages - 1;
-	buf->buflen = PAGE_SIZE * (1 + rqstp->rq_page_end - buf->pages);
+	buf->buflen = PAGE_SIZE * (rqstp->rq_page_end - buf->pages);
 	buf->buflen -= rqstp->rq_auth_slack;
 	xdr->rqst = NULL;
 }
-- 
2.43.0



