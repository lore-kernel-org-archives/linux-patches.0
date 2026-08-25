Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6B44163B;
	Tue, 25 Aug 2026 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666032; cv=none; b=WsYp355dTC+81n8E+KcCFNS261QRljSQsDW+9ZJsuPOLzYcJtl7OVSVvMEV2X3TM/5CugMBm8CNHc4rqsu/vraBT4OPjzZ1/plPuQgc5Oru6qr/+mtPe9jjVOu0glUZUSxHaBm0GX/74kdOTvS0L9+VkG8NKYHZ441d+mlBUmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666032; c=relaxed/simple;
	bh=lnP55SK+RrMkmxvZCNGCnoxwrEd8EwnHmtIDHIyQ6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyNIM7wM61LPMlzO6CMt7lWKNrt/uXYV6iPNmsRz2zgHoEQsX+Yu1srA/aF0nQez47BkTQLHYzWGlA/5KLx3pLVGAi3rMIpPT7iAeBIsnQpM9pcLdH+elq7rouRJXuhp8fTVWE9hLG8Vj3cEcBD4J4NpPFS4cMt8X7l0uQRvH38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0//WYql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0//WYql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBA51F000E9;
	Tue, 25 Aug 2026 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666031;
	bh=QqJYWnqJG6Xu7s491Im2s0Zw60m+LNOJ4QQ7J4YOUnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0//WYql1LVDbwsNO98AiVqrs0xK72t6P+8FkGz86IEQfGh61bLWn0ia2g9yD6Gaq
	 fz+OOhxn5S54f2x5BjRjZUsq/zMJDzL7JxRZTaNZRrB1tiWGkD69Pww2zLX/M92wCh
	 bPcv0rKtAEIkx4qlgc54TujhPFXUSTRfOHwWp51Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 62/79] mptcp: pm: ADD_ADDR rtx: always decrease sk refcount
Date: Tue, 25 Aug 2026 15:26:42 +0200
Message-ID: <20260825132544.107760110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,11 +309,8 @@ static void mptcp_pm_add_timer(struct ti
 
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
@@ -357,6 +354,7 @@ static void mptcp_pm_add_timer(struct ti
 
 out:
 	bh_unlock_sock(sk);
+exit:
 	__sock_put(sk);
 }
 


