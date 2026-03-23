Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E33AF643;
	Mon, 23 Mar 2026 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277033; cv=none; b=iqLu99YYlp0DLeBEtbe7SGSE8iLyPkMue/afJtrru29i+uHMMyujTT5+O2ysexEarkCskxbdlIj6TDOiEma0nvZkJOph6xFZUv9fsNMpNREccd50G7U8srp90ahclmQ+3dj8hHXNKLqaVkCXyHrLQFjNXYo70M0mxImudikU7P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277033; c=relaxed/simple;
	bh=Dlgz1hQDmwir1+6zLcC89BTwZEFzRrd0Vfs+XDvoYAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lY1AV2ij+tiNQQpPv2SiDsNIg/aZHhhA7QuGH+TttYb6bSyp+VtYboHLQB9w+ikJtEf46dcXcM3m2f5xXYeypZL3o+Hbfxj5HHQMJ7QPMYJufx6SbydeTuf7j4uP9wQIqL44JbPtG51Im9wnzJinCIfWPjEb+IzDKkNQC5wjmew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/d997k0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/d997k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA7EC2BCB3;
	Mon, 23 Mar 2026 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277033;
	bh=Dlgz1hQDmwir1+6zLcC89BTwZEFzRrd0Vfs+XDvoYAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/d997k0kYTxT1/NB2Cez/pdb8mpS/qgFgLzZajHgQt0ONvssjgXv/ftMv93k7E6R
	 UNzoGlbj7/RVBpoMWtP2xjSb7JMbp8azWEuekly+RVfTyMsaFzsfEQtCzCemX9yF9O
	 XLXBxa5eTQkwA/6k1iXyht6orjmRKW1YXijwnueE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 297/460] io_uring/kbuf: check if target buffer list is still legacy on recycle
Date: Mon, 23 Mar 2026 14:44:53 +0100
Message-ID: <20260323134533.782553626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit c2c185be5c85d37215397c8e8781abf0a69bec1f upstream.

There's a gap between when the buffer was grabbed and when it
potentially gets recycled, where if the list is empty, someone could've
upgraded it to a ring provided type. This can happen if the request
is forced via io-wq. The legacy recycling is missing checking if the
buffer_list still exists, and if it's of the correct type. Add those
checks.

Cc: stable@vger.kernel.org
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -62,9 +62,17 @@ bool io_kbuf_recycle_legacy(struct io_ki
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
-	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	/*
+	 * If the buffer list was upgraded to a ring-based one, or removed,
+	 * while the request was in-flight in io-wq, drop it.
+	 */
 	req->buf_index = buf->bgid;
+	if (bl && !(bl->flags & IOBL_BUF_RING))
+		list_add(&buf->list, &bl->buf_list);
+	else
+		kmem_cache_free(io_buf_cachep, buf);
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return true;


