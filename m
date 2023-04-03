Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0AC6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88ADEC4339B;
	Mon,  3 Apr 2023 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532039;
	bh=FbWs3/rnsgWgG4PG1OBE6yvXyVbm/3yff3q5d1C6b+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9oFyz1oANotCrkVHnrrRaiu5/rbgQGnkcqgFrzTf4fL8XJwNdTi3P17FcMzCtb2j
	 F2LP1eKWvS1FS7A+cwv8gIyGaMokk0P+bZhGtQgXk93M1fXePZmpEdty4iKsSvXLPA
	 25+hYA55bdUqaAmmMzE5h8mtafyJPS1Ac1Sg4Fvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 103/173] NFSD: fix use-after-free in __nfs42_ssc_open()
Date: Mon,  3 Apr 2023 16:08:38 +0200
Message-Id: <20230403140417.773920681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dai Ngo <dai.ngo@oracle.com>

commit 75333d48f92256a0dec91dbf07835e804fc411c0 upstream.

Problem caused by source's vfsmount being unmounted but remains
on the delayed unmount list. This happens when nfs42_ssc_open()
return errors.

Fixed by removing nfsd4_interssc_connect(), leave the vfsmount
for the laundromat to unmount when idle time expires.

We don't need to call nfs_do_sb_deactive when nfs42_ssc_open
return errors since the file was not opened so nfs_server->active
was not incremented. Same as in nfsd4_copy, if we fail to
launch nfsd4_do_async_copy thread then there's no need to
call nfs_do_sb_deactive

Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1248,13 +1248,6 @@ out_err:
 	return status;
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-	nfs_do_sb_deactive(ss_mnt->mnt_sb);
-	mntput(ss_mnt);
-}
-
 /*
  * Verify COPY destination stateid.
  *
@@ -1325,11 +1318,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount
 {
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-}
-
 static struct file *nfs42_ssc_open(struct vfsmount *ss_mnt,
 				   struct nfs_fh *src_fh,
 				   nfs4_stateid *stateid)
@@ -1471,14 +1459,14 @@ static int nfsd4_do_async_copy(void *dat
 		copy->nf_src = kzalloc(sizeof(struct nfsd_file), GFP_KERNEL);
 		if (!copy->nf_src) {
 			copy->nfserr = nfserr_serverfault;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 		copy->nf_src->nf_file = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
 					      &copy->stateid);
 		if (IS_ERR(copy->nf_src->nf_file)) {
 			copy->nfserr = nfserr_offload_denied;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 	}
@@ -1561,8 +1549,10 @@ out_err:
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	if (!copy->cp_intra)
-		nfsd4_interssc_disconnect(copy->ss_mnt);
+	/*
+	 * source's vfsmount of inter-copy will be unmounted
+	 * by the laundromat
+	 */
 	goto out;
 }
 


