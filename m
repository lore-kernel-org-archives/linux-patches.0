Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D054FA5;
	Tue, 27 Feb 2024 13:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040904; cv=none; b=mopLpkOTVbHmO6F/DpmQHi2KeY7MAF0lb4DR8IbNcGuTas5UjbQE/0hjvUc34scAG+gWJVOLvZn7a56Rm2qVYd7OCXvcPv6eCWpWswUh6ZCd8VGkQjT9pK8tWrjYBrEi6TYS2CLexRKXzeUho//QkbteOtHMjpZGl16RV5fSonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040904; c=relaxed/simple;
	bh=iijDB/mJQeCn4vpkJfXG9gW6I2uNA2PxlNC5B+2WAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZqzmVtamuosqmcGz6azI9H+fgPZqG3wc5tee/8EMG9/gsYJS5fPgcRju8xO8Di0CrDrjS63KEqcyk2yFI2HYy9iwHjjAMZ8rMYGgGccCtVj6ColWS2+aqLgtFj6t/3m6J+AhFgcODd0cYmH0+dxhA3DKylDQJlu4OrUPSPEfHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfiQj92y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfiQj92y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A113CC433C7;
	Tue, 27 Feb 2024 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040904;
	bh=iijDB/mJQeCn4vpkJfXG9gW6I2uNA2PxlNC5B+2WAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfiQj92yix4eAyAm3EsfWKTn1rLSIET9b3pEdkWhmx4v+O1wVlsxNDgCs8uONTrtJ
	 miGd3JBIWxyW/qifC1LqO7qH6pIpp3QHDrPNgTM2jwg3/zNd+1xMTKo6uNSmUvf0tF
	 QzbGikM1laProDTxgBeLjv7x+3rU/ajKIrpWc0OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 123/334] ceph: always check dir caps asynchronously
Date: Tue, 27 Feb 2024 14:19:41 +0100
Message-ID: <20240227131634.440958463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 07045648c07c5632e0dfd5ce084d3cd0cec0258a ]

The MDS will issue the 'Fr' caps for async dirop, while there is
buggy in kclient and it could miss releasing the async dirop caps,
which is 'Fsxr'. And then the MDS will complain with:

"[WRN] client.xxx isn't responding to mclientcaps(revoke) ..."

So when releasing the dirop async requests or when they fail we
should always make sure that being revoked caps could be released.

Link: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c       | 6 ------
 fs/ceph/mds_client.c | 9 ++++-----
 fs/ceph/mds_client.h | 2 +-
 fs/ceph/super.h      | 2 --
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e8bf082105d87..ad1f46c66fbff 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3216,7 +3216,6 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 
 enum put_cap_refs_mode {
 	PUT_CAP_REFS_SYNC = 0,
-	PUT_CAP_REFS_NO_CHECK,
 	PUT_CAP_REFS_ASYNC,
 };
 
@@ -3332,11 +3331,6 @@ void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)
 	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_ASYNC);
 }
 
-void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
-{
-	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_NO_CHECK);
-}
-
 /*
  * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
  * context.  Adjust per-snap dirty page accounting as appropriate.
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 558c3af44449c..2eb66dd7d01b2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1089,7 +1089,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	struct ceph_mds_request *req = container_of(kref,
 						    struct ceph_mds_request,
 						    r_kref);
-	ceph_mdsc_release_dir_caps_no_check(req);
+	ceph_mdsc_release_dir_caps_async(req);
 	destroy_reply_info(&req->r_reply_info);
 	if (req->r_request)
 		ceph_msg_put(req->r_request);
@@ -4247,7 +4247,7 @@ void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
 	}
 }
 
-void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req)
+void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req)
 {
 	struct ceph_client *cl = req->r_mdsc->fsc->client;
 	int dcaps;
@@ -4255,8 +4255,7 @@ void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req)
 	dcaps = xchg(&req->r_dir_caps, 0);
 	if (dcaps) {
 		doutc(cl, "releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
-		ceph_put_cap_refs_no_check_caps(ceph_inode(req->r_parent),
-						dcaps);
+		ceph_put_cap_refs_async(ceph_inode(req->r_parent), dcaps);
 	}
 }
 
@@ -4292,7 +4291,7 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
 		if (req->r_session->s_mds != session->s_mds)
 			continue;
 
-		ceph_mdsc_release_dir_caps_no_check(req);
+		ceph_mdsc_release_dir_caps_async(req);
 
 		__send_request(session, req, true);
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 2e6ddaa13d725..40560af388272 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -552,7 +552,7 @@ extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
 				struct inode *dir,
 				struct ceph_mds_request *req);
 extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
-extern void ceph_mdsc_release_dir_caps_no_check(struct ceph_mds_request *req);
+extern void ceph_mdsc_release_dir_caps_async(struct ceph_mds_request *req);
 static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
 {
 	kref_get(&req->r_kref);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index fe0f64a0acb27..15d00bdd92065 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1254,8 +1254,6 @@ extern void ceph_take_cap_refs(struct ceph_inode_info *ci, int caps,
 extern void ceph_get_cap_refs(struct ceph_inode_info *ci, int caps);
 extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had);
-extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
-					    int had);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
 extern void __ceph_remove_capsnap(struct inode *inode,
-- 
2.43.0



