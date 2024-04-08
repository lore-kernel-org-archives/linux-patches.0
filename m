Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9642046;
	Mon,  8 Apr 2024 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584474; cv=none; b=MubxMa2aN4o1r2KPMDbkKNdXoXd1nJJbATnKDUsh5ytZzQuckh6oXAfEHlcLUs1kxTkI4pu+w1qxMkoZ90ccpodm78PgulaGaZhB+Wl1fRN2BsUB2pu5jGCsFdv8NLkuO64NzFYGOUYFee61LnT1POCSJWvBsvGPz8keBxCCTG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584474; c=relaxed/simple;
	bh=iFoD4zScBPPfDyJtyLI0ofTbMKiSlwYSgeXcfb01iik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF27W4Bp7gblEyUl5lKjuUmJvUPzuW+RT7GEofRIw3d5VuGCF4FdsoRLVFjJjWVfy3m+3/0f9Iadje05aoOgh2YU+JEMZ6oXXYjSi6GtPI37IPKhrgHM2QOb5VyhAf2OrCy5aD6Y/vc9PMEhRiXyojTC089AqQws56j+OtA6HLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6bhqwZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6bhqwZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0AAC433C7;
	Mon,  8 Apr 2024 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584474;
	bh=iFoD4zScBPPfDyJtyLI0ofTbMKiSlwYSgeXcfb01iik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6bhqwZ3WImXK/X3CflQj7c2h6NbntjMWaPw8VU8Ki7UJia9UswCG+TA7eMySOUsw
	 UH3zGkrp9UuBwkdneEyP70YzwKpfGQNfMkr5dk68XPqsE1gDVKTBHEO9h4hYp3b05V
	 M9Fdl1zi8DLyv/aXmUBUFtOMWjPy8e7K0WPR5Ie0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 420/690] nfsd: Avoid some useless tests
Date: Mon,  8 Apr 2024 14:54:46 +0200
Message-ID: <20240408125414.825929898@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d44899b8bb0b919f923186c616a84f0e70e04772 ]

memdup_user() can't return NULL, so there is no point for checking for it.

Simplify some tests accordingly.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4recover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 8f24485e0f04f..4edfc95806412 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -807,7 +807,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 			if (get_user(namelen, &ci->cc_name.cn_len))
 				return -EFAULT;
 			name.data = memdup_user(&ci->cc_name.cn_id, namelen);
-			if (IS_ERR_OR_NULL(name.data))
+			if (IS_ERR(name.data))
 				return -EFAULT;
 			name.len = namelen;
 			get_user(princhashlen, &ci->cc_princhash.cp_len);
@@ -815,7 +815,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				princhash.data = memdup_user(
 						&ci->cc_princhash.cp_data,
 						princhashlen);
-				if (IS_ERR_OR_NULL(princhash.data)) {
+				if (IS_ERR(princhash.data)) {
 					kfree(name.data);
 					return -EFAULT;
 				}
@@ -829,7 +829,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 			if (get_user(namelen, &cnm->cn_len))
 				return -EFAULT;
 			name.data = memdup_user(&cnm->cn_id, namelen);
-			if (IS_ERR_OR_NULL(name.data))
+			if (IS_ERR(name.data))
 				return -EFAULT;
 			name.len = namelen;
 		}
-- 
2.43.0



