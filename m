Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690527A926;
	Tue, 27 May 2025 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364438; cv=none; b=mJVcZ5ZdADLL6X5DF0N5NCxBO9cj62mxRTHDYobd2qUtbhHJaCCqrlTkJOZ/WnF4JOROGflB7ytWeOo0xN7qt5k1gDne87jB1pqSQvXG6I9xBKf/mfFx6osqu1tc9MzO3wM+n+cxRJdPYwT8jp6imt2jBoDj1og2jJrApYLEnzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364438; c=relaxed/simple;
	bh=sJeBWlpgaprY4CIxJrbNvDMLEYyG02niwgVEyCggP/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYulQa979dVb0w7H+WZsxwCoMFfhLS7TSwU15QcEmP/AIj0CO9Gv+s6Tr9f7EJrSpT/zzAajjfKhBuuOcPdlj4TIwvFkWcWlYOWhc0vNJcQd9XVSdQrRjq7VMyViE62Sj1Z5HRueCGdnWuNcAA+6y5fnUqmG3JxUQ6cCbGRbXck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlvxytDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlvxytDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAC5C4CEE9;
	Tue, 27 May 2025 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364438;
	bh=sJeBWlpgaprY4CIxJrbNvDMLEYyG02niwgVEyCggP/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlvxytDM+Xdp5R1o7yaYc94a8v2T/MRJ7A5rrQTUu4blynCacs1iblQHPFVrHTmXd
	 pRSnx94jPoh/7vRjr9ffBXecSy6Zw/wKfaTWntzndEanSO1ZdxdMRi5tMBAMqYjFLK
	 GTNq85g0/ifI5oKt16REsvZIuEIVnib6iKx9fXts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/626] SUNRPC: Dont allow waiting for exiting tasks
Date: Tue, 27 May 2025 18:19:09 +0200
Message-ID: <20250527162447.334886897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 14e41b16e8cb677bb440dca2edba8b041646c742 ]

Once a task calls exit_signals() it can no longer be signalled. So do
not allow it to do killable waits.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 9b45fbdc90cab..73bc39281ef5f 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -276,6 +276,8 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
 
 static int rpc_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
+	if (unlikely(current->flags & PF_EXITING))
+		return -EINTR;
 	schedule();
 	if (signal_pending_state(mode, current))
 		return -ERESTARTSYS;
-- 
2.39.5



