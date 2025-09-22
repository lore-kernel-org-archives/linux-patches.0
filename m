Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309125F780;
	Mon, 22 Sep 2025 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569644; cv=none; b=mfzVlrJg4q9J7GhSw6Fao3qgMf1VfDyyH3EmFxfIdPsPY0KwMQoOJEDfqV4cgUkTzbzaq8hoHn9xGv+nNW7WnM8l4rk8P+AJeWtU+4j2TDApu2apwOBDEWvz1wiB4ZWjxZn9LO4ONmFuPh1soLbNAZCZgbqhL83WM1h50xSQiqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569644; c=relaxed/simple;
	bh=Ku14XHbyWgnn6oli+NA2V5xMIKepbfdFqJ8DjD+tL1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwVY1V6rk9BxUn67wKc4YYVl6XmE2+r+MkXBO4hhWVcE/JgFt5Rf7UcHIUxIOxiHdMJXb0eFd6thfz7aVI26t6V5xIINROYOekekxZjTOeXkLZ78XWRqB9TN7CZOtA9fhycJCXFyGVeyeJu0aXyX2XZ5v9vr9H6gmxYDHNTBi3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRXwrkKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRXwrkKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953D1C4CEF0;
	Mon, 22 Sep 2025 19:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569643;
	bh=Ku14XHbyWgnn6oli+NA2V5xMIKepbfdFqJ8DjD+tL1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRXwrkKEcKFSV7DtyMileNsndYTzm6X54XUwrjhJnMRx1r9W7VooPEU6hlFe4fS3V
	 0RCLykZCrIWvo2KvEdDt4aB91m5sQCDrqbNzaEGjIAVrhlS/RCtHiZ8Wwn4zi1q2/T
	 L8sT3W6ogaer+hrN9Fp9xVSOXNlF+1ndo2kZN2vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/70] mptcp: set remote_deny_join_id0 on SYN recv
Date: Mon, 22 Sep 2025 21:29:12 +0200
Message-ID: <20250922192404.837814865@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0c9b9c0c277c2..dfee1890c841b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -863,6 +863,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
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



