Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29EC2F0C5C;
	Mon, 22 Sep 2025 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570150; cv=none; b=HkV8uhICZbZsAJmBOCCQUzsolwqWl6eoKqxCSBVLgo2ib0ed8jbqAToxkWLbXAEsZ/LgxDqZYTQDbheVdUHM+AvVMCFDS0VKn17HKuSP6YV3hoZGw9TMR3Ao7XKz/aPOcBNsE7mdQv8tkHJdedZFmMi1gQEHCuDmp+lAYhwSYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570150; c=relaxed/simple;
	bh=LWoOU8CACM7p94LcRqQKJVzie7jBUoR6uzvz/ngD9eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsbsHgzZduVJR5Dl3wpVJqXGr3a+ueb/R6mxJKmNCLdL00CsNu8PkrZc+Yt9O9tdQNDCHEq8RiXA3EDKGPjJPSaAAd/asjjYtNm7+yLdcjfU+ob5YXtSVHCGnKe71WV5UmRgW3Iu1S+N5Ne/WnZNoxxG7lsNCRdPlp5cv8pkIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTWxuwcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTWxuwcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B952C4CEF0;
	Mon, 22 Sep 2025 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570150;
	bh=LWoOU8CACM7p94LcRqQKJVzie7jBUoR6uzvz/ngD9eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTWxuwcuEan4Uv5UKoO2xaSECLGUYxVZ2tUBTnArJn87BJUv7u9+3fLjwU2dnkIYi
	 ytzRJA26afZVNCltf3bhJqub3QdS+OJN+vd60rg83HUZidLgf+7J9YaQdH1P7JlcRG
	 ++UbwHqhohn+3ubqFHSffhqdg1zEGOhmXgXmSaj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 025/149] mptcp: set remote_deny_join_id0 on SYN recv
Date: Mon, 22 Sep 2025 21:28:45 +0200
Message-ID: <20250922192413.504838629@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 96939cec994070aa5df852c10fad5fc303a97ea3 ]

When a SYN containing the 'C' flag (deny join id0) was received, this
piece of information was not propagated to the path-manager.

Even if this flag is mainly set on the server side, a client can also
tell the server it cannot try to establish new subflows to the client's
initial IP address and port. The server's PM should then record such
info when received, and before sending events about the new connection.

Fixes: df377be38725 ("mptcp: add deny_join_id0 in mptcp_options_received")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-1-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1802bc5435a1a..d77a2e374a7ae 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -882,6 +882,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			ctx->subflow_id = 1;
 			owner = mptcp_sk(ctx->conn);
+
+			if (mp_opt.deny_join_id0)
+				WRITE_ONCE(owner->pm.remote_deny_join_id0, true);
+
 			mptcp_pm_new_connection(owner, child, 1);
 
 			/* with OoO packets we can reach here without ingress
-- 
2.51.0



