Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAF63B47EF;
	Mon, 23 Mar 2026 15:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278892; cv=none; b=VQ2ucvV1OWamT1wVlo9ad5VtXB1r8WnjUCPHi3ToiN62z8QQyg32wnxU9oXU4PU5HLaZxBOi25MychMuToL5r1ehos0JpQnj7qrz1KeAjH7P7dq7MtD4FdvhN02I9eaUXXj+xNmbEB8PJFf/TAdZFdp6anCucbk+S6cM5cBC96Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278892; c=relaxed/simple;
	bh=DBwBLmFh7uyALA/BlGXhZYdvXXstYelndNh5QQNiRq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwEPnXwtETgAMOhWAUxtojTCCfqH7W0PMw+TztVF7uZL8FjdUksFATEos+umto6jPFMO/926wmJPN5uAMOPu3KD7IiJkSDoPC3I/FOHTnKhDSfb2RkDC1/XiNlVbLqfmeOvXaPsWSNjrlm08nnDrsIEKTZfkADa2NwoBKO4/o5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhkPOp9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhkPOp9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA26C4CEF7;
	Mon, 23 Mar 2026 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278891;
	bh=DBwBLmFh7uyALA/BlGXhZYdvXXstYelndNh5QQNiRq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhkPOp9h5B2ZYPsn53M0J5kBcXOWf2iTOyLKL5Bi9tH5RqnS4Ve9xN7OAJmNud8Pg
	 stNAGfkri/E4CI5PTngJV12OnYykVbO+jvluLz4gAP2jhYRM+obzax3JubEH/hx14L
	 hTJQ6ny6t52DyV4139MDJu9Kw9l3NxQE99n6jR/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 451/567] io_uring/kbuf: check if target buffer list is still legacy on recycle
Date: Mon, 23 Mar 2026 14:46:11 +0100
Message-ID: <20260323134545.142498692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/kbuf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -70,9 +70,15 @@ void io_kbuf_recycle_legacy(struct io_ki
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
+	/*
+	 * If the buffer list was upgraded to a ring-based one, or removed,
+	 * while the request was in-flight in io-wq, drop it.
+	 */
+	if (bl && !bl->is_mapped)
+		list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	req->buf_index = buf->bgid;
+	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return;


