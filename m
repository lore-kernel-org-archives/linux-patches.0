Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080D41A2C00;
	Tue, 18 Jun 2024 13:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716391; cv=none; b=Ijr1d5SordkmVPGTkvyzMaTMINNZGGrHmrWK//xnGAhcx/hZBkgDP5vxFdKGqWKG74ewS39oo52sx1now56ygnU4PCN7cT6v7F7+GxdgtVkZX7MWdmzZvnrVv9zVUBSflAU1w5be5m5YuLCii62DM84vJz/JCi2sjfDlnWxXDE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716391; c=relaxed/simple;
	bh=3qZpw4gb7Lk0GJ8GM28Sd0c/IhCFnv1kD1QiK2xfw/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoxrA+ObtZSvG7VaKUC5ssDp1fxewdcccMASNdpNBAIWEv/SNE3ysOwgqZq62Q98qOMYfqgnPmCMktzVf+zWtIEM6azM4d1t5kGg0izRVOUdzFdjIHXjD61hM0xCbAyHsrqEz66N/LOxOUZO1jJdDUxoxTPpjbq+gzmqtoSQUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK//mjnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK//mjnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570A6C4AF1D;
	Tue, 18 Jun 2024 13:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716390;
	bh=3qZpw4gb7Lk0GJ8GM28Sd0c/IhCFnv1kD1QiK2xfw/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK//mjnlVcrsDsEN46P+rtnOvABshPtNMC3IcRwdvCs02vtQ0dj6evwUfdcw+n9VV
	 OiXSd+oq2SKO5bOyphGlvkDtBrmXpCOd6wIFbZdLsMQd29dX3tQihWyyWLRpJv4YPB
	 goTixU+dCZ5iwDSbZCAcIV8+xUcZHHIbc/UQqbNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 631/770] nfsd: Propagate some error code returned by memdup_user()
Date: Tue, 18 Jun 2024 14:38:04 +0200
Message-ID: <20240618123431.642465959@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 30a30fcc3fc1ad4c5d017c9fcb75dc8f59e7bdad ]

Propagate the error code returned by memdup_user() instead of a hard coded
-EFAULT.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index b9394a639a41a..189c622dde61c 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -808,7 +808,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				return -EFAULT;
 			name.data = memdup_user(&ci->cc_name.cn_id, namelen);
 			if (IS_ERR(name.data))
-				return -EFAULT;
+				return PTR_ERR(name.data);
 			name.len = namelen;
 			get_user(princhashlen, &ci->cc_princhash.cp_len);
 			if (princhashlen > 0) {
@@ -817,7 +817,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 						princhashlen);
 				if (IS_ERR(princhash.data)) {
 					kfree(name.data);
-					return -EFAULT;
+					return PTR_ERR(princhash.data);
 				}
 				princhash.len = princhashlen;
 			} else
@@ -830,7 +830,7 @@ __cld_pipe_inprogress_downcall(const struct cld_msg_v2 __user *cmsg,
 				return -EFAULT;
 			name.data = memdup_user(&cnm->cn_id, namelen);
 			if (IS_ERR(name.data))
-				return -EFAULT;
+				return PTR_ERR(name.data);
 			name.len = namelen;
 		}
 		if (name.len > 5 && memcmp(name.data, "hash:", 5) == 0) {
-- 
2.43.0



