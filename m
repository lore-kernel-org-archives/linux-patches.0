Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED333101BF;
	Thu, 16 Jul 2026 13:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210284; cv=none; b=Y2vEFp2o8l7T0Y44+RuhzI1j5purxu6OWnoT55L+KI9cgojfNzukS9hORsy9by4932GPZbQ2utGHPRNizQExXkgH786Trn63RJyecJ8i4wi4x3f31xHE9zfrUap928PuaCWHmMTgPhD+HoszsmSwOzgLtkfqJYeUmL+w01yzuZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210284; c=relaxed/simple;
	bh=DJeUomWBi14GJ2ghbaoYpH/kkw9ZPIHd8h2a3LrilAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0nuZC7lgedUAGPgXB3p7AloSCFSPk8WWoWbrupXKKCbyWULkCioB7TISS68f9o2EMvfIZ95vJIMpJIR9oDioNCcG2qYHMWa/zPDdBlCq+VXx+cocgAlHhPBLfGOStsCCb+6d9FEj+5Q5LCyn4ObxzgxuWoLiDt5CJ710MLnGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x09fUB+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x09fUB+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBD41F000E9;
	Thu, 16 Jul 2026 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210282;
	bh=IFaNUUVW3zzIrBuYmHRuTzCuuE3pyS39JFiJ6MgobsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x09fUB+NYMeKjVnlbW6tjWqzZpmDWbIJtJhTpehdCsBSgI0ggq+xRhAR7UOGG2lpM
	 2VWkG9ATW9wgUoy/gCjABAI46sYvBJMrjCnf1iWXEYCury1ZTphZ6UcwcV+lGIYNib
	 qnuuPdgdgVPiXLdEruUmEQvZ8M7pmaQkQiE5atco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 508/518] fuse-uring: fix EFAULT clobber in fuse_uring_commit
Date: Thu, 16 Jul 2026 15:32:56 +0200
Message-ID: <20260716133058.955490277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit 3a0a8bc51a13951c5141262bf770eeea3e0b6228 upstream.

copy_from_user() returns the number of bytes not copied as an unsigned
residual on failure (1..sizeof(struct fuse_out_header)). fuse_uring_commit
stores that residual in ssize_t err, sets req->out.h.error to -EFAULT,
then jumps to out: with err still holding the positive residual.

    err = copy_from_user(&req->out.h, &ent->headers->in_out,
                         sizeof(req->out.h));
    if (err) {
        req->out.h.error = -EFAULT;
        goto out;          /* err is the positive residual */
    }
    ...
    out:
        fuse_uring_req_end(ent, req, err);

fuse_uring_req_end() then runs

    if (error)
        req->out.h.error = error;

which overwrites the just-assigned -EFAULT with the positive residual.
FUSE callers such as fuse_simple_request() test err < 0 to detect
failure, so the positive value is interpreted as success and the
caller proceeds with an uninitialised or partial req->out.args.

Fix by assigning err = -EFAULT in the failure branch before jumping
to out, so fuse_uring_req_end() receives a negative errno and sets
req->out.h.error to -EFAULT.

Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@vger.kernel.org
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev_uring.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -814,14 +814,11 @@ static void fuse_uring_commit(struct fus
 {
 	struct fuse_ring *ring = ent->queue->ring;
 	struct fuse_conn *fc = ring->fc;
-	ssize_t err = 0;
+	ssize_t err = -EFAULT;
 
-	err = copy_from_user(&req->out.h, &ent->headers->in_out,
-			     sizeof(req->out.h));
-	if (err) {
-		req->out.h.error = -EFAULT;
+	if (copy_from_user(&req->out.h, &ent->headers->in_out,
+			   sizeof(req->out.h)))
 		goto out;
-	}
 
 	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
 	if (err) {


