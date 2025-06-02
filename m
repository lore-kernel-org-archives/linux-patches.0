Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946F1DF73C;
	Mon,  2 Jun 2025 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876643; cv=none; b=K0EfYszKRQHsK0F+/eQ4VjN4qgbLEbf1KIeVwCKQ0DKsN+F0SVcMzaNjuROjcHlLvo8wy9f97g3NDTwKbwktNqjoOBk0S53m9PSD1aE6rMoy0bi65pb5PXiVgeUIPO6M3Sz0YJcLuqq7GflACPoJHJi0KY2kJdBn5qKUC25sn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876643; c=relaxed/simple;
	bh=MggCGVYc18z6x8Dw4LbVgD7Iyhh1fSRvcFz5nXBNUlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eob9KS9qj6d2S84Ld0ro26MxZ+RW78nuqKJHEMmsTd7EryC7eZkzKyFu9OmhARWr2J65Ray65gIh82Od88EU2xfWS43SBEeodI8pbczdRsfaCu6apG5lkv8AvzVIAxr8mcG/K6l1BmbkvIgdd5fPKtmwtVbJJEEgsjl9LfbYJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfCe+gUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfCe+gUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC479C4CEEB;
	Mon,  2 Jun 2025 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876641;
	bh=MggCGVYc18z6x8Dw4LbVgD7Iyhh1fSRvcFz5nXBNUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfCe+gUw63uTClldiXfQMG6AZpjXtTHhW4auuHW99UDhxDisS5MlBKWykwhscZFyK
	 UvxKxoJKEG1lyeQPIAjZ0wADDWs3+Ky+9luQhM0lis8PTVdChpnTV0amReoWw/UvO/
	 1mmVoGMlali8sa2DJbV/1E+UNXxGzabn/5rwSQJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/325] SUNRPC: Dont allow waiting for exiting tasks
Date: Mon,  2 Jun 2025 15:45:03 +0200
Message-ID: <20250602134320.838889252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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



