Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45E4534B9;
	Tue, 16 Jun 2026 16:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626163; cv=none; b=PSlhq2808q92Wub89Gr1J52LjptK7BYlWWO8cWxBJQgQviMq8cpoMg9Sa5FfRoRafyNcTQjUBpKyqosraZzT7oJKXeM2REhgvPx7x3MCtklCAoZK9IV0GYNLnW5P5QPeElklx44eYPrinCMMf1bSPWMtqyAF3ihL8Jz/34yo7j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626163; c=relaxed/simple;
	bh=ineQ61bsZqVATcw7OFIMuw0SdrH6ZtPcN5jOB9avWNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPyn/ouMJWKJEtV3t6YYQZEqXmchwHWhXk9nR22wheCHrw9/lRZJRG/nWTFumHRBhPEdONjwpDKnelg4rneNTZ64nBqyQPRfVO7xKnv+6bQTbZTiTOgIs+3kN8B+likTN08hBkASQuyUj6TONW7M4ZjRvj2xYZh3o1HEMlBRGLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecLzxwho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecLzxwho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AB71F000E9;
	Tue, 16 Jun 2026 16:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626162;
	bh=1C2YTrL2T+9lFlqWh1agLtVrObwvXFjbjmEOYlLdEQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecLzxwhoBWIiV6oOE7gj5Rh6TG98lCnIiEi8+mQAiAqb2vO+qPNCPwEEQ8ibv8ZG2
	 ECzMPRXSFGDQl/qrzKigrHJxtIcqk/iPIhlLQ55PkQLsDHbbHeD5mwgEoT8No5wcx5
	 JChneGLGrrioE7GIWmfEFqd8e2qa4pJWYNkkQ+vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tip ten Brink <tip@tenbrinkmeijs.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 248/325] io_uring/wait: fix min_timeout behavior
Date: Tue, 16 Jun 2026 20:30:44 +0530
Message-ID: <20260616145110.857842603@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: "Christian A. Ehrhardt" <lk@c--e.de>

Commit 29fe1bd01b99714f3136f922230a643c2742cda9 upstream.

The wakeup condition if a min timeout is present and has expired is that
at least _one_ CQE was posted. Thus set the cq_tail target to
->cq_min_tail + 1. Without this commit a spurious wakeup can result in a
premature wakeup because io_should_wake() will return true even if _no_
CQE was posted at all.

Cc: Tip ten Brink <tip@tenbrinkmeijs.com>
Fixes: e15cb2200b93 ("io_uring: fix min_wait wakeups for SQPOLL")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://patch.msgid.link/20260606201120.1441447-1-lk@c--e.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2586,7 +2586,7 @@ static enum hrtimer_restart io_cqring_mi
 	}
 
 	/* any generated CQE posted past this time should wake us up */
-	iowq->cq_tail = iowq->cq_min_tail;
+	iowq->cq_tail = iowq->cq_min_tail + 1;
 
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
 	hrtimer_set_expires(timer, iowq->timeout);


