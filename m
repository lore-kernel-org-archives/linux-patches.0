Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE3303A0D;
	Tue, 11 Nov 2025 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825469; cv=none; b=gg9VgQVGOfkb6NgIAIW6A0+0jKJ4PZef/DuvDapJ/yAfz2FgB/E4Kr13cD375xlnEG3/3tp7LhERvokbZlm5BOPYFzYS/Gv492H0hYQSZ6Ly26b5kqUPdf6A1LnNfG15Ba+NhPC+gYh962J5vQGz+q5Af+h0s6wHSoKaF0S4CZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825469; c=relaxed/simple;
	bh=h9CYyIDDOQ1MpAwJm5AB7KXs4lbF7JdBVBXI2iq25p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QcyIqNIU17tPWoWGeOJPqqNN8pEczqwI003U5WV7+1A05Y8h0BbkhQ1fjnCIuskGZe+D3JK5yj732ybMWaLeo22XPKz5bi7iJTo2d11QCD9RAhAMOtHTwWzWBxB5AuvZc8wzgL5RT44AmrRyUL4XjYa7nwP9bxwepj2IleQJcLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPyQRWbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPyQRWbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BE1C116B1;
	Tue, 11 Nov 2025 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825469;
	bh=h9CYyIDDOQ1MpAwJm5AB7KXs4lbF7JdBVBXI2iq25p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPyQRWbkI5GddLa7fhndbGTQMTktqZpN/vXV5h0WoGggSyWzHgq8MPLb8U0s+dGsx
	 NWPRf/od1FTW2G3AFouFIsHmUBWOWPjI1eC/7Eo5D7EgsaZ5MuWn+C5Ztcyo9dRgv/
	 fivWcFU405zd3X3tAf0HnNTBvF4qOCAVHFRGNckI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 816/849] io_uring: fix regbuf vector size truncation
Date: Tue, 11 Nov 2025 09:46:26 +0900
Message-ID: <20251111004556.154483395@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 146eb58629f45f8297e83d69e64d4eea4b28d972 upstream.

There is a report of io_estimate_bvec_size() truncating the calculated
number of segments that leads to corruption issues. Check it doesn't
overflow "int"s used later. Rough but simple, can be improved on top.

Cc: stable@vger.kernel.org
Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-458654612@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Günther Noack <gnoack@google.com>
Tested-by: Günther Noack <gnoack@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1402,8 +1402,11 @@ static int io_estimate_bvec_size(struct
 	size_t max_segs = 0;
 	unsigned i;
 
-	for (i = 0; i < nr_iovs; i++)
+	for (i = 0; i < nr_iovs; i++) {
 		max_segs += (iov[i].iov_len >> shift) + 2;
+		if (max_segs > INT_MAX)
+			return -EOVERFLOW;
+	}
 	return max_segs;
 }
 
@@ -1509,7 +1512,11 @@ int io_import_reg_vec(int ddir, struct i
 		if (unlikely(ret))
 			return ret;
 	} else {
-		nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
+		int ret = io_estimate_bvec_size(iov, nr_iovs, imu);
+
+		if (ret < 0)
+			return ret;
+		nr_segs = ret;
 	}
 
 	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {


