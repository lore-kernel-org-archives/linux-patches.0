Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235F835A2A2;
	Mon, 18 Aug 2025 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526483; cv=none; b=IPobmoDVLEObr1rZex5eymum97ZRCUKXXAqC+d5GFJjBAbv4+hL7ILHDiLW19si38pX4DJZiK2ScGXkKBjpF6Sdy0RBylcvqz8sMlBDfa6sFw/dOXVyYOxPuQpH8+5ME3b+sDGEUk6yghbXb/i7mMGO1Q4D6eUp55SDqdwFjslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526483; c=relaxed/simple;
	bh=25Kw4CXJCBUWaCXvZkwggtC33KVdhZlKnA92PY5QeEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irlTUZouYTE9QHBdE6BMXBwVrzEQOgs/tZ8rnTxa5LiGn+SnRHsPVG/oIyfHwmHGbObs4bY4AvHxP/NQHNLy5FnD/QfabBcIKPAQ1Ctr8mMsIYY3/hqAwWAU4XtGjz+fiqZO7Z7S8hV8wkUtK6HNAlIxA4cYHghD0G2QqApdzcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWyPkhLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWyPkhLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE33C4CEEB;
	Mon, 18 Aug 2025 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526483;
	bh=25Kw4CXJCBUWaCXvZkwggtC33KVdhZlKnA92PY5QeEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWyPkhLl0XkaEDYuN9mHNUZBYp5kUvSjsTCHJ0vbM2h+MHlfOf0iaofkZUwjIJHUL
	 9Ckwz7kiqNme6bEwL/npTH5B2tX1NFAdKqOrytp7nr9SFDA0Sw4Q7Ug809Ej/h8Wsl
	 V4l/b/zJ1rJ3qejYjnT7hql/Lw+XUQtjkPD3Fp50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 569/570] io_uring/zcrx: fix null ifq on area destruction
Date: Mon, 18 Aug 2025 14:49:16 +0200
Message-ID: <20250818124527.797326580@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 720df2310b89cf76c1dc1a05902536282506f8bf upstream.

Dan reports that ifq can be null when infering arguments for
io_unaccount_mem() from io_zcrx_free_area(). Fix it by always setting a
correct ifq.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202507180628.gBxrOgqr-lkp@intel.com/
Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/20670d163bb90dba2a81a4150f1125603cefb101.1753091564.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -394,8 +394,7 @@ static void io_free_rbuf_ring(struct io_
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
-	if (area->ifq)
-		io_zcrx_unmap_area(area->ifq, area);
+	io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
@@ -428,6 +427,7 @@ static int io_zcrx_create_area(struct io
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
+	area->ifq = ifq;
 
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
@@ -462,7 +462,6 @@ static int io_zcrx_create_area(struct io
 	}
 
 	area->free_count = nr_iovs;
-	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;


