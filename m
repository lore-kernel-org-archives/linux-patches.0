Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058381DB13A;
	Wed, 15 Jan 2025 10:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938456; cv=none; b=Yluw1MmJdRlRfYyF6D7HoHamO31vUGPQ/8b8lMNnfvPsdoK3enoIdjTnOIBE2QUlqJtBoaz0ZkHgeMxQf21TepfqhcW6cbohKW9wmJ7vhJFqM3eCWBiEJX8XGBaNcQIXHX7hVUyd+1DDK/T00/1WoOHFxENpzNKjW4eZ5BSKOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938456; c=relaxed/simple;
	bh=Ns21EuwWW0XwkmiVjhkdb3fkeCsR9wDB1Pfe9f0nP9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRJ1TpaRz+L6xLl355+kDgihPoqwST7KvhMHMdLA4GFLvwGLfih0BAcWnuLC9TTW6/QYEsI5KssqzHF25v5o29br1aJ/BAtwSe2t0TZ2zuGOW/RNf05Fo0QXPacu/WzamMZkddeEjahsiv8q1IOLIE/6iT/UmuulbV8mw3iG2oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHyKOhwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHyKOhwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63725C4CEDF;
	Wed, 15 Jan 2025 10:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938455;
	bh=Ns21EuwWW0XwkmiVjhkdb3fkeCsR9wDB1Pfe9f0nP9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHyKOhwEBxktn3QRBhyTda4URGh4Sd6He2eqFLItMsaY7nPSovfjSGURxz7HMHzqu
	 4OFJ1xQ3XjjynAxCdOXfHbMNTdYLI93r8Dm4LTVHohysVnpwB4lJPjEz0lYzliFpYT
	 BVptfJa0TVISn0e2TCFP3ogTVx7PQtxsvvn6oIFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	lizetao <lizetao1@huawei.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 187/189] io_uring: dont touch sqd->thread off tw add
Date: Wed, 15 Jan 2025 11:38:03 +0100
Message-ID: <20250115103613.866085887@linuxfoundation.org>
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

commit bd2703b42decebdcddf76e277ba76b4c4a142d73 upstream.

With IORING_SETUP_SQPOLL all requests are created by the SQPOLL task,
which means that req->task should always match sqd->thread. Since
accesses to sqd->thread should be separately protected, use req->task
in io_req_normal_work_add() instead.

Note, in the eyes of io_req_normal_work_add(), the SQPOLL task struct
is always pinned and alive, and sqd->thread can either be the task or
NULL. It's only problematic if the compiler decides to reload the value
after the null check, which is not so likely.

Cc: stable@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Reported-by: lizetao <lizetao1@huawei.com>
Fixes: 78f9b61bd8e54 ("io_uring: wake SQPOLL task when task_work is added to an empty queue")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1cbbe72cf32c45a8fee96026463024cd8564a7d7.1736541357.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1244,10 +1244,7 @@ static void io_req_normal_work_add(struc
 
 	/* SQPOLL doesn't need the task_work added, it'll run it itself */
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		struct io_sq_data *sqd = ctx->sq_data;
-
-		if (sqd->thread)
-			__set_notify_signal(sqd->thread);
+		__set_notify_signal(req->task);
 		return;
 	}
 


