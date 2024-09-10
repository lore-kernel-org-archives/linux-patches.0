Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FF18DF88;
	Tue, 10 Sep 2024 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964934; cv=none; b=ojjNmIz/u66jg/CDI3gXW4EIf+J2Pe9rXLZwcUkDv5afAfG25bSSHXnfL6ASe94yixiajvFH4OZtuTLyWkNWRFlc/ybcvSdANkjpWjXxhNYzjnYJgsaoSloDCf/+QHocVxJRZIoPVQVx16sWiz909dmEBuSq1+q5IEI43voExE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964934; c=relaxed/simple;
	bh=HaZK9IqnXQ7g4xuoE8sgyLlwKBMo7Lb8uVdFDSxIRMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbZ0MWSCBnt6hsQZsT1J8xUP6EI+pbhWREkvtQGtX+1L5cQOKyoBECeq2V8Ajf/C8Yo0q+ZgJ4h3yA0hZ+fEY0FBkyV1U0b/Z2t7z64sh8Q+YSdqFyKmmMK3OKLij/MPjy/9XLz1iIGM0jH8eKPanzFdpajaAFmbiT52agF8FBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nq9R1SXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nq9R1SXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760E9C4CEC3;
	Tue, 10 Sep 2024 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964933;
	bh=HaZK9IqnXQ7g4xuoE8sgyLlwKBMo7Lb8uVdFDSxIRMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nq9R1SXnS5+/9xK+0GiuTBvHlNiVbw1s6u5qK+eI6kjeIWEli83LZN56Uoe2Z7nXV
	 Vi6PAtrctYx1LB+T40+blV2gATphNXA2Obkq1ov8W3iUWjm83eMXy+Z34IYDyrNYUE
	 kXUuqZdruRwdl+ozBKxQ1v8Hgg1ZHlssyyYUhDuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 080/186] NFSD: Refactor nfsd_reply_cache_free_locked()
Date: Tue, 10 Sep 2024 11:32:55 +0200
Message-ID: <20240910092557.808254750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 35308e7f0fc3942edc87d9c6dc78c4a096428957 ]

To reduce contention on the bucket locks, we must avoid calling
kfree() while each bucket lock is held.

Start by refactoring nfsd_reply_cache_free_locked() into a helper
that removes an entry from the bucket (and must therefore run under
the lock) and a second helper that frees the entry (which does not
need to hold the lock).

For readability, rename the helpers nfsd_cacherep_<verb>.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: a9507f6af145 ("NFSD: Replace nfsd_prune_bucket()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -110,21 +110,33 @@ nfsd_reply_cache_alloc(struct svc_rqst *
 	return rp;
 }
 
+static void nfsd_cacherep_free(struct svc_cacherep *rp)
+{
+	if (rp->c_type == RC_REPLBUFF)
+		kfree(rp->c_replvec.iov_base);
+	kmem_cache_free(drc_slab, rp);
+}
+
 static void
-nfsd_reply_cache_free_locked(struct nfsd_drc_bucket *b, struct svc_cacherep *rp,
-				struct nfsd_net *nn)
+nfsd_cacherep_unlink_locked(struct nfsd_net *nn, struct nfsd_drc_bucket *b,
+			    struct svc_cacherep *rp)
 {
-	if (rp->c_type == RC_REPLBUFF && rp->c_replvec.iov_base) {
+	if (rp->c_type == RC_REPLBUFF && rp->c_replvec.iov_base)
 		nfsd_stats_drc_mem_usage_sub(nn, rp->c_replvec.iov_len);
-		kfree(rp->c_replvec.iov_base);
-	}
 	if (rp->c_state != RC_UNUSED) {
 		rb_erase(&rp->c_node, &b->rb_head);
 		list_del(&rp->c_lru);
 		atomic_dec(&nn->num_drc_entries);
 		nfsd_stats_drc_mem_usage_sub(nn, sizeof(*rp));
 	}
-	kmem_cache_free(drc_slab, rp);
+}
+
+static void
+nfsd_reply_cache_free_locked(struct nfsd_drc_bucket *b, struct svc_cacherep *rp,
+				struct nfsd_net *nn)
+{
+	nfsd_cacherep_unlink_locked(nn, b, rp);
+	nfsd_cacherep_free(rp);
 }
 
 static void
@@ -132,8 +144,9 @@ nfsd_reply_cache_free(struct nfsd_drc_bu
 			struct nfsd_net *nn)
 {
 	spin_lock(&b->cache_lock);
-	nfsd_reply_cache_free_locked(b, rp, nn);
+	nfsd_cacherep_unlink_locked(nn, b, rp);
 	spin_unlock(&b->cache_lock);
+	nfsd_cacherep_free(rp);
 }
 
 int nfsd_drc_slab_create(void)


