Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D343B19BC;
	Fri,  4 Sep 2026 05:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499963; cv=none; b=FdYQgtYX0I7mS2JMIjExCpUU883Kx8c5kz19tGrSJqnhxcs0Rb3OGeUvZsotTEMbuY/QTaReInYpDndv9/6caL58gj506EDZo9kUe6BiXE0RAqT8MDYermLRhuR7gJN1EbpDvI3Tq2yTLzK+myAgTPuQN8gmEAPcrnmi/fmoOQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499963; c=relaxed/simple;
	bh=bnsFuRLzEoZnSLoA2wdvATz7ZV7xQ+K+qnozSuFWXIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoBMJ/cqhIAY2f4bTSR/B9c75mkzdpk/uFSxTfiR/bMBaFU2UtQXJzu5zzW/D38rnauvLWhsiBN72rDQwP+0HLnJZuzNemKNkszmGQRoU5BfEvcL9XAGby0yjUgWrBU6iQ5Ly0LpRDg9sObB+riAcsSkoBS7wNPQpW647jIUaEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEx0AhJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEx0AhJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712AE1F00A3E;
	Fri,  4 Sep 2026 05:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499962;
	bh=SQmfmszmuzmmjlmvV4FVKLnnwyY8J0mFc4xESYriOl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEx0AhJs6duWN0dIToWR7zsu3b6x1uXNX2NdxluVfX3nSrpBdnQSv0e9Gpr9pgdPn
	 9cLIkhIBQcxS0jr8RPyhe7PHUXU5RMxHnVqKf9Z4C9/eCa3aUd9XmbZHju+OFEV49h
	 ZchrtDfVSnCjm56S6QTBGb4k6zIax/FDwMrfj1jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 603/713] net: l2tp: do not propagate multicast notification errors
Date: Fri,  4 Sep 2026 06:59:31 +0200
Message-ID: <20260904045817.344543128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit af20e269f7459d2ce69887fdf2fad7caf986c865 upstream.

The tunnel create, tunnel modify, session create, and session modify
netlink handlers send multicast notifications through helpers that can fail
while allocating or encoding a message, or while multicasting it.

For tunnel and session create/modify, a notification is sent after the live
operation has completed. Returning a best-effort notification error as the
command result can therefore report failure for an operation that already
committed and can cause callers to retry and accumulate live objects.

Keep sending notifications for listener visibility, but do not propagate
their best-effort status as the command result. This also keeps the tunnel
modify command consistent with the other notification-only paths.

Fixes: 33f72e6f0c67 ("l2tp : multicast notification to the registered listeners")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/54f48e812ca0424c47ffdb9a8182180921f7e6b2.1787247008.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -248,8 +248,8 @@ static int l2tp_nl_cmd_tunnel_create(str
 		kfree(tunnel);
 		goto out;
 	}
-	ret = l2tp_tunnel_notify(&l2tp_nl_family, info, tunnel,
-				 L2TP_CMD_TUNNEL_CREATE);
+	l2tp_tunnel_notify(&l2tp_nl_family, info, tunnel,
+			   L2TP_CMD_TUNNEL_CREATE);
 	l2tp_tunnel_put(tunnel);
 
 out:
@@ -305,8 +305,8 @@ static int l2tp_nl_cmd_tunnel_modify(str
 		goto out;
 	}
 
-	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
-				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
+	l2tp_tunnel_notify(&l2tp_nl_family, info,
+			   tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
 	l2tp_tunnel_put(tunnel);
 
@@ -645,8 +645,8 @@ static int l2tp_nl_cmd_session_create(st
 		session = l2tp_session_get(net, tunnel->sock, tunnel->version,
 					   tunnel_id, session_id);
 		if (session) {
-			ret = l2tp_session_notify(&l2tp_nl_family, info, session,
-						  L2TP_CMD_SESSION_CREATE);
+			l2tp_session_notify(&l2tp_nl_family, info, session,
+					    L2TP_CMD_SESSION_CREATE);
 			l2tp_session_put(session);
 		}
 	}
@@ -710,8 +710,8 @@ static int l2tp_nl_cmd_session_modify(st
 	if (info->attrs[L2TP_ATTR_RECV_TIMEOUT])
 		session->reorder_timeout = nla_get_msecs(info->attrs[L2TP_ATTR_RECV_TIMEOUT]);
 
-	ret = l2tp_session_notify(&l2tp_nl_family, info,
-				  session, L2TP_CMD_SESSION_MODIFY);
+	l2tp_session_notify(&l2tp_nl_family, info,
+			    session, L2TP_CMD_SESSION_MODIFY);
 
 	l2tp_session_put(session);
 


