Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B8D19E967;
	Tue, 27 May 2025 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366498; cv=none; b=lm3fyekctnsGXhfNYVkMHjIvd2Vgg0xYroUFLdzUbhqvR3BBPCurC/ElyOoKmrVEilMcDVuhfrKkM/urA2Ww3QVkEBUckBhs94e+E+8RFoKxy4BwM30G3Qil5pvIxFuu1C0+k99WF97UQLWqp26WG/nJ8QFX/ZqtLb95DcHtDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366498; c=relaxed/simple;
	bh=Wq/aoe8mH2XacxTCe/RHAZur5cAEx2kl8OgKwkBV36A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6qphINxwzPId3B9mgBChymauPSAqv0sXUFwKzy3xfSp/6oQa2dG85btViR+to17/SDUk0hDocnUYmb0S59HysEZnAq92jwCaBexXwfBppIlJ4WO0Ujn2JiuNe9EAgFLHwEvDrsDN4uXzWev0MTDMpCYBbYokrIlXlQ0DvawaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEFBhvOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEFBhvOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2824DC4CEE9;
	Tue, 27 May 2025 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366498;
	bh=Wq/aoe8mH2XacxTCe/RHAZur5cAEx2kl8OgKwkBV36A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEFBhvOPtFL1ETyLr0uPZbFS1mKGidbrd72hOk4MixmadKiT3G1WbzBfpEzha3cLA
	 5j9WLd+AkBS1c4ywimbUIYqK0o8VAfKeKPNsQj/Ad/ZStnMZ6aKFJELMdRSGpwme+F
	 fbKsBB+oqenVkHuAuaFXN8KgAkmQRLxa+A2h23p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 057/783] SUNRPC: Dont allow waiting for exiting tasks
Date: Tue, 27 May 2025 18:17:34 +0200
Message-ID: <20250527162515.449678528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



