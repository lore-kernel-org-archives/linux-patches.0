Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF662248A5;
	Tue, 26 Aug 2025 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207563; cv=none; b=YfUtlncdAn3ocdeF8Cz0Zmk0F98tvQvQ/NQpzl9dSpbHK5JPvreDG5ja9wvh0k136qTiDk3DrCQ2e3+yaem7Ub4yFYvw8cKHjrNbla/TBCCvI2p4IPPSUgRcZ13BoQ0j+Mtbf/dZjh7SezIhK71wAW1qhOyHJdEibS6ypQUKgWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207563; c=relaxed/simple;
	bh=LhEBcpz4vBEt/u80N10X/12Gq3zgfMX+IiQWmwk0Dbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQX2G4zVVrkfP/mOyStk/PkUpOtyY0HkVEqVMMlWG80A3BUh2Q2nz7pFBtV1Xx6nEQSRAWbrjwx27lj8DonEvqOgHh0Mm/rbJXJMkY3H3aXcgpQ8gArDGeUyYDtTJdtFgr1UEsqejvrg6qPkZGU1Ob/7qAz7E+NhWk6nyub/VOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTJ479Wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTJ479Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDDC4CEF1;
	Tue, 26 Aug 2025 11:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207563;
	bh=LhEBcpz4vBEt/u80N10X/12Gq3zgfMX+IiQWmwk0Dbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTJ479Wg/6xEY+Gkopov7QqUQ9kBi8bPGHkuIIyswb4caCgXaj++zFyFBX4SUbFV7
	 4SSS7X+Zr+pJmxPxE+bOiWk0PhG/3cEBDByCWgy7Iyb9/jUIJkLjt1QS5mD9fjXhOp
	 u+KzglTfBzPxu+fggjBMIeY5n5Cg+9dzS8tnOwVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 231/457] io_uring/futex: ensure io_futex_wait() cleans up properly on failure
Date: Tue, 26 Aug 2025 13:08:35 +0200
Message-ID: <20250826110943.083192979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 508c1314b342b78591f51c4b5dadee31a88335df upstream.

The io_futex_data is allocated upfront and assigned to the io_kiocb
async_data field, but the request isn't marked with REQ_F_ASYNC_DATA
at that point. Those two should always go together, as the flag tells
io_uring whether the field is valid or not.

Additionally, on failure cleanup, the futex handler frees the data but
does not clear ->async_data. Clear the data and the flag in the error
path as well.

Thanks to Trend Micro Zero Day Initiative and particularly ReDress for
reporting this.

Cc: stable@vger.kernel.org
Fixes: 194bb58c6090 ("io_uring: add support for futex wake and wait")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -288,6 +288,7 @@ int io_futex_wait(struct io_kiocb *req,
 		goto done_unlock;
 	}
 
+	req->flags |= REQ_F_ASYNC_DATA;
 	req->async_data = ifd;
 	ifd->q = futex_q_init;
 	ifd->q.bitset = iof->futex_mask;
@@ -309,6 +310,8 @@ done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
+	req->async_data = NULL;
+	req->flags &= ~REQ_F_ASYNC_DATA;
 	kfree(ifd);
 	return IOU_COMPLETE;
 }


