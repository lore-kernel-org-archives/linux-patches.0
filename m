Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A768242046;
	Mon,  8 Apr 2024 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584477; cv=none; b=mHPSvi/e21liSogFI80M3PwDTI/JX0DwMnvkFEPPVQ6LhQ7Fd+ybPnfa36Ki+h2rE2EFXK02Vpd2asKRiCck8o3sdNDhedwZw+SC0A0ZdO1Dgo9Bzro8L67K/r+QIRqhGrgnqwCGWVNMS8oTxw5Bq0HfQnFKMakf1iGT3yLWo+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584477; c=relaxed/simple;
	bh=vhzWFvrT7Ct4bcD5pvMm/99zmNKioSsCsKVXiuIwFRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/zYpstcr2wlRsh3lYU54nbPBnknKtA3haf5e4c1ObZI/P+tYL77P2ILR8WkeESko2GzwmOWaisGdzQgB2ZhyiDuty2xS4eCnmt6ubHoo24X9urpG/3pB0HOQzARbdMhzUmse0e15YeJne9XquX21sli8Ub1DUUpzadxHRzATcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCuVEQg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCuVEQg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B018C433F1;
	Mon,  8 Apr 2024 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584477;
	bh=vhzWFvrT7Ct4bcD5pvMm/99zmNKioSsCsKVXiuIwFRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCuVEQg4FdxNJ52vzaR+BYF5Mc2SbLFogXBHHhCfe1q41WFRy9tRgdtP2qeL+9Y+V
	 nNCjeb7ExTsSt4wmUJHGq2PkdLEW9vaUe4OwujIGjkUHn4qKyuuP2U6WHoKIirxBGz
	 WjNm2I76SFLQdguvpl2g6zT8TzmIPQ528N2KKtrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 421/690] nfsd: Propagate some error code returned by memdup_user()
Date: Mon,  8 Apr 2024 14:54:47 +0200
Message-ID: <20240408125414.858866891@linuxfoundation.org>
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

[ Upstream commit 30a30fcc3fc1ad4c5d017c9fcb75dc8f59e7bdad ]

Propagate the error code returned by memdup_user() instead of a hard coded
-EFAULT.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4recover.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 4edfc95806412..5d680045fa2c7 100644
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



