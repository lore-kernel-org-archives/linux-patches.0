Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A046442FD2;
	Thu, 30 Jul 2026 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423957; cv=none; b=Kc2W7fTKTN1n55hi9wVR1GKF8J0x4Gzria9IN8CcYBzhZie4i6XuqksPyOVecVCWNEa2wjpkIeDClvWsDipb/iUz5rGE+bl5XyyGXLefDJ9vmoUx9Tc0jaWbqZl9OWfg4p9p06Ch92MJAdVTQX6C65Z6n9Q3SKY8qyCh6YWWX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423957; c=relaxed/simple;
	bh=axPwUSfSXCE2l8/vHImxtm2UR8HtSwJ1k8kQrgL39CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DY88qpelCJN+7Qcv1x+bM94kD3IuIoDt91dJqphWjrxqv4iUlwtO863dY2k65iCRFoj9Z18wJ8LNs6S0CoiKiHpQdj+7ZIZRYP0zVWya613WO/FmDbIPVro0F8exxDIIuNiiVCwjrO9cthyM8XA0zA5FPW7LaUYQqNBTlj7bVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sytsl/uf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sytsl/uf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3D91F000E9;
	Thu, 30 Jul 2026 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423956;
	bh=2yCkDdU9Q6t4pmWp+XGnchZ2h5UOld/Fju/Ws0W6dbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sytsl/ufJb9vlTJZWvHTjtxDwlTbw7OCktduiKpgmaluS7cPLHMxHMInkJfuszX5C
	 3+ndPOKwyACpXC3bvKlMXEDfL/3hmfHo8TyYpIq0RfdkzQGsqKznJlnB6FJ0YOAi50
	 9DZH9a/gyV0fmW8CziQh09JuE3E9/DTkMN48iV+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/675] rxrpc: fix io_thread race in rxrpc_wake_up_io_thread()
Date: Thu, 30 Jul 2026 16:09:08 +0200
Message-ID: <20260730141449.776916453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



