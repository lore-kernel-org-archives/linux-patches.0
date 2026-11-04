Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826884;
	b=cH55clOGsSkxS5f6G9uK8wMXWsphtnZhDrWxj1gKZIyvK/tDLwDDAy2Y5BHTH88vOKTz
	 QByFzrrbrowT6OH5Wh9+oGFjBIKHI92M3jKzwq+lTUMHEWLPfFmo206/hqPsF6JSRa9TP
	 Dfmn6q9EXiorpx6HB2UNv+HI/SPdLmzI8qvFo00df8uPN0Yab7VenPhNdIytWcN+CqpIJ
	 AHfVXLQasrLfqLVRC9+x7UJJDqMjpjSEOYsYbxrLgI0jHQc8cQ9o9P3Y47vsxAWvkm8vb
	 YkJPPWUzFVVglveeNGIvfrNu9sR+5WWiyozlerWpinfxnT8XhdGvPjuYkkEm6Vul80w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4Toy3j3h6Mcj5Fn5JM6XVbm+DMTOOERy9pxKHrWmIA=;
	b=Xjyu6zSKLbX9wrs+8FyYqlb7JipT865cJEXTk2ZGilYG0ak3pFt7s0YckNiQmp0rFue5
	 qMTTpAs3xmh3JcIIraDzUcScvEPsb8h+mH7v2tP2/X/Z5PHymBbtzbuSzysqE90snBvNC
	 Znjkc/mZbOrYY/gzf3z3vo4qfh0OIYIJ5lFAucBbF81nqDCTO2bES+Hw2QBHIkvdIIlc1
	 53+1vYJL/DbTVjSgtcCCAX2TOkKRIBr/SUVBJ6G5Pq5Z29HhID2A26JWQ+ORE1VSJX0sc
	 f8qv2NEbJGWCsSqtIdvnH9SC0iU4pXWfzK+Sieq4I6zAuDuzCnblRUr0ncVchOgUoeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZTrAUxH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4A76070756;
	Wed,  4 Nov 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZTrAUxH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A611F00919;
	Wed,  4 Nov 2026 21:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826883;
	bh=B4Toy3j3h6Mcj5Fn5JM6XVbm+DMTOOERy9pxKHrWmIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZTrAUxHmrwgWYRZoaLei2LBGCVbmufQD1xqeHRWlMbtZGkaBj8WB6DfjEirfBxR6
	 BbMw4NLqUH1JqWihuupAtPfb0fDkExc4FdCfp2iMqEsFi03YTa4pIxlijuLUHZUxIh
	 Fu/qkpJq5qhRvoMWbQ10IsXTUz0OeW397zawPwhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 064/547] fork: move the coredump and exec checks into create_io_thread()
Date: Wed,  4 Nov 2026 16:04:08 -0500
Message-ID: <20261104211040.092618168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e760200370e4de054b6b5f568a7faa911e2956bb ]

Only a PF_USER_WORKER thread returns from get_signal() after a fatal
signal and can go on to create a thread. get_signal() sets PF_SIGNALED
before it dumps core and before it lets a PF_USER_WORKER thread return.
That flags sticks.

The exec'ing thread itself is never signaled. But it doesn't need the check
anyway as we moved cancellation of io_uring requests before de_thread().
create_io_thread() is the only way a signaled thread creates another
one. vhost_task_create() is reached from ioctls alone.

io_should_retry_thread() doesn't retry -EINTR, so io-wq callers give up
the same way they did when copy_process() refused.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0VLTyxNatFmLOK@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1f978881ce6c ("fork: don't create io threads once PF_POSTCOREDUMP is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2718,6 +2718,10 @@ struct task_struct *create_io_thread(int
 		.user_worker	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 


