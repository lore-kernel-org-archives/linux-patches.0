Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DCA2E2F0E;
	Mon,  4 May 2026 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902976; cv=none; b=JRzihykQWAeTyjeTNp9hGIxD5zlXs0lWwslKkTbrfbR0wbagSlNjXzNgxF7EHlWNnNe2I8r7cfaN6PXz3/mWtTr8H9lhOMQxad6f0PqPD92Hlz+/dg03HpzSnZWdG0SyiTpeIOgR79pQZjLSoQIla8CxypnsvFwRXKM1aiKXqqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902976; c=relaxed/simple;
	bh=esZzERpxuRqnqOg6z+9bqp2d0EyFZgTDZ0KlS9xMn4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwLpBtYhDNpjjiv/zZZG35u0S/3EWLBDO6MC6nmEY3hClwpFoErPZm5w4khK61ChyfiMI3fdK+5XBP3rznIzg02yXvPCg/6M7RntHdSJVoV9eC7DtamGTy5/w85+HOw5/2ctWc/jhGCUY0zVC2uj9+xASJ75+4wlh261BANxDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll2W+ENY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll2W+ENY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A6DC2BCB8;
	Mon,  4 May 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902976;
	bh=esZzERpxuRqnqOg6z+9bqp2d0EyFZgTDZ0KlS9xMn4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ll2W+ENYeuVF93gnsYc9jb/uwaEp6urOnuTrUeXnJrz98NYXxwMpcpdq8f6ulpi63
	 tUyHDzNkSRkH9oAcVZNfeX5p3TuQwlBiqKgpkjIk1SyPrfpp+lAyr6wiYPTJcE+kJk
	 8iMfYNQk74wRCmOtB5hbTtGw8Uk415wq8eqQ/KEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 055/307] net: strparser: fix skb_head leak in strp_abort_strp()
Date: Mon,  4 May 2026 15:49:00 +0200
Message-ID: <20260504135144.893622349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit fe72340daaf1af588be88056faf98965f39e6032 upstream.

When the stream parser is aborted, for example after a message assembly timeout,
it can still hold a reference to a partially assembled message in
strp->skb_head.

That skb is not released in strp_abort_strp(), which leaks the partially
assembled message and can be triggered repeatedly to exhaust memory.

Fix this by freeing strp->skb_head and resetting the parser state in the
abort path. Leave strp_stop() unchanged so final cleanup still happens in
strp_done() after the work and timer have been synchronized.

Fixes: 43a0c6751a32 ("strparser: Stream parser for messages")
Cc: stable@kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/ade3857a9404999ce9a1c27ec523efc896072678.1775482694.git.rakukuip@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/strparser/strparser.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -45,6 +45,14 @@ static void strp_abort_strp(struct strpa
 
 	strp->stopped = 1;
 
+	if (strp->skb_head) {
+		kfree_skb(strp->skb_head);
+		strp->skb_head = NULL;
+	}
+
+	strp->skb_nextp = NULL;
+	strp->need_bytes = 0;
+
 	if (strp->sk) {
 		struct sock *sk = strp->sk;
 


