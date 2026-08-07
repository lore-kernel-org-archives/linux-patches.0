Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726082DB7BB;
	Fri,  7 Aug 2026 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115341; cv=none; b=PmgIQpvgai12V6LO/w7q0H19Qf/wPAY8fbT1RGQrFfyEN2la7SfhokAu0HrG0d1ZG2CPFXWPP12XXI42KQUSgREBIBBpVoHUrnAXVDj18KGAoX8uRiSsFcoCOmAd/Qg362WIJuANI2eGYo575xFgDY/yvxfgL9+8P/iBC4sEZyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115341; c=relaxed/simple;
	bh=Zrw8hfnv1uheQ/dxcnOTh+a31i/1ioVVl4t+BE6TPBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO3MvjWErT16ntVaaDy0ePzdJ6wKV537SAcHcE/o7lKqSwf8DpSU2ZfLYdT3e8tS4XcYM33BFN6PD+rCGNBwP9BTlbObVzw+/hcpvVuXtt2qteGfhT8qaV2AMZsE4mDlpGOeFMuklMDBMROhrff4VckW5If2GtK8aDvsoIctnBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvD+6jkQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvD+6jkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C251F000E9;
	Fri,  7 Aug 2026 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115340;
	bh=u2txxwktYPKSmAkuhD2FTpbY3HwRggXCbKpmxVkKBmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvD+6jkQGy29DURbLKXgJIbcd4Z0Mf7aJvwDeg3eKhrthAlpEo0FLk7DSGzD0qr41
	 Qvkay6uilYGkKL8MPKm45pM65YbZCK6J1+2HYLnePZGjuvwv18aYqjX7hwB4EX+r4+
	 qt3CN2KmG9c3/oJ7Nh0ohR9xSVp7qwEiOkJHKWWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Keum <kambodi127@gmail.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 235/396] io_uring/net: initialize mshot_len for send
Date: Fri,  7 Aug 2026 16:36:35 +0200
Message-ID: <20260807143429.327812888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit c77ffbc980efb337fd750c337d8157d532ea14e5 upstream.

Commit:

6a8afb9fff64 ("io_uring/net: allow multishot receive per-invocation cap")

changed how io_mshot_prep_retry() set sr->len, and added the same
initialization in io_mshot_prep_retry(). But it neglected to touch the
send path, which may also uses the mshot retry path. Ensure that
sr->mshot_len always gets initialized correctly.

Fixes: 6a8afb9fff64 ("io_uring/net: allow multishot receive per-invocation cap")
Cc: stable@vger.kernel.org
Reported-by: Sung Keum <kambodi127@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -433,6 +433,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 		req->flags |= REQ_F_NOWAIT;
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		sr->buf_group = req->buf_index;
+	sr->mshot_total_len = sr->mshot_len = 0;
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		if (req->opcode == IORING_OP_SENDMSG)
 			return -EINVAL;


