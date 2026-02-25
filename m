Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADF32DC767;
	Wed, 25 Feb 2026 06:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002637; cv=none; b=o68NAD24cgzqGez2lJ6j5nyPtfqgIezXb7ZywxvveDwSo8rOLdLl7apV8iJN2QSJaAPVGxWvVXsCET2rjFXNTxGLqHhPHMJo9ZAoEH/Tr0+vbAYqFx5scDtocIzUEb1tCgMGfx4kMyHG20Yw/7kzeuDfR7YzqOPMl4XSoGoZdgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002637; c=relaxed/simple;
	bh=vYeT90wVbt+Y3Rs9jFSQbGFfwmBcQKhgfWVav5+LEII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtwJfKJ1GxFKqGLjk/SXszal9CfQrqkx5yi+ARzLlUivWFdRGbxNKDgVNxrNDyCYcbHw5rWyI/+76wrqjoD2BIa1T3X0mBJLrnB+SgLoTqJRYNrd16p7MccsAVtLNAkKi6KQNS33ppFMdZ4VfTRG7vwOAmG6on8aSsk19UqDBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fmPzPy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fmPzPy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6E0C116D0;
	Wed, 25 Feb 2026 06:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002637;
	bh=vYeT90wVbt+Y3Rs9jFSQbGFfwmBcQKhgfWVav5+LEII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fmPzPy5MKWFOOnDpIkoSF0ClSpJZzPfT+etJc3H0EUfmkpkpP4g8Dn8KbXgvMlRL
	 KJZyirlM3pubJsTNRZdIFgaEuJRPck/W6+bTIeHaYj7v7FBpEeBldh7LLky0Kk4GWa
	 TD6It8skTy3rK9l5zXEeFAEBF8iv5wDHuhw8yuQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/641] NFS/localio: remove -EAGAIN handling in nfs_local_doio()
Date: Tue, 24 Feb 2026 17:21:42 -0800
Message-ID: <20260225012357.709183937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e72a73957613653f50375db1f3a3fbb907a9c40b ]

Handling -EAGAIN in nfs_local_doio() was introduced with commit
0978e5b85fc08 (nfs_do_local_{read,write} were made to have negative
checks for correspoding iter method) but commit e43e9a3a3d66
since eliminated the possibility for this -EAGAIN early return.

So remove nfs_local_doio()'s -EAGAIN handling that calls
nfs_localio_disable_client() -- while it should never happen from
nfs_do_local_{read,write} this particular -EAGAIN handling is now
"dead" and so it has become a liability.

Fixes: e43e9a3a3d66 ("nfs/localio: refactor iocb initialization")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index d1a8f6fa9d74e..358d686d2ae33 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -995,8 +995,6 @@ int nfs_local_doio(struct nfs_client *clp, struct nfsd_file *localio,
 	}
 
 	if (status != 0) {
-		if (status == -EAGAIN)
-			nfs_localio_disable_client(clp);
 		nfs_local_iocb_release(iocb);
 		hdr->task.tk_status = status;
 		nfs_local_hdr_release(hdr, call_ops);
-- 
2.51.0



