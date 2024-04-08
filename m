Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337387BB15;
	Mon,  8 Apr 2024 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584721; cv=none; b=YixvV4+kJt/QqcEOK9kUmpqc7z+xF+v88MMyBiQDdxuDjiuaq05VA4WvJfATdIalVVXGdce06IDjWDxh5RzOUTFAUdLXiIhCG9MiGqbOYI4+k5b64he7TrWOPvqs/sf0HO269wGQ2o16MM+2xfYFDDMCnJequFg3GfbfYtHgwBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584721; c=relaxed/simple;
	bh=KFnEVvaSHiDXLzhwc37wcz8PBb8fCNMBMrO+oFXz2gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFV082uU2vAVSuRaSy20nhcyr0tCGrBSaey4GJ7w2CKBhRmMabDAABTt8mPsPdSAalIlbdzKy7ybhOQhTE+bhYWHyoVTupNpXEGfiYSm/kJhH3IZRzdDYRv4CZkLbHGLtgXz7ybt1NROg8dvc8qJKt84CEwOBDljMJznE0s96GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXPnQlm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXPnQlm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F14C433C7;
	Mon,  8 Apr 2024 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584721;
	bh=KFnEVvaSHiDXLzhwc37wcz8PBb8fCNMBMrO+oFXz2gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXPnQlm9LGFK/k3npFh3Xfhxezwi80WWwPDFC+4m7iBKTXurp8mA8+IiO3Arf6iip
	 oJ8NkDqo2zvrHCpcRpTn80Xidh1sIORVNzqMf1vErTiofdF0KwMv2tG2x1AhTcqv/6
	 oKS/BqgnkDcEkpX0GIAkDBIbmSG05Cdzu2mkmS0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 534/690] nfsd: dont take/put an extra reference when putting a file
Date: Mon,  8 Apr 2024 14:56:40 +0200
Message-ID: <20240408125419.003511867@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b2ff1bd71db2a1b193a6dde0845adcd69cbcf75e ]

The last thing that filp_close does is an fput, so don't bother taking
and putting the extra reference.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index faa0c7d0253eb..786e06cf107ff 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -381,10 +381,8 @@ nfsd_file_free(struct nfsd_file *nf)
 	if (nf->nf_mark)
 		nfsd_file_mark_put(nf->nf_mark);
 	if (nf->nf_file) {
-		get_file(nf->nf_file);
-		filp_close(nf->nf_file, NULL);
 		nfsd_file_check_write_error(nf);
-		fput(nf->nf_file);
+		filp_close(nf->nf_file, NULL);
 	}
 
 	/*
-- 
2.43.0



