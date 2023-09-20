Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803AA2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02017C433C8;
	Wed, 20 Sep 2023 11:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211179;
	bh=cxctGXoh3RQOuRQSt2Tuc+jLg86zDLq9K6xJWswj7/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z70fPiRbJdjEwe4lJD1/hrxHCoNoLNCwYs72NqynuIX0xv3fcJJUpD+FmqExSECOq
	 hOa9NwIKCL4cHXDfJDxyBmlWkMETxGrle4z0LfVHzDmunsN9PQ6BBRmKhw6/3Dm1Tb
	 fC/ydMlIxR9s9ydruTUUDEW+2syeInLkPKz2iJvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 112/139] ovl: fix incorrect fdput() on aio completion
Date: Wed, 20 Sep 2023 13:30:46 +0200
Message-ID: <20230920112839.739251626@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 724768a39374d35b70eaeae8dd87048a2ec7ae8e upstream.

ovl_{read,write}_iter() always call fdput(real) to put one or zero
refcounts of the real file, but for aio, whether it was submitted or not,
ovl_aio_put() also calls fdput(), which is not balanced.  This is only a
problem in the less common case when FDPUT_FPUT flag is set.

To fix the problem use get_file() to take file refcount and use fput()
instead of fdput() in ovl_aio_put().

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Cc: <stable@vger.kernel.org> # v5.6
Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/file.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,7 +19,6 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
-	struct fd fd;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -260,7 +259,7 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
 static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
 {
 	if (refcount_dec_and_test(&aio_req->ref)) {
-		fdput(aio_req->fd);
+		fput(aio_req->iocb.ki_filp);
 		kmem_cache_free(ovl_aio_request_cachep, aio_req);
 	}
 }
@@ -325,10 +324,9 @@ static ssize_t ovl_read_iter(struct kioc
 		if (!aio_req)
 			goto out;
 
-		aio_req->fd = real;
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
-		kiocb_clone(&aio_req->iocb, iocb, real.file);
+		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		refcount_set(&aio_req->ref, 2);
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
@@ -396,10 +394,9 @@ static ssize_t ovl_write_iter(struct kio
 		/* Pacify lockdep, same trick as done in aio_write() */
 		__sb_writers_release(file_inode(real.file)->i_sb,
 				     SB_FREEZE_WRITE);
-		aio_req->fd = real;
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
-		kiocb_clone(&aio_req->iocb, iocb, real.file);
+		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		refcount_set(&aio_req->ref, 2);


