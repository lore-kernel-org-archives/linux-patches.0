Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89E13F9F2F;
	Fri,  4 Sep 2026 05:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498664; cv=none; b=FL0tXGWwywZWG4TtTZbCKAD/aFOtWxFRHBhZnK7y67RaSE2bHv6wWcXkkWI9xS4UbvuU+udvp6PrwG9bPZQDALpAx4SU5v90XaBWsB43nQCA0TczvEC4CFafRAPfmUvyOVJCdhx3BAkwAoEibc1KVdfefPqfsNAp9WwI5KS4MZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498664; c=relaxed/simple;
	bh=XhgQiucMw4eWCtbkeDb2GTPQKI16x0R4Vm2/C81bGYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGdTIaq0XqP1jkVbN9lIIVe30ycx/9bEjXeJN05Ij6r5Pyya9eW6s5uVybXFegtflOk+xoWCeuXT9qOWIRpku4QwGAZ8IWinc99ezSRxlRrjj62n7QkDwryZrlS8a8548XqTZnqi+4RBhQrpW3l7yCEtgfQ8wR57qHu4LGUBiTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15ccJQdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15ccJQdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198421F00A3D;
	Fri,  4 Sep 2026 05:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498663;
	bh=XeYpvgSI4mMKaj0QfbHylLGTto1fe6MMCTlfa50x7xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15ccJQdq4m+JLTh18Yw7rgiRXtm0VtLmFNDM3YUUKslVDdxZycl7b3z5y3IH68TSg
	 O2YjtFvXgFDdzEjffEEIhcq10BVww/LedpPJ3FALUPT9WznfNh0GER3Qxon70YJDY9
	 kCXc6mNs5PT7pt4pg+dVi90vXH7LwKFR5tu9DKE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 143/713] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Fri,  4 Sep 2026 06:51:51 +0200
Message-ID: <20260904045807.034693896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,10 +70,8 @@ nfsd_mode_check(struct dentry *dentry, u
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
 	if (mode == S_IFLNK) {


