Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB402264AB;
	Sat, 12 Sep 2026 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240925; cv=none; b=HjYkZ90MzaElm5v9tY0g7bF2kkIs52GyiUpWv1I9YjjiDHF02IWuao9+Rp31chjPLcBUQdoLx22+VCRVE0YdEK+ov6Ye5w1/hUgmJXhrFppFnUpAPOrRUC/pwpeQDcVSuzP6y+nWtL6A6JvzR1556mGAx7csdPQrvINiCZxO6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240925; c=relaxed/simple;
	bh=022RcbU7Muu2wv8YXlQzvwlZUP+1NPE5Nv7ojHEeJOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTJ+ty43pcsT0qiM6MF/jY5n/AuxP3LcHRk0TAtSioK3wiTgqAbUnL6r3qUaI7yxGq6DmdXQxzs983LPGtU/GULyk9lyxWN9S94gCwSyYj7+qx1joS2LA7UOAVqKr3/77sNtLcF8Yd19qaNyCVwF9EOOuqnx4U5vWilBO3KGwwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvB3uSn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvB3uSn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0BA1F000FF;
	Sat, 12 Sep 2026 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240924;
	bh=702d2z+OgCbstKfukgCXfXwMOwtnq9hY7ph6+6xyVu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvB3uSn4o3vSSB30SP7Fc6kwSEdOt+ulJQq87u2rVd0/FNZtBTAnPOVJmtf/CZ0Xr
	 j5y1EAXvGn1/KIL7MlaIEh0Y0eLudnGQZqorPxsbxIcGEl53jk/RoiWfANK4mQ5Tu/
	 MVojJVGmBO3pjkwRWSYKGv8c+XoBO5olA7lC+r+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 031/798] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Sat, 12 Sep 2026 08:54:19 +0200
Message-ID: <20260912065517.675468505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,10 +69,8 @@ nfsd_mode_check(struct svc_rqst *rqstp,
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


