Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473A5C8E6;
	Mon, 22 Sep 2025 19:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569484; cv=none; b=hnh4+qLDcEcBTXGM/stXns8SW+VOvb2PzZdTzfe5RNKWv4B24NzfViR1s0x4+s0wvLV16gohMuPyDbRc+Kz2PZwmwuVD3W1PuB2bbxZa1Ao8aF+bUisG5GK5SQ+phk1NMuMVaOOXDo3JyRs5iTY3sF+ru89fMwgZS6n/Yl/PPgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569484; c=relaxed/simple;
	bh=L6rDeb1hlh9t4gwBLm+RZT0XTardFQN62SYEanFuEEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYXaax96m6SRZOoniGE34X2N8t9HtIAMTU19ue4d/3zFVHrQx+vEpxICKg42W/dqBU9YngHOLjCKQkNSBupGuf2rIRHys7wB8j1jxOr2gZCE1cm/ujNjVU8Oj5iAg8z8yRR0/ZMDdPT4twWgSj0cQQAab5S2GouOAgQcc3SfRnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZRUpcDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZRUpcDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81557C4CEF0;
	Mon, 22 Sep 2025 19:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569483;
	bh=L6rDeb1hlh9t4gwBLm+RZT0XTardFQN62SYEanFuEEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZRUpcDmqHLiVnVuDgqzO6p8gWjgV8VS3zRImyyTBsUOvkHz1LfzhrkWIpLxUUi+h
	 gbPSytvIdNAg57ciY1hVAx5hbKEZ+s7RM1TbAnRQlxp5Cqe2L3WwMMvrLaIDVqGKST
	 VxBC4BhbVhfDeWEFVDtD/x7+l13DJUhKxW/iRaaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/61] mptcp: set remote_deny_join_id0 on SYN recv
Date: Mon, 22 Sep 2025 21:29:03 +0200
Message-ID: <20250922192403.831896713@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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
index cff2328106928..2ff72b7940fe9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -773,6 +773,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				goto fallback;
 
 			owner = mptcp_sk(ctx->conn);
+
+			if (mp_opt.deny_join_id0)
+				WRITE_ONCE(owner->pm.remote_deny_join_id0, true);
+
 			mptcp_pm_new_connection(owner, child, 1);
 
 			/* with OoO packets we can reach here without ingress
-- 
2.51.0



