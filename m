Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8F91E9909;
	Wed, 15 Jan 2025 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938346; cv=none; b=JdtzBajpBzoYPP2Dh0CxZjX2Y05EMCilTrBtsSrbYWSjStgyUCGzjbNKLH7oRNUY5mnzGN0YERy5XcFdEhYeGzm0cxnR36zGcKjPANpXX40VpXiGNCpGEWK8wjEfulYXgnmv+0dSrCJUfqc09EoPnysJaTTu8Af401wKyT0QXng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938346; c=relaxed/simple;
	bh=RWQUNCXjSCwe0WuSPeeVxuhTo3tmrNqmmEAfX+SoOwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jtmq4/jWatBhLQqKDHzMbHLz/EsSlh5qDmA+85FY+Zhx4JZXgpllx2b1Ux0brN7NWrs18meyj1m7leBcajUTz6l/AR0JJfo8Js30pc2S3E6Gd9VY3d/Np1bfX/QqxlkE0uL0Vl8dAdTHHJzpAkROa/JjQRB21waygdrbSo0iooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9Eokesk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9Eokesk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B74C4CEE4;
	Wed, 15 Jan 2025 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938346;
	bh=RWQUNCXjSCwe0WuSPeeVxuhTo3tmrNqmmEAfX+SoOwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9EokeskpcX9cNF0wVuEdSoU/g1wqsasCCCZS28hXGfaU6hZlpWKGDud2/6EA1H+g
	 axq30tELQYvvq3pRonrqph1K2DkyJmbJ+CtorNwi4aMWR7wOXtHr8DHLeak+wGBTLS
	 cZyNcxPyLQ9dw6VJNDv+OaoK/edbSw8JiJ0HVjgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 128/189] io_uring/timeout: fix multishot updates
Date: Wed, 15 Jan 2025 11:37:04 +0100
Message-ID: <20250115103611.546870118@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit c83c846231db8b153bfcb44d552d373c34f78245 upstream.

After update only the first shot of a multishot timeout request adheres
to the new timeout value while all subsequent retries continue to use
the old value. Don't forget to update the timeout stored in struct
io_timeout_data.

Cc: stable@vger.kernel.org
Fixes: ea97f6c8558e8 ("io_uring: add support for multishot timeouts")
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e6516c3304eb654ec234cfa65c88a9579861e597.1736015288.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -409,10 +409,12 @@ static int io_timeout_update(struct io_r
 
 	timeout->off = 0; /* noseq */
 	data = req->async_data;
+	data->ts = *ts;
+
 	list_add_tail(&timeout->list, &ctx->timeout_list);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), mode);
 	data->timer.function = io_timeout_fn;
-	hrtimer_start(&data->timer, timespec64_to_ktime(*ts), mode);
+	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
 	return 0;
 }
 


