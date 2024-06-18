Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0CD13DDDF;
	Tue, 18 Jun 2024 12:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714808; cv=none; b=cyFKTGJrHcgjQFBNZAPfEVTX7I0HGpviYkBWwFU/CY6Ld+p49agL0Acv/ycyfz2zbCf6O/AJX4seLT+weB6iqgzGoUsGStTb8snf+QIvOxbqYBJDyjpaeLmH1V9blCP/+XQfgOFdYCC64CSuQzXBEU7FHjN2qLSl0x4bhVOsDWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714808; c=relaxed/simple;
	bh=ZyNWOfZf0e5wBPFccDSjwIyUoXGzEuHctzqNXaRhnLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7qbck/1gfcSxNlnntu/yqqaBkHmje3xNZGhyto8NnDgDYPoq0jQGdJaTk31iWj/fMwExsfb4bpWUGVRvL8P0SXyVUjCqyJw1Bl7ks5uueCmWqDau7yEFHnfCCDxPhRTzuos7aXt379FIxzl0mHignJQmqFrfz9jqgSlqArV+Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtyP+yNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtyP+yNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037B9C3277B;
	Tue, 18 Jun 2024 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714808;
	bh=ZyNWOfZf0e5wBPFccDSjwIyUoXGzEuHctzqNXaRhnLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtyP+yNVvZT388p3C0Yr0EvNfH9L2RRvzQOu07XmK53uAl0edwwDzdVti8TmKeB0T
	 7+U0vkicZ+tTHazLXxy1mJA1QIEjBjw4w9dpTooMyiVrx83xoXYkZCxS5G6qaNUYAG
	 pQrTHqGKdeEySX5WPqCB/OsvNzahl2JWc8uK0324=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/770] nfsd: simplify nfsd4_change_info
Date: Tue, 18 Jun 2024 14:29:08 +0200
Message-ID: <20240618123410.940379012@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit b2140338d8dca827ad9e83f3e026e9d51748b265 ]

It doesn't make sense to carry all these extra fields around.  Just
make everything into change attribute from the start.

This is just cleanup, there should be no change in behavior.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 ++---------
 fs/nfsd/xdr4.h    | 11 -----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index bdcfb5f7021da..4df6c75d0eb7f 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2459,15 +2459,8 @@ static __be32 *encode_time_delta(__be32 *p, struct inode *inode)
 static __be32 *encode_cinfo(__be32 *p, struct nfsd4_change_info *c)
 {
 	*p++ = cpu_to_be32(c->atomic);
-	if (c->change_supported) {
-		p = xdr_encode_hyper(p, c->before_change);
-		p = xdr_encode_hyper(p, c->after_change);
-	} else {
-		*p++ = cpu_to_be32(c->before_ctime_sec);
-		*p++ = cpu_to_be32(c->before_ctime_nsec);
-		*p++ = cpu_to_be32(c->after_ctime_sec);
-		*p++ = cpu_to_be32(c->after_ctime_nsec);
-	}
+	p = xdr_encode_hyper(p, c->before_change);
+	p = xdr_encode_hyper(p, c->after_change);
 	return p;
 }
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index e12fbe382e3f3..b4556e86e97c3 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -76,12 +76,7 @@ static inline bool nfsd4_has_session(struct nfsd4_compound_state *cs)
 
 struct nfsd4_change_info {
 	u32		atomic;
-	bool		change_supported;
-	u32		before_ctime_sec;
-	u32		before_ctime_nsec;
 	u64		before_change;
-	u32		after_ctime_sec;
-	u32		after_ctime_nsec;
 	u64		after_change;
 };
 
@@ -754,15 +749,9 @@ set_change_info(struct nfsd4_change_info *cinfo, struct svc_fh *fhp)
 {
 	BUG_ON(!fhp->fh_pre_saved);
 	cinfo->atomic = (u32)fhp->fh_post_saved;
-	cinfo->change_supported = IS_I_VERSION(d_inode(fhp->fh_dentry));
 
 	cinfo->before_change = fhp->fh_pre_change;
 	cinfo->after_change = fhp->fh_post_change;
-	cinfo->before_ctime_sec = fhp->fh_pre_ctime.tv_sec;
-	cinfo->before_ctime_nsec = fhp->fh_pre_ctime.tv_nsec;
-	cinfo->after_ctime_sec = fhp->fh_post_attr.ctime.tv_sec;
-	cinfo->after_ctime_nsec = fhp->fh_post_attr.ctime.tv_nsec;
-
 }
 
 
-- 
2.43.0



