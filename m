Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA4E3BF66D;
	Sat, 30 May 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165695; cv=none; b=erL2A1X8BEykECj49RWmt8+pT6HjD5mlJEEraowrkrr5wQ4SN8TIhtThUr7aV8XYnxbK6Q6KMFnJ6pDHOFxgJLjcbohVoz/adIay92Z2okBea0kJGpafhlKYRBr7tW0yGm+MTVFK/E5kPRPuOz7t2MdiIuqhXHE9dbiziykxrwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165695; c=relaxed/simple;
	bh=qtqvXb87+Y4Q5OYEBcONsf1UYHmmT3iuALaUSwJQk7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv0MaV4yl+WXvU4W+KzlDLOMK98ftIA1/LjP2mCpnPYp53RinZjfM9TeKAdpNZPDXeVa69T6iLjUnuDDFPVgH409V01ime23uLRrKfbDhKl0SETPF5dcbauZL4RA8uwuACjyV1PtWNCklDjRLspkdPRfhfAdG06BL+xRWhm5GUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvIgIEHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvIgIEHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7881F00893;
	Sat, 30 May 2026 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165693;
	bh=lf6XRyrQS2pPt4kKu7LXMGsa9SERN6xrdRHzEE3jXaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvIgIEHRSSgFEyolg+c9qKu+XpOnSAwbpYoCE1WcViKWFb1+Vzci2Fo2K/0hQqxMj
	 nQ1t6r0CSyl9f+UZFVugU3UT1D3F0Ep9duAST0wa2nDEFv/TU77zUBRfWAD1bEScCK
	 3zWtJv9e66RcfBZVRUgJgpfS4eO38lN05KqMQWu0=
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
Subject: [PATCH 5.10 154/589] net: strparser: fix skb_head leak in strp_abort_strp()
Date: Sat, 30 May 2026 18:00:35 +0200
Message-ID: <20260530160228.836745544@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


