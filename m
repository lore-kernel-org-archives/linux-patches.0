Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579569446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992C3C433C7;
	Sun, 13 Aug 2023 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962819;
	bh=glwGs2Ds+UsIdRROZF3byo+tpr3eM3c/Dgy66IarTIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES0KbyquIM+K3T4uT+hMWUOwvHPhCb6ByO7qPSYX2zmV0o+My880cirRKxsijJNeJ
	 o5+11vBaqBWXzkN7LNERInoIQlyaZZaR6T+gTsJ46N8+D0a2S7z09nHhcsUOYanr9f
	 YIiIv1aP4vEJUCTVVfY5KMcnwiIxIMIr44xqJxUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 19/68] io_uring: correct check for O_TMPFILE
Date: Sun, 13 Aug 2023 23:19:20 +0200
Message-ID: <20230813211708.739189502@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksa Sarai <cyphar@cyphar.com>

Commit 72dbde0f2afbe4af8e8595a89c650ae6b9d9c36f upstream.

O_TMPFILE is actually __O_TMPFILE|O_DIRECTORY. This means that the old
check for whether RESOLVE_CACHED can be used would incorrectly think
that O_DIRECTORY could not be used with RESOLVE_CACHED.

Cc: stable@vger.kernel.org # v5.12+
Fixes: 3a81fd02045c ("io_uring: enable LOOKUP_CACHED path resolution for filename lookups")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Link: https://lore.kernel.org/r/20230807-resolve_cached-o_tmpfile-v3-1-e49323e1ef6f@cyphar.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4229,9 +4229,11 @@ static int io_openat2(struct io_kiocb *r
 	if (issue_flags & IO_URING_F_NONBLOCK) {
 		/*
 		 * Don't bother trying for O_TRUNC, O_CREAT, or O_TMPFILE open,
-		 * it'll always -EAGAIN
+		 * it'll always -EAGAIN. Note that we test for __O_TMPFILE
+		 * because O_TMPFILE includes O_DIRECTORY, which isn't a flag
+		 * we need to force async for.
 		 */
-		if (req->open.how.flags & (O_TRUNC | O_CREAT | O_TMPFILE))
+		if (req->open.how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE))
 			return -EAGAIN;
 		op.lookup_flags |= LOOKUP_CACHED;
 		op.open_flag |= O_NONBLOCK;


