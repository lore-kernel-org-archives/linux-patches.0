Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829774EB4A;
	Tue, 23 Jan 2024 00:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969791; cv=none; b=rXC+DPkPr4unFphCIqwa0j7/iek/aCha0psFsv8/sNKDx2ErzOIEvEJoB/BTh9m/lSjLZmh8YRYYlhxPBj4hZGOwFMWNEKa7V8hmYDYMuFzG1SdxXBOZByJPh353muz2J7HByGvDHCxB7Q0VU+PRyYoeuz2XxqDatqrpTLr979s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969791; c=relaxed/simple;
	bh=zB8rHEQhO3ed/wZuhWqCzibRBWLWK9BHGyX2xspIWYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQJ2Tb9ROfVSk5r3t2eCFLKFtjogIyC+8aJHr4N5gJt3zkkZn0f07G5k8FSZy5e+u36KM2jazuIX6PjMx7bjXmDjUOQNe094KrnLnZQzj1jTNkX5xsYOu7LF9HAoGvle/c/coPMmV0TvOqCiPBKVslz0p7rBGt7bP/9tszgqzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9hZYvCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9hZYvCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1339C433F1;
	Tue, 23 Jan 2024 00:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969791;
	bh=zB8rHEQhO3ed/wZuhWqCzibRBWLWK9BHGyX2xspIWYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9hZYvCyLowNJ8QF2M9s/64zTd87AEpzIX8pXeomGNJPUd8YG0wJlFXN0UCW7xSU/
	 pCqJ9h7E221Ds1kBZjxReoscCGgz4R/jkrGo6dPTLW171vCHO0/1uImayEurVNVz7D
	 isNFQ5YZJP544WwlNOb81ed6bYv/0Fj5iHEdRIKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 427/641] io_uring: dont check iopoll if request completes
Date: Mon, 22 Jan 2024 15:55:31 -0800
Message-ID: <20240122235831.353232285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9b43ef3d52532a0175ed6654618f7db61d390d2e upstream.

IOPOLL request should never return IOU_OK, so the following iopoll
queueing check in io_issue_sqe() after getting IOU_OK doesn't make any
sense as would never turn true. Let's optimise on that and return a bit
earlier. It's also much more resilient to potential bugs from
mischieving iopoll implementations.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2f8690e2fa5213a2ff292fac29a7143c036cdd60.1701390926.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1898,7 +1898,11 @@ static int io_issue_sqe(struct io_kiocb
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req, issue_flags);
-	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+
+		return 0;
+	}
+
+	if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */


