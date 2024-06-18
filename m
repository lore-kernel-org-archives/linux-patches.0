Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1171A2C38;
	Tue, 18 Jun 2024 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716388; cv=none; b=dhvxECf7F44H+ux2b5Wph+yI2/+sgZxq7pjxdYmh7kjobojD41gNK2eW9D2zTluy1o0F5+i5E2gbV40iLr+DeixesWzMU0RrirOaPQi5lJNLPxFZZnRh+xJZFhLqoBZ4NJyhHaBKl6m44PN1oEppZjVdwxaXFqdFtWD4FeUmIH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716388; c=relaxed/simple;
	bh=5H9ItZhj+HnNgi68QkgpnMUdtSQX2TrDDd5sb4yRyac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l40zAn2IH4HdLmz2GUdXq/hz3xkPTyZ2o5H/O3IOZ48EBnNG+6TK4VTehrRI+2yrDqBKgZuQBjIjrxioo5WrT3usD54EdNpACcAfqw2ntloEJiIBSh2JELPwcqfdo1U3cpMMc0mv544yApBfv/Tw66JAhpFeTzJHSVBZfGOrEQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiN8hirR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiN8hirR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A46BC3277B;
	Tue, 18 Jun 2024 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716387;
	bh=5H9ItZhj+HnNgi68QkgpnMUdtSQX2TrDDd5sb4yRyac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiN8hirRpkF+nq4fCne2FFSNeGrGkEpZjLEEsQDqJky/5pu7UChW+tLfoXo8zTHDE
	 rFrqQhmtDT1m0gbxrJRDvKKp53VyVOEKwZlAHGUGfdd9QvzH2LdTbNAGG3noaDudoK
	 qVXvI9KzwTDxPRy0ITZmCdA2+ezRzOfmtP5NKTpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 630/770] nfsd: Avoid some useless tests
Date: Tue, 18 Jun 2024 14:38:03 +0200
Message-ID: <20240618123431.602804545@linuxfoundation.org>
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

[ Upstream commit d44899b8bb0b919f923186c616a84f0e70e04772 ]

memdup_user() can't return NULL, so there is no point for checking for it.

Simplify some tests accordingly.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index d08c1a8c9254b..b9394a639a41a 100644
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



