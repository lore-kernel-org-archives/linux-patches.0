Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E84223DEF;
	Mon, 23 Jun 2025 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716901; cv=none; b=XCCRMfMast0kEcu2xIKRMvDIiftV9PQ/ahUErd5BJbrOAhHxuhMyHyzkm2TwaA+M6z6nn6xpK6FbOR12BYzpII9lX0gvtLE8NnqBVZ+CkPT6jsJRPjEOmqsxs9QcMK/3l33IHqZihCtWPrtlGvCr+qGKNhsAw/CQAmcjxAQ+B6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716901; c=relaxed/simple;
	bh=YaUBrQACstyGvg3M+Ml4++sGlsi1MLx/KOHDYNEGyew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZTLAo35LxFuTNyJa9b37WW7eSGfjyyhW47vVKviOhkmBbiY2KxEelOXKasrOqMGGsFkTLX7sE4QnXsJBcjf2o+PGKPM2rLQUi5tukTMUfriLnEu/ME33Nh5aUV3vBMyE8B3TImm7E5RNw4YUJK4cD0Hro0eK0d6MIqtQGDB/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKYmAocJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKYmAocJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4E7C4CEEA;
	Mon, 23 Jun 2025 22:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716901;
	bh=YaUBrQACstyGvg3M+Ml4++sGlsi1MLx/KOHDYNEGyew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKYmAocJX1em74FYvWeKEBJK8MvRU7XiU9xYmX2gCxNh13poHmXqxoFyrx8mMAFVW
	 FxjemFm7Z8f2ORd86+Zyo78YIf6Opc0x+5N4eGf6vUAqAGSvJV6G8vwMkr1APjLRGG
	 gcbPcKZqrH3ZysCctkaJs8DlyFxk40JzujNRygaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Penglei Jiang <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 296/414] io_uring: fix task leak issue in io_wq_create()
Date: Mon, 23 Jun 2025 15:07:13 +0200
Message-ID: <20250623130649.409641954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Penglei Jiang <superman.xpt@gmail.com>

commit 89465d923bda180299e69ee2800aab84ad0ba689 upstream.

Add missing put_task_struct() in the error path

Cc: stable@vger.kernel.org
Fixes: 0f8baa3c9802 ("io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Link: https://lore.kernel.org/r/20250615163906.2367-1-superman.xpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1204,8 +1204,10 @@ struct io_wq *io_wq_create(unsigned boun
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
+	if (ret) {
+		put_task_struct(wq->task);
 		goto err;
+	}
 
 	return wq;
 err:


