Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51770400981;
	Thu, 16 Jul 2026 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211586; cv=none; b=ciXcKEVYBOFdCt6gnChjAJ4hQsMcFErvBelmNDl+7j+Y4eJ5CBzMX7NQ2dOu7X6pjoYC/P16R2CMlqRYUcn7YQ9ph9Sz1oanTx9NpGpgiTAZJY65vODK7dqLdmfdtaqhwJDH6ocxo8YNWBZKKdeiIW/I0R1Q86g/vVVbX4p1SfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211586; c=relaxed/simple;
	bh=CmgPhHPE3hd7ndJvgZE39wAtZdTXlEvSJhUALpqIqcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXVeQnnWDWEHlp/gT5w0wNsiL7SYkUv5WiQynLmtBmm7YZLtXEcbHEcoa83XsUnerLyQHTh2Vgysb4k1/vuwPY7eJryrT40L94+r3+aTcQC4l9LMN0jZ5uuWX74pGXRk/zr4b/sCp43+bR8maXJb1qkcPHr9lUx29jOPBU2e/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RU1swBKW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RU1swBKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65631F000E9;
	Thu, 16 Jul 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211585;
	bh=OdTVjgUdMAHolZsKJHiXv7CVWvG39tVlBYRmTH1wZGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RU1swBKWeLLIKbfCWdjpbX9A2HATQQYdVGPUErY9p3GzUcsE5dU3NJ7CAO1dzHQob
	 TabwncY/14so2zY+9rTkOAXxtbz6YLGWspbVJwZ/xdT56e2h/cgwGMJzAnUVrDaTB5
	 +9dp4OfYqj3SpvxqfkZwF1l+9g0y3VemBoUidorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Chris Mason <clm@meta.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 468/480] fuse-uring: fix EFAULT clobber in fuse_uring_commit
Date: Thu, 16 Jul 2026 15:33:35 +0200
Message-ID: <20260716133054.945722037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -818,14 +818,11 @@ static void fuse_uring_commit(struct fus
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


