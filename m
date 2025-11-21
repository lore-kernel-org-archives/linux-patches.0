Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE70346E51;
	Fri, 21 Nov 2025 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731430; cv=none; b=Tmz7lb7hovrfIycbufC52Wd9Jj1/VPxa3YdiL9NCaTdHzKpl3HpjbmSQm66dRu4/KRrc51mWDeIJs1HIVmxlFhqGtANYYSu7tm4XXr/ygF6pAL2pnB0JkgqP3KBgBAKCXZo02vG/MiJt1701ayGJZd8kg+gkwkiezVrtRa87Dzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731430; c=relaxed/simple;
	bh=zuchb/h/MnQkxEqdz+6ctUXhdRr9Nm4sHzimHriEAD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF5aLgWstk23/lrq+ZMS8xtLg0mvmQnzi19f9/x3zO3ht1xYjyrpv+AZMefgz5ipbaEckY+Zw+3LgmxDDYIFURrnvxxammJ5X+SDOfR3tir6XW8/22L2upQYBWrWELyk8e0S34Z5qcm5BhB2pG7K++PH8njqUdlQCNIyHPqn9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIlI7HEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIlI7HEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077DDC4CEF1;
	Fri, 21 Nov 2025 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731430;
	bh=zuchb/h/MnQkxEqdz+6ctUXhdRr9Nm4sHzimHriEAD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIlI7HEhQKKK16m6OJ84gP51iQDbWtO71aljeZVhryEp3FKSEUVA79Y4/qn13CD4K
	 H8GJJiKv1D4Aor70IpJFrIxbMm8e7YcCwW8t2eq3haWzF4wqIQSJnr2Ri6t97JNFv3
	 Q2wQ+mDmJ1HYRFmQHPXW7nj+VU7vvvXt17u8QfD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 206/247] io_uring/rw: ensure allocated iovec gets cleared for early failure
Date: Fri, 21 Nov 2025 14:12:33 +0100
Message-ID: <20251121130202.118914412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit d3c9c213c0b86ac5dd8fe2c53c24db20f1f510bc upstream.

A previous commit reused the recyling infrastructure for early cleanup,
but this is not enough for the case where our internal caches have
overflowed. If this happens, then the allocated iovec can get leaked if
the request is also aborted early.

Reinstate the previous forced free of the iovec for that situation.

Cc: stable@vger.kernel.org
Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
Tested-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
Fixes: 9ac273ae3dc2 ("io_uring/rw: use io_rw_recycle() from cleanup path")
Link: https://lore.kernel.org/io-uring/69122a59.a70a0220.22f260.00fd.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -461,7 +461,10 @@ int io_read_mshot_prep(struct io_kiocb *
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
+	struct io_async_rw *rw = req->async_data;
+
 	lockdep_assert_held(&req->ctx->uring_lock);
+	io_vec_free(&rw->vec);
 	io_rw_recycle(req, 0);
 }
 


