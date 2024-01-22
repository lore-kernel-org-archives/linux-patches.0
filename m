Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DAC745EE;
	Tue, 23 Jan 2024 02:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975457; cv=none; b=SmwshWoffvoGVXUKaaDLEj88IOt407hGDfIe8fZkZ9tEPucitVxIWV6aY7DPWyD2k6ccA3+OhXnjLv47hB7ydU8FogGvOd6haCwBb/Jx+I9KW2GObi7yT3WwsW8xGjOk9Ni1vhqtKYIccLVV5pZJ6UkBb4ho9BTfJLGAQKS4CRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975457; c=relaxed/simple;
	bh=RtorUI8bAyUJb0pcjEn4niUPVhxIQKpPLIhr9asD/dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+N10EjNn7daSGEX3ydHw0RnvDnEjqpMRQoeuyoB9WXgGhsBY2GsrSMlVn1n2w+//oUmvdsxFTsGLdyuZ5GCzkZMSZwnVHA/adcg2jbkRXwC0MLk8H++7REqFcqO48RdpjG0b3MO7fMjGnjhCP0gYx0eJBdX26anWk06G86bIOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KThKJrTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KThKJrTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A1C433C7;
	Tue, 23 Jan 2024 02:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975457;
	bh=RtorUI8bAyUJb0pcjEn4niUPVhxIQKpPLIhr9asD/dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KThKJrTb/CcngTb73ql678kIUgSjBJ32WQ831BExNBmqP7S76P7dskIp3LBRgoMQW
	 ra5IvLPPOKoiPnJVRY0+Zzh+ycknsWNoJjqsB1r7FxGIO2nuDBxEKbSduyeeCUsGrs
	 jYe18qZkjkYEN1CbFdiG0rykxzQFEXqV9PW65GJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xingwei lee <xrivendell7@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 389/583] io_uring/rw: ensure io->bytes_done is always initialized
Date: Mon, 22 Jan 2024 15:57:20 -0800
Message-ID: <20240122235823.893235912@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 0a535eddbe0dc1de4386046ab849f08aeb2f8faf upstream.

If IOSQE_ASYNC is set and we fail importing an iovec for a readv or
writev request, then we leave ->bytes_done uninitialized and hence the
eventual failure CQE posted can potentially have a random res value
rather than the expected -EINVAL.

Setup ->bytes_done before potentially failing, so we have a consistent
value if we fail the request early.

Cc: stable@vger.kernel.org
Reported-by: xingwei lee <xrivendell7@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -549,15 +549,19 @@ static inline int io_rw_prep_async(struc
 	struct iovec *iov;
 	int ret;
 
+	iorw->bytes_done = 0;
+	iorw->free_iovec = NULL;
+
 	/* submission path, ->uring_lock should already be taken */
 	ret = io_import_iovec(rw, req, &iov, &iorw->s, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
-	iorw->bytes_done = 0;
-	iorw->free_iovec = iov;
-	if (iov)
+	if (iov) {
+		iorw->free_iovec = iov;
 		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
 	return 0;
 }
 


