Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12443A6B7F;
	Thu, 30 Jul 2026 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421838; cv=none; b=B6XhcnE7xDO7Ly45ye+bBDwkzfiTk7JRGXa2ogdTrE6y7wqowMtplSmFBkC2kfnqYskETACDCMgXMv0CMcpON9p3b25IklABHPGpgpA+7xuvWtkslMZ7cz3u4IarS7ssRvd+mbt8qBm2067RNE13UTUIOEfJeabP9E6lELxmJzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421838; c=relaxed/simple;
	bh=K9OBkFlzzo/HEV33UsMHNHPf5fLZ19aTdOapTnRIasg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFfRnrPFQIDqt7+GpmwbugrAOI+COq+UATf5DI22OMFsQJaQSqW56rQblz8/dbSeSld/sinfmKX/ZGomLsMYuGHZwSsKy6LuJtUScBj3dE/9pT1LbvgecvWEXHcWHL83Ruf4hKtGcbDdaNTB5mYrkW8Bpv6dG67qHCcS7gjnvaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+BjJSIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+BjJSIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBDC1F000E9;
	Thu, 30 Jul 2026 14:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421837;
	bh=h4c5eaYpJLP8rOXNjNhI/M6Jn7ZUHK0W9FL8GOHGi6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+BjJSIhlCpyW7AW/DftHtCGIPW4FHx1X8RZQMAKSHDBraRZ7qSBdVkBCT/abSOey
	 aFv+iSAfvLX2q/zZ1rb/7FztdddbStel+F2nyz3G2MSli/qkZ2QIDXFoL/bb36tlNg
	 XiCKDF4NfUKsaIP5J/BIv+ccONVYZZ5QYRn8xJNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 238/744] rxrpc: fix io_thread race in rxrpc_wake_up_io_thread()
Date: Thu, 30 Jul 2026 16:08:31 +0200
Message-ID: <20260730141449.351801972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 745fb794c3e933c023af9dbb5876a5e16ad2dc71 ]

rxrpc_wake_up_io_thread() checks local->io_thread before waking it, but
then reloads the pointer for wake_up_process().

local->io_thread is cleared with WRITE_ONCE() when the I/O thread exits, so
the second load can see NULL even if the first load did not.

Take a READ_ONCE() snapshot and use it for both the NULL check and the
wake_up_process() call, as rxrpc_encap_rcv() already does.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260708093534.53486-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/ar-internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index d2b31d15851b96..38b0997ce0cb3a 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1266,9 +1266,11 @@ int rxrpc_io_thread(void *data);
 void rxrpc_post_response(struct rxrpc_connection *conn, struct sk_buff *skb);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
-	if (!local->io_thread)
+	struct task_struct *io_thread = READ_ONCE(local->io_thread);
+
+	if (!io_thread)
 		return;
-	wake_up_process(READ_ONCE(local->io_thread));
+	wake_up_process(io_thread);
 }
 
 static inline bool rxrpc_protocol_error(struct sk_buff *skb, enum rxrpc_abort_reason why)
-- 
2.53.0



