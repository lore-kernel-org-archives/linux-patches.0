Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8BD58B6AC;
	Mon, 31 Aug 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184235; cv=none; b=UJ0eNF4vPs4xgX0YgV7Aw3zio2JbFZZreYdaTO88JzvYN/vZlyAsc0CX08m6WcvqAahXl0a+DgPlB7I8egmSCOK00wOZE6X2lUWxpXGgVay8/mXvNvTENf+NNkNjwqRTarU3Nmu9t0H73pxI7jjBpuo+hjW/TCe/N5WxbRZo7dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184235; c=relaxed/simple;
	bh=ap5nmz7cLv2wSoLDZBvDrpvSYRbB5n4piKwNGIk5EWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/ZlLMiZKfoeSpQFBcGS/uoPxqm+Ykj/5JqwTs2woGHhoK0fd3mm2Je9ZjTeCeyNg8YrUcRFT/QeoDw9KEHB6gW2O5t+fVv9nxXx/8gNEhhQT0UTo+GuXVvvJIH6JfzHcl/IhtyFyG767At9G9d4jOKFl3nDoJZM7GBoZDiiqlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIcxua6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIcxua6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59ED1F00A3D;
	Mon, 31 Aug 2026 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184233;
	bh=lay+KDZ2Ka3hNIRIA9Uno3Pf/Meu0UeuDIYSIDk35iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIcxua6SfdyQw0mtGPaBil5F/ECz6y7mmMnm2N7tPDgDji5OoJHIfhMoVxqfZg94g
	 PjxZhr97xOmwm72nWnjwr47TMwgMxeymcZIPv6egIlZvxS1iRcasn6QpmVLRvAWxlZ
	 lhcIOiTGvndBwzfjY9ajRz8rQZbM2PGro/zNj9FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	syzbot+ddc001b92c083dbf2b97@syzkaller.appspotmail.com,
	Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 37/99] ring buffer: Propagate __rb_map_vma return value to caller
Date: Mon, 31 Aug 2026 15:34:06 +0200
Message-ID: <20260831133401.872323054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>

[ Upstream commit de4cbd704731778a2dc833ce5a24b38e5d672c05 ]

The return value from `__rb_map_vma()`, which rejects writable or
executable mappings (VM_WRITE, VM_EXEC, or !VM_MAYSHARE), was being
ignored. As a result the caller of `__rb_map_vma` always returned 0
even when the mapping had actually failed, allowing it to proceed
with an invalid VMA.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20251008172516.20697-1-ankitkhushwaha.linux@gmail.com
Fixes: 117c39200d9d7 ("ring-buffer: Introducing ring-buffer mapping functions")
Reported-by: syzbot+ddc001b92c083dbf2b97@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=194151be8eaebd826005329b2e123aecae714bdb
Signed-off-by: Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e59094a458989..854796fa7a464 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7149,7 +7149,7 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		atomic_dec(&cpu_buffer->resize_disabled);
 	}
 
-	return 0;
+	return err;
 }
 
 /*
-- 
2.53.0



