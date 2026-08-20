Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D19437F014;
	Thu, 20 Aug 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238712; cv=none; b=qhqnwudY/IQ1t7rmbelK6/inZSXj3CWqUR5jScAZlxdN3jOOWwyI5u60y7yWKyhaF+SmdqfmOpHOED32QjeFHCJKQBlm56DmKOLink7GX216/GbMi730aMPWp52gtG0Bdc3UTSP9X7AwB/sN4YEPeSPn6imCIRhDSdGzTZFoGQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238712; c=relaxed/simple;
	bh=7h7L8fDQNNC5cY5xFoiI6hmd/U5rdyTP2SFHh8Tkh20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPTjKJ7pZS5sJs8FAljIMWte91xj9C9B2p+hA1vXlrp/ubc3WbIMYpkplvOX7+so3zl0JU8hs0tzNGYy/y5lW44HUNbMOBzv8hbHKGGfy2tk+2744Vb6Q9PljY0oKLklGsf6nSJ3cdbPUEXQX6z3+reUfy3Q5H3NCBkTl7p9ebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fzq1+Gu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fzq1+Gu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF741F000E9;
	Thu, 20 Aug 2026 15:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238711;
	bh=DEVwGLsKiMP67aX6kvoRnW0Jxo7JXQIFL2VwF3C6iWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fzq1+Gu3lonbKtj98PYOdRHeZImHxeHecC+8+R0bZNtKpag+lJufqkhJCGPcLhdEu
	 po2zbopgoQ1zbCepkH7McLtt6gUUUjn8kqs4fGnglfL+17LdB2/+L7Ymk1OdwukSXq
	 DRuoi+eLVdqechp/WY6EveWpSbywzMV9tg/rXWnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 015/217] mptcp: pm: fix data race in add_addr timer callback
Date: Thu, 20 Aug 2026 16:53:03 +0200
Message-ID: <20260820145238.088680293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Qing Luo <luoqing@kylinos.cn>

commit a7aad5b69d3bdaec20a3ed9284e184502450c0cd upstream.

The timer callback reads entry->retrans_times outside pm.lock to decide
whether to call mptcp_pm_subflow_established(). Since
mptcp_pm_announced_del_timer() can concurrently set retrans_times =
ADD_ADDR_RETRANS_MAX under pm.lock, a race condition exists.

I discovered this issue while studying the code. AI tools helped me to
verify the issue can potentially happen under race conditions.

Use a local 'retransmit' flag set inside pm.lock to capture whether
retransmission is still possible when the lock is taken. This allows to
call mptcp_pm_subflow_established() accordingly, and not depending on
the situation that can be different when checked outside the pm.lock.

Fixes: 348d5c1dec60 ("mptcp: move to next addr when timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-4-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -345,6 +345,7 @@ static void mptcp_pm_add_timer(struct ti
 	struct mptcp_sock *msk = entry->sock;
 	struct sock *sk = (struct sock *)msk;
 	unsigned int timeout = 0;
+	bool retransmit;
 
 	pr_debug("msk=%p\n", msk);
 
@@ -377,14 +378,15 @@ static void mptcp_pm_add_timer(struct ti
 		entry->retrans_times++;
 	}
 
-	if (entry->retrans_times < ADD_ADDR_RETRANS_MAX)
+	retransmit = entry->retrans_times < ADD_ADDR_RETRANS_MAX;
+	if (retransmit)
 		timeout <<= entry->retrans_times;
 	else
 		timeout = 0;
 
 	spin_unlock_bh(&msk->pm.lock);
 
-	if (entry->retrans_times == ADD_ADDR_RETRANS_MAX)
+	if (!retransmit)
 		mptcp_pm_subflow_established(msk);
 
 out:


