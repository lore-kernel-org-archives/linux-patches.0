Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697963D6664;
	Fri,  4 Sep 2026 05:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498816; cv=none; b=TtKilj7nM5k83trbaiQGpp35ZOrrPwKJPlZRHf21mV6jjOJSidFc6UZcHRg0PVTCMsUDf69p3bp91yrCxwKRkgm5BScmaqX20tNB8T6GUJY2IKz8grczSAL43v2TWyrMjZ1ijlu/BFpvoz2CmgHAKj0cw9kuJKygAEcDHXJTodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498816; c=relaxed/simple;
	bh=3bpp87QKm2GVtQjqBWgXjBwL3qx8kL0geYCl1yzsxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5abgHjFzj0FZtvhtPt5hbTRrbFc6GuIPCIfN8D2ixOeMdSpYZwVXHKLQCWJlCD14q6tI5pnut6jb+xnIJRHwThQVKhmeDIxVcUY2teHBFuk5QoxT8Mhowb1I6OihdaWfbqtyvnzR29fSQSVMVFnqwkM8BR2Ub35H22CEzDm1P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVIX0OLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVIX0OLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35E41F00A3D;
	Fri,  4 Sep 2026 05:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498815;
	bh=VXi8N/vnPT3Og32RNWDfuoU6lKdtUigga1JUrbhr7QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVIX0OLocPEufi0TqDYbOelACNYJVFo8GB29J4tPqpso12+SmukmVLfBJbtmNEvqe
	 K1yTsMxaNSOuXxYjqOIEGbaTYr4x+PeZOexrKxZSC9fY46PZ9C6ng2mIwZq1c86QI5
	 TIPvXM6Qbb5WXnT7suZqMX4lXxHpCOjqRDs/gF2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 197/713] nfsd: hold rcu across localio cmpxchg retry
Date: Fri,  4 Sep 2026 06:52:45 +0200
Message-ID: <20260904045808.227891292@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 58884694978a3d7d111edb433d7fd6a6c5af2f34 upstream.

nfsd_file objects are freed via call_rcu (filecache.c:296), and
nfsd_file_slab is created without SLAB_TYPESAFE_BY_RCU
(KMEM_CACHE(nfsd_file, 0) at filecache.c:789), so the slab page
backing a freed nfsd_file becomes freely reclaimable once the RCU
grace period elapses.

The again: retry block in nfsd_open_local_fh() loads a pointer with
cmpxchg and then calls nfsd_file_get(new) (which is
refcount_inc_not_zero) without holding rcu_read_lock. The sole caller
nfs_open_local_fh() drops rcu_read_lock before invoking this helper,
so no outer reader-side critical section covers the load.

    CPU 0 (nfsd_open_local_fh)        CPU 1 (nfsd_file_put_local)
    -----                             -----
    new = cmpxchg(pnf, NULL, ...)
                                      nf = xchg(pnf, NULL)
                                      nfsd_file_put(nf)
                                        last ref -> call_rcu()
                                      /* grace period elapses;
                                         slab page recycled */
    nfsd_file_get(new)
      refcount_inc_not_zero(&new->nf_ref)
      /* operates on recycled memory */

A non-zero word at the nf_ref offset of the recycled object makes the
refcount bump appear to succeed, and the caller then dereferences
new->nf_net and new->nf_file out of freed memory.

Fix by taking rcu_read_lock() immediately before the cmpxchg and
releasing it on all three exits of the if (new) block: the goto-again
retry, the lost-race cleanup path, and the install-succeeded path.
nfsd_file_put() and nfsd_net_put() stay outside the RCU section so
they remain free to block.

Fixes: e6f7e1487ab5 ("nfs_localio: simplify interface to nfsd for getting nfsd_file")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-2-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/localio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -97,11 +97,15 @@ nfsd_open_local_fh(struct net *net, stru
 		}
 		nfsd_file_get(localio);
 	again:
+		rcu_read_lock();
 		new = unrcu_pointer(cmpxchg(pnf, NULL, RCU_INITIALIZER(localio)));
 		if (new) {
 			/* Some other thread installed an nfsd_file */
-			if (nfsd_file_get(new) == NULL)
+			if (nfsd_file_get(new) == NULL) {
+				rcu_read_unlock();
 				goto again;
+			}
+			rcu_read_unlock();
 			/*
 			 * Drop the ref we were going to install (both file and
 			 * net) and the one we were going to return (only file).
@@ -110,6 +114,8 @@ nfsd_open_local_fh(struct net *net, stru
 			nfsd_net_put(net);
 			nfsd_file_put(localio);
 			localio = new;
+		} else {
+			rcu_read_unlock();
 		}
 	} else
 		nfsd_net_put(net);


