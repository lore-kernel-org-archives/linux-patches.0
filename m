Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2784025F780;
	Mon, 22 Sep 2025 19:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569857; cv=none; b=WMK8IcsppwrTUfszPARyVi4qTl11Hp1+WEeo8KP279HAGcXU6zHuDTZwHpazA/5ba8dm6l/x/BHYGZOzbkFDeq8c0uXzS1LMUuYeVjDrKst/Ma/jGSff6xCiyAOfHLoAAvdwpbFa40B6VQ6f+yKt2/PkRM90TPL82fcwG5X6j/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569857; c=relaxed/simple;
	bh=JLw5Ehds3cGmOBCZoMmBx7myAHwgekBjwnI7pH9t5fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pocNm8t4jLtbCr62WeyKr7pI+bWHqcZzukfPe+NumLHR64ayUFRBr+UjnbAYCznOZd8VADiUhAIDpdNP8Xc0XQlZ5wEIMjc28+M5wZmafuSqUawhWlWI6VuKSIygs5COJ4wBLNTSkY4z31i6NLS9JlgQmvFnx/x/EmRQzZmb+Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4UDMTuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4UDMTuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5265C4CEF0;
	Mon, 22 Sep 2025 19:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569857;
	bh=JLw5Ehds3cGmOBCZoMmBx7myAHwgekBjwnI7pH9t5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4UDMTuEo/VVGJN3qW8v89TYumwqe9DHSdsiABLmuUSzzlFVzsMpyuZMKuPuhgfDF
	 DYVmUkuM2Xrg3nyUwM9gMxgnImeaJxxBJ72Id1t0mgS+0HydfR3lbCHNmTjOf77UyU
	 I9CwgIrrS9XFKpxXZElqMEpJafHsRFo+QvuBdTqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/105] mptcp: set remote_deny_join_id0 on SYN recv
Date: Mon, 22 Sep 2025 21:28:58 +0200
Message-ID: <20250922192409.306519210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a05f201d194c5..17d1a9d8b0e98 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -888,6 +888,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
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



