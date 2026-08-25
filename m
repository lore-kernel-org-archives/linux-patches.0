Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5333FF8BA;
	Tue, 25 Aug 2026 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664814; cv=none; b=lGGzctvKGi8Hl0Y/RHGv/WjThXZ1RoBj3SgTgVUFfshEeZKMXnb5MERalygJOR4IAoqaY+W8ZY8TxpiBwcE+0mO7RYefQtVnCXcKmq66Re15bEKwCIDNHps8EfatUfU8or/KrZpnz83mjbIxxGi0JeCdPqjJe5/0SifryaU5dwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664814; c=relaxed/simple;
	bh=IKN5eiA41Q9/fc6ROZhTpu6Jc2LAlFLKHCcZGpasEyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peN/6EtF2s88a6xA+j00A8TwG4ssox45VtU1bxzrhEO0BN9fu4iHL1g3idWpdh93gerr5TbXW6Wmr/oJGfbzvzsVqavQpqiCK4co1EpCpomSCt17XJWHuLMm80YW044QOSdLtb+7FZayx8GlibGbQ4IvDTytjbV+Ekb7ArTcRY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0LpBfRF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0LpBfRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFDC1F000E9;
	Tue, 25 Aug 2026 13:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664813;
	bh=xMPI8ti5HbbksGu1QlJVpPEgG5aJ5ydP6Oh2r2xiQgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0LpBfRFWz62azazvLJ5JKthZxISxft1Rmc5D+R0q6oUjzxGQag/J3lXwkBowYC1n
	 JHGUOq/64P5rn8Wb2FlC8+fMwVnU9kpXo/cd6OIRPZr4RgvvVAlZQWylHyp16IzMeT
	 bVqj4yqHY/SMH7errGc2/pjy8IMhoF0o1qrGjIWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 014/101] io_uring/futex: only mark private futex waits as inflight
Date: Tue, 25 Aug 2026 15:24:52 +0200
Message-ID: <20260825132542.559308164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 4d327bbd1cd2485783553b6b2b401aa475f90dd0 upstream.

Inflight tracking of futex wait requests exists to ensure that do_exit()
-> io_uring_files_cancel() cancels them before the mm goes away, as a
private futex wait depends on the mm private futex hash staying alive
for the duration of the request.

Shared futexes have no such dependency. A FLAGS_SHARED request always
resolves to either an inode based key or an mm-shared key, both of which
fail futex_key_is_private() and hence always hash into the global futex
hash, whose lifetime isn't tied to the mm.

Only mark vectored futex waits as inflight if the futex is private.

Cc: stable@vger.kernel.org
Fixes: 079afb081c42 ("io_uring/futex: mark wait requests as inflight")
Link: https://lore.kernel.org/io-uring/CANGjgdn=R_qyUdE=j9za+vkmqcxacbP-84OHXF4nZ4ho9qRyVg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -154,14 +154,16 @@ int io_futex_prep(struct io_kiocb *req,
 
 int io_futex_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	int ret;
 
 	ret = io_futex_prep(req, sqe);
 	if (unlikely(ret))
 		return ret;
 
-	/* Mark as inflight, so file exit cancelation will find it */
-	io_req_track_inflight(req);
+	/* inflight tracking only needed for mm private hash */
+	if (!(iof->futex_flags & FLAGS_SHARED))
+		io_req_track_inflight(req);
 	return 0;
 }
 
@@ -186,6 +188,7 @@ int io_futexv_prep(struct io_kiocb *req,
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct io_futexv_data *ifd;
+	unsigned int i;
 	int ret;
 
 	/* No flags or mask supported for waitv */
@@ -210,8 +213,14 @@ int io_futexv_prep(struct io_kiocb *req,
 		return ret;
 	}
 
-	/* Mark as inflight, so file exit cancelation will find it */
-	io_req_track_inflight(req);
+	/* inflight tracking only needed for mm private hash */
+	for (i = 0; i < iof->futex_nr; i++) {
+		if (!(ifd->futexv[i].w.flags & FLAGS_SHARED)) {
+			io_req_track_inflight(req);
+			break;
+		}
+	}
+
 	iof->futexv_unqueued = 0;
 	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;


