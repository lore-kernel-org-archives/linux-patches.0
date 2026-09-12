Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3327047ECDF;
	Sat, 12 Sep 2026 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219809; cv=none; b=SdGsYzpNNW/um855bTSBarFdlwPz6iDe6ppLvTcN2RrTy5RERE8LUPScgl0vMnHv2r44c94fbXWcbnwP6BKx1yAr+IXLalebYJihyze81IB2kLWzwLU0LF1eAoaVc3K9UxQ0vPZdDn0d22hoPywOzNednEpVftrmKZnM8C48U+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219809; c=relaxed/simple;
	bh=zqUHg6SQPOdYnr6mPZy9qKIjAQbEhuEVZe35YITEfV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGzm1igJUkqUVksSZTpM8p8C8iz09T1AbD6pSJb+K7Tcu7L9sEfqQdOCa7uCkr7u8AvO9glddA280lyemA3+xdhKyHfDcIY3qyBoQbZcGbr9oJZIq41PAkRZLnX15rprhjBcYj6/AdPeCEqj/GwAUrIpeZ+d48YUs2QdB0UnSmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8Qx8lXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8Qx8lXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6951B1F000FF;
	Sat, 12 Sep 2026 13:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219808;
	bh=q/evFzIDsklIQShUAZeIYACrjOD4MIZif7+Hd8+BnUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8Qx8lXCkU4MvLdznLNWJBSm5YGAkYO/HsK1JrTn86C+vNoe9uq/ufGvkOm0biVo4
	 Rheq7lXU/XCRKXZEtgR7Q3e+kHuCGtb5jcHM27nHS2OK9uogZu0WZFf4Kj6WkyOp/7
	 Ahe1WV+GB1kFUbr/lYPe7Aw/mjaKcXtWDgcA1zTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0049/1424] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Sat, 12 Sep 2026 08:41:21 +0200
Message-ID: <20260912065608.399916710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit aa0cf48a448c5a9fe1a1e880899ecd589ce39e6e upstream.

The header for commit e75b23f9e323 ("nfsd: check d_can_lookup in
fh_verify of directories") details the assumption that justified
adding the WARN_ON_ONCE to nfsd_mode_check(), that assumption is
invalid (in the case of NFS reexport).

When NFSD exports an NFS filesystem it is very possible for
nfsd_mode_check() to encounter a @dentry that doesn't have
i_op->lookup (see nfs_fhget()'s NFS_ATTR_FATTR_MOUNTPOINT and
NFS_ATTR_FATTR_V4_REFERRAL handling, and d_flags_for_inode()).

So remove nfsd_mode_check()'s WARN_ON_ONCE(). The nfserr_notdir
return on that branch must stay. It guards the subsequent
lookup_one_unlocked() -> __lookup_slow() path, which calls
inode->i_op->lookup() with no NULL check, so returning nfserr_notdir
is what keeps a client LOOKUP into such a @dentry from dereferencing
a NULL method pointer.

Fixes: e75b23f9e323 ("nfsd: check d_can_lookup in fh_verify of directories")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Link: https://patch.msgid.link/20260612191410.50177-1-snitzer@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -70,10 +70,8 @@ nfsd_mode_check(struct svc_rqst *rqstp,
 	if (requested == 0) /* the caller doesn't care */
 		return nfs_ok;
 	if (mode == requested) {
-		if (mode == S_IFDIR && !d_can_lookup(dentry)) {
-			WARN_ON_ONCE(1);
+		if (mode == S_IFDIR && !d_can_lookup(dentry))
 			return nfserr_notdir;
-		}
 		return nfs_ok;
 	}
 	/*


