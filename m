Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B48BFF;
	Thu, 30 Jan 2025 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247417; cv=none; b=VhKHJbH0GdunaotCBV59obuCzThucKZB+KkA0eNXP0OIFz6VEnS5VvhQd8nrKqXyPxQDeu8FoYemHq1EcTxh5E0HrKylQs499DLojGEDImd2Bo2cQrOYP1HU4RU/mvE1YoJ6Kq+JJmiPmfYVjeHGBpDLohB830/AhQJqBIjKqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247417; c=relaxed/simple;
	bh=S/PxflTUs0MxpyCTHw3veeCQNx6sXgcK4H8VHRjAvrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJqI7fE0kjSv+CfQUOnNJEFqyZvsxIcsNkn90jkOBmguwqUTvHqF0OlIE2uTLeeAAMs2MIlDmnwK7bbP2yLaKeOx3C/w4hk4a8mdWQm6qVK1xJLGbBQocVLyKS+dC6lFjzyP9EKzGUn3zGja609uC8P2Zs2sDyv+tzxjkhN43m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We2ngU8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We2ngU8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB80C4CED2;
	Thu, 30 Jan 2025 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247417;
	bh=S/PxflTUs0MxpyCTHw3veeCQNx6sXgcK4H8VHRjAvrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=We2ngU8xBCjNfHGXZxaH7O6DweegdvKAa2QsebMm3ucyIFNnXPhMJKNDyOcfS6CD8
	 HNacVNEsEfq/CiNj6JY8rt25fqgry+kGuML0AFHTBVa9Y0GexGqgvIKSiSMOyT6vG1
	 J5Aoz7SGxDa33+EPPOHyQQiicE7hokFZUtxOqEV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 32/49] io_uring: fix waiters missing wake ups
Date: Thu, 30 Jan 2025 15:02:08 +0100
Message-ID: <20250130140135.126762165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

There are reports of mariadb hangs, which is caused by a missing
barrier in the waking code resulting in waiters losing events.

The problem was introduced in a backport
3ab9326f93ec4 ("io_uring: wake up optimisations"),
and the change restores the barrier present in the original commit
3ab9326f93ec4 ("io_uring: wake up optimisations")

Reported by: Xan Charbonnet <xan@charbonnet.com>
Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -597,8 +597,10 @@ static inline void __io_cq_unlock_post_f
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_commit_cqring_flush(ctx);
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
+		smp_mb();
 		__io_cqring_wake(ctx);
+	}
 }
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx)


