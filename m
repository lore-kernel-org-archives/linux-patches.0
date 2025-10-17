Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C12F12B0;
	Fri, 17 Oct 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715058; cv=none; b=Sx2UUhqT9FaFuTFcJ7INCHlOuK4O71CyiYuNm1lBfzphI+lFit8Dd0D/GwaS2ZIREEZZoVkJalKGLmRCO8h/g/4Nl4m6yixaHOdpqSpVVS2jxDfrtTmFID6TX9LE4NbT7892jt7TlXExiZTtp14xiyMmLhg/n2Qg2CdOIugnN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715058; c=relaxed/simple;
	bh=7QVYlt5+IpthiKEMyRUImFvAaA0nA/mi4e+5oHYajLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HN2OHSC9s1IMxfuYqK8PonSAjYR6wvTFOLNyxiuZZ9zfXI8UPwgbRUl1EV7ubJGI+/9sRfhfjdjOBnPU77QEOHzGp1gU2PlC/6QXma2cJSeofshdc4HtJWGgg2FLjnvRr3/ScGbNK7Sv7P4zhRW98cTql+JQ4C8QtqLfEuhRZp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4bSaVj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4bSaVj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D89C4CEE7;
	Fri, 17 Oct 2025 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715058;
	bh=7QVYlt5+IpthiKEMyRUImFvAaA0nA/mi4e+5oHYajLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4bSaVj//HvQQCqY4hR8qPdjVPvWMMnDEElkQ/32VlqtNUcP363rvDIwvul6TxTuR
	 z1OjyjZpjpqCpkfmc5vlxgBHOvTVvLYHUI7dt6fB1Vxa4K6gMBMRwo8xO7q423IAgu
	 Qc+lr53H/zBzsHhynt8R7FxaX4J4Yp1n5XNaFxoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 056/371] nfsd: fix assignment of ia_ctime.tv_nsec on delegated mtime update
Date: Fri, 17 Oct 2025 16:50:31 +0200
Message-ID: <20251017145203.826414293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2990b5a47984c27873d165de9e88099deee95c8d ]

The ia_ctime.tv_nsec field should be set to modify.nseconds.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ea91bad4eee2c..1f3a20360d0c2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -538,7 +538,7 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 		iattr->ia_mtime.tv_sec = modify.seconds;
 		iattr->ia_mtime.tv_nsec = modify.nseconds;
 		iattr->ia_ctime.tv_sec = modify.seconds;
-		iattr->ia_ctime.tv_nsec = modify.seconds;
+		iattr->ia_ctime.tv_nsec = modify.nseconds;
 		iattr->ia_valid |= ATTR_CTIME | ATTR_MTIME | ATTR_MTIME_SET | ATTR_DELEG;
 	}
 
-- 
2.51.0



