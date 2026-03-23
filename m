Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26DC1DA0E1;
	Mon, 23 Mar 2026 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282874; cv=none; b=oruzDznhE1wjXIpsAo5GihlZnBEJ8uOOstZ83BRACb31RsIh05ykjyVFgj62oEzPrQfRXYpRAzf4Sah65dKWjNW6HpRLHMG2ZtxHhLbnS+uwAi9D4f4K6EX1TZmPsWuoeCvQAB5HGfv1Mc+wKLRODb1xDVTXf7gg4PazWD67DD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282874; c=relaxed/simple;
	bh=bwInDV4d/4W+KDHk3ZHzY48MzAg08fvjIDq8BtycXjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuMwnIQBygKu2OVpI0DRnd0qulAM5kWk6P2TTPsrfqMkcNg73DfA0p6z9/UD+nthcgW8nnln7o5tEUoK5Fk1huj8u7BtIKdRuuDu7xNscrpVfB2otkjdNU/usHUUb95PW2bwJGsQr0sRNxlLV1Liqb/cisDU/WDJsuEABIqSZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgCoHFIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgCoHFIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAAEC4CEF7;
	Mon, 23 Mar 2026 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282874;
	bh=bwInDV4d/4W+KDHk3ZHzY48MzAg08fvjIDq8BtycXjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgCoHFIaBIQYzGuXjul7EpOee3+XlMG3fOrq1f029jnNYHYvkzgaVnDSLX4Uw4m+D
	 TVMZDtB7Xd2nlXKpQC7aPgoaYdyGFFTd3p9k1z5eXtJqlhOeu+ffu+SG2atAVUvowr
	 ZtpvCe+x+glY/Paex0/M4Au2FcqlALaRaRvwur54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 281/481] io_uring/kbuf: check if target buffer list is still legacy on recycle
Date: Mon, 23 Mar 2026 14:44:23 +0100
Message-ID: <20260323134531.963769842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,9 +69,15 @@ void io_kbuf_recycle_legacy(struct io_ki
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
+	/*
+	 * If the buffer list was upgraded to a ring-based one, or removed,
+	 * while the request was in-flight in io-wq, drop it.
+	 */
+	if (bl && !bl->buf_nr_pages)
+		list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	req->buf_index = buf->bgid;
+	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return;


