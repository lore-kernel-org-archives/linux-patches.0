Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA702E06E4;
	Tue, 25 Aug 2026 13:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666291; cv=none; b=iyi1MZUOof5x33XuhSMKpI2clfgxhXPz/7egNzbEPxE7NrnvwuuWdcAi/iesTG3bLPr/Zj0efZqAGEETB9j8Hmjc1y6wPYEMKAmrA3FrHCL8r8yBYZBFf6Yx5uktjyDoWELNdkKtiIszg461dSGcQLxJee9I2MKuJMHZPNlTbfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666291; c=relaxed/simple;
	bh=0FKJHOpoAyCFAlO+ImMxZv+XKYl88zsPG+apgqsK6Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+3hStCcQnCS4xul5lROwJvK6CSW0oN1jn6q11C19n+hswLe8emOJH693shW3axBaAF7qgQ0ephtkSitqWcXvjvpV5JSJqdQXG28jW8qdvOuBtP1677ZUwuFG8eRq1RMsnVedrkKkOfJroBkAkZAat9DOZ3iu0/5eO8ogHiOBDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIA2ftib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIA2ftib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E348F1F000E9;
	Tue, 25 Aug 2026 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666290;
	bh=9WVngI/G4RA48y2kY0nny1l3QzP1Qho5eTIHqWHgc00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIA2ftibCAtfh5CNhLsIW82JkKZk3M7UZ8vAQsD9yf08BRS2JbBEbnm4/g5szsI+j
	 +CW2ADkvnTw9bIP8GP14MYV/e5xw6oLHJ95TV+DdOybm4MsC3bk2aYCF5xr7dIgXN+
	 VTdE1XV1u8JO1E+Gcwhi06/AVX6yCF+3GcymHdxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 69/76] mptcp: pm: ADD_ADDR rtx: always decrease sk refcount
Date: Tue, 25 Aug 2026 15:27:02 +0200
Message-ID: <20260825132544.258961017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 9634cb35af17019baec21ca648516ce376fa10e6 ]

When an ADD_ADDR is retransmitted, the sk is held in sk_reset_timer().
It should then be released in all cases at the end.

Some (unlikely) checks were returning directly instead of calling
sock_put() to decrease the refcount. Jump to a new 'exit' label to call
__sock_put() (which will become sock_put() in the next commit) to fix
this potential leak.

While at it, drop the '!msk' check which cannot happen because it is
never reset, and explicitly mark the remaining one as "unlikely".

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-4-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a7aad5b69d3b ("mptcp: pm: fix data race in add_addr timer callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -320,11 +320,8 @@ static void mptcp_pm_add_timer(struct ti
 
 	pr_debug("msk=%p\n", msk);
 
-	if (!msk)
-		return;
-
-	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
+	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+		goto exit;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
@@ -368,6 +365,7 @@ static void mptcp_pm_add_timer(struct ti
 
 out:
 	bh_unlock_sock(sk);
+exit:
 	__sock_put(sk);
 }
 


