Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B4A1C5799;
	Sat, 30 May 2026 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162435; cv=none; b=oWUJB/J1iAoluusxIxNFEOEHEdJlykNyZ/2VeApn4R3wihXGwSMKO6GsuQoCagO/atxck0zzFsXT7vvX+zCITT3vQ5QqJNkuRBC1bTn31v7N8LssNtW5Y3URCO0VQsrNBCSF5U1V7v/Uy1dLgp0COAEBEcZYbEojdSfqDhgnnmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162435; c=relaxed/simple;
	bh=dFOT1xrpY/ZrOeF22Z4jfv835nvtI+etdY8Kt6d1EA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUgn49HOqxiGWBCUgwJ8/6cDhFvMDXTm+Sg3UnUNlCh2bp65qn7Uwf750AGix8V+ouHkl4ElXFXkt9smAm/I57f0AZvl+x6bG5mmLu1E2b0yyiZ0FQGEAOpO1u7y6yfKztZqzJ365cZ7dJJGeU5MuaWux85WsMfg9ChE84DDH1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0djUT0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0djUT0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BB41F00893;
	Sat, 30 May 2026 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162434;
	bh=8Zk+kCsLlv3dJsiy+1Id3Gp+AtRcRTyKS3qAYZv16cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0djUT0dRbkxD63ryOPqzjccnPI/eDXeEgAwr2jAmLGX19SGc3xdpgsCNQz31S80P
	 afsh/bOq/qKLzSgdOcVFv9Q4sZRAQsLMuxnK71mezWbFOav8FlYJNTdYeT46Xs6zTU
	 c0g/ey8AO9xn9+V9yktd2fHHJCJhP9/0fBiD3g+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 920/969] tcp: Fix imbalanced icsk_accept_queue count.
Date: Sat, 30 May 2026 18:07:24 +0200
Message-ID: <20260530160326.142330329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7eca3292cac7c26dad4c236f51ba225c39a0523f ]

When TCP socket migration happens in reqsk_timer_handler(),
@sk_listener will be updated with the new listener.

When we call __inet_csk_reqsk_queue_drop(), the listener must
be the one stored in req->rsk_listener.

The cited commit accidentally replaced oreq->rsk_listener with
sk_listener, leading to imbalanced icsk_accept_queue count.

Let's pass the correct listener to __inet_csk_reqsk_queue_drop().

Fixes: e8c526f2bdf1 ("tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260506035954.1563147-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index dc32a3d8ef874..a275ab5321a96 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1112,7 +1112,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	}
 
 drop:
-	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
+	__inet_csk_reqsk_queue_drop(oreq->rsk_listener, oreq, true);
 	reqsk_put(oreq);
 }
 
-- 
2.53.0



