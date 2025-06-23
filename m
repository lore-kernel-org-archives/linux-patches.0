Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BD419D084;
	Mon, 23 Jun 2025 21:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714882; cv=none; b=b/XE4gJYdqCYaeOTO07AckutjIYT33JJxzSyR+5bTFrPB+zQ56+HfxRMlY02tz6vEtjYa/cm4/hgvShEvyeALQFmZbpgEn2XNgvjA093SkEll5zxT8SSCtbtIF1J6CtDF6UGg2777uIQEFSwCd5/2S4DfC0ry1BlVhf9vL3gClE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714882; c=relaxed/simple;
	bh=GBVY3RyBK1kgFUss4cUJu9ZbTVj1MPJi26In/n4fQrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ5oxBqiAoUxVnc4ceLUoSyxxQP0WhRW4PybIoKQU/jq/zq3sggsK0vVsYHrpGwKm7vx9sYpNnejHlOXA9p2SbRFkAWdkm3sTmJ2UHbfC+z+zHw3XLTkCZtVQ6ZYbAJkq9tIigvC+QLbQDsQSks3GDj6YE9ciLskqfi4NtZPAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5vBC4Ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5vBC4Ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7A6C4CEEA;
	Mon, 23 Jun 2025 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714882;
	bh=GBVY3RyBK1kgFUss4cUJu9ZbTVj1MPJi26In/n4fQrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5vBC4MaRX+letZMSNzM64AAbrlSBLalmt332F7gjgSOmSL0RayLcumOqokG46Qa+
	 mVNaD6d8TsYko+wd4nWL9PBkGq7AYjjn8FGWceKe3Ya33WwUiEgwTPiCRhYd7wsQ9Q
	 kp47D6aK0ydgMTirVNy7ciL9BC7gB6cbpqvPzAB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 444/592] io_uring/kbuf: dont truncate end buffer for multiple buffer peeks
Date: Mon, 23 Jun 2025 15:06:42 +0200
Message-ID: <20250623130710.992601964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 26ec15e4b0c1d7b25214d9c0be1d50492e2f006c upstream.

If peeking a bunch of buffers, normally io_ring_buffers_peek() will
truncate the end buffer. This isn't optimal as presumably more data will
be arriving later, and hence it's better to stop with the last full
buffer rather than truncate the end buffer.

Cc: stable@vger.kernel.org
Fixes: 35c8711c8fc4 ("io_uring/kbuf: add helpers for getting/peeking multiple buffers")
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -270,8 +270,11 @@ static int io_ring_buffers_peek(struct i
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
 			len = arg->max_len;
-			if (!(bl->flags & IOBL_INC))
+			if (!(bl->flags & IOBL_INC)) {
+				if (iov != arg->iovs)
+					break;
 				buf->len = len;
+			}
 		}
 
 		iov->iov_base = u64_to_user_ptr(buf->addr);


