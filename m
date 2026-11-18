Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042896;
	b=47qyf2r6js+jDVqd+OQ+u0dVG4TuotGjrNDfEwG7Xbc6Rk2CYh/3XuIyfpePB9qwHNiX
	 CyyomMrHP174EzmTp63358w5YnUkFkbKOrmuDni5msBgH3kWvkl9Ng1AOJEDZYTgyDkEY
	 9A85tPRkEA32SGrtqyuWCLJ4wo70h/OAsf/vLE+9lhImTJXXTqKjzCV8S8JD1BuiQkucA
	 ACUpHBOCnipK2L5wSFPetGVKFSwpvsLpMJBT1t+R5PV72a0txiq6dDLJSIL3KbU5EvkuM
	 tHcYM8QgEkeWnUcBoWDEWqjtq2yNKtUI2TwnIxixmqYKst4DZh25Hn44U0hnyEu6q+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4gRqUaZvGnhDFmWn2k+77GL+bGfJczIhQNszX7wzIQw=;
	b=HO5ab7suf5h3+OYyGn5ITO7NxdkYVgckxcLkAJRJhMtwtpO/+K35k93dAHtjQvbjNl4u
	 sMLQHOvees6RAEPRFa+9X8imkM+x8V/zbo3fW+mtE6BlM1RZw1YPUPv9wyBmpErBaJ5DU
	 aHoftP+joysz5d39hGBH/6fXYf5VY30X1jyedXWbQd7oPkIG8RinGQJSJ7nCurZ6mdjEo
	 DvpWUmp0DsQWppJm0aaCLfzZT1Kig8Zj/4pZCRgQOxiu4mOgj9kTXg413pOBNygI6jtYc
	 1xel76vo0pfX0TMMV9rAvjQXcW/XZGAqGXtVUh+TPckPzK/CULVKqAY7+OmIInC6yEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5N4OD4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28CE606A31C;
	Wed, 18 Nov 2026 23:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d5N4OD4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338271F000C4;
	Wed, 18 Nov 2026 23:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042896;
	bh=4gRqUaZvGnhDFmWn2k+77GL+bGfJczIhQNszX7wzIQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5N4OD4+Ly495aYrao/Q13o75NvkY88eJYY+YPk8bv06d5rf/J7oKqbXV0MT911nY
	 9+ZHjjEoa/tQe4LDO7qeCooJrT+qmglpPiUZXFJLiyf31Gx7IG0bmfufVaIWSN/xnu
	 nLJa+XMKF0H4rUn5SyCAGOyDUg3QoD5RsJ+D+Jl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0011/2857] fork: move the coredump and exec checks into create_io_thread()
Date: Wed, 18 Nov 2026 15:17:25 +0100
Message-ID: <20261118150201.722756676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 kernel/fork.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 37c5d6123cf62..21e37a4ecc9de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2714,6 +2714,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.io_thread	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 
-- 
2.53.0



