Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D047618307D;
	Wed,  3 Jul 2024 11:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004843; cv=none; b=aPBuSy5aI2GVi9FGX88yV4TDDThAsY/tX7GJWOUxI9VY7R9qHL+Vx4bZJ5Kvz3cYg3J8LdEc8OooIKl8O9+GANQ4aw+iK7IIMgubUuM/YUojHIZCt05PmxMXUe1LIXb9OHCsc6A1lKEVlg45tbGRX0PYxEIm9pXxTa3QWhzmcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004843; c=relaxed/simple;
	bh=wWvhQ18stvlRO6/d52s47oiutxPubwyojDEjAfetW0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nccrcv/S+h+EiAiGyCVwBZTOd83c5fQK9MdDQ6DWdy913u9KlQcEpPpffIq5IZ0Z0RoUjj7aZriGJMyC0Yw9mSD9xY+sondgCg9h10FLlCFuzNC1VFUu4hfaBu0VBdjtKDq20Lzgitn6cE2ZBaCORZMwYAVjVBokb8ig/pOe2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8S1S7OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8S1S7OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5708EC2BD10;
	Wed,  3 Jul 2024 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004843;
	bh=wWvhQ18stvlRO6/d52s47oiutxPubwyojDEjAfetW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8S1S7OAVppbLx4elbskKFcUmJI7PvFeXTsKUtOZSxT7cwnrqnyVQTYgbu/ktcVGE
	 s4w9Rt6kfheSxBMGTQn+T1ArO1xZwzHkTRGWLQsAg3Z+6dz1RWYvyqB3aQ9mi6Y+DC
	 HRT37A2JSyNH5xi/qs4vo+aajL9vtlYFDzXVHVAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/290] knfsd: LOOKUP can return an illegal error value
Date: Wed,  3 Jul 2024 12:39:18 +0200
Message-ID: <20240703102910.859438986@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e221c45da3770962418fb30c27d941bbc70d595a ]

The 'NFS error' NFSERR_OPNOTSUPP is not described by any of the official
NFS related RFCs, but appears to have snuck into some older .x files for
NFSv2.
Either way, it is not in RFC1094, RFC1813 or any of the NFSv4 RFCs, so
should not be returned by the knfsd server, and particularly not by the
"LOOKUP" operation.

Instead, let's return NFSERR_STALE, which is more appropriate if the
filesystem encodes the filehandle as FILEID_INVALID.

Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index db8d62632a5be..ae3323e0708dd 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -573,7 +573,7 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 		_fh_update(fhp, exp, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID) {
 		fh_put(fhp);
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	}
 
 	return 0;
@@ -599,7 +599,7 @@ fh_update(struct svc_fh *fhp)
 
 	_fh_update(fhp, fhp->fh_export, dentry);
 	if (fhp->fh_handle.fh_fileid_type == FILEID_INVALID)
-		return nfserr_opnotsupp;
+		return nfserr_stale;
 	return 0;
 out_bad:
 	printk(KERN_ERR "fh_update: fh not verified!\n");
-- 
2.43.0



