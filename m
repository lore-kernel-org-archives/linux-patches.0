Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F7E4DEC26;
	Wed, 30 Sep 2026 18:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792405; cv=none; b=IJZrYtIRW3OOk02vgxHAZ8dC3RO2A/IDwVvOOYzN4IcZCg6NWEH7u4AVNTspzsr+jda7+lRRSn69eo9hsJ8PhUQjXlsetsMy6SaVqwqrasUXqHX1QTSya/wFb7V1sQeq5ZlaNYhS89TyWYrqEWBt0C2RofSygVESr8O7Ue3KRyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792405; c=relaxed/simple;
	bh=UGr84X/53tuV6kN2BMilXLx+ITx93x7j0n541UCPVfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIKwoIQV9bDyPQr74EEjqW5nnM0+cP+2j5qBS2TL4kLqAcWZ7/pEHXiCa/01nbuUmHzPrIWJAj8vjrzTNSHF0mzvWNp3RsUHvjNPE/8Ptir7g/9KgCipa2KYvizkS9VC47bOK/tw/zYe0kc7564wTHARwhjCNmBiVHqdwyHGYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBj40t+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBj40t+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7990C1F000FF;
	Wed, 30 Sep 2026 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792403;
	bh=kUzxOU+t/uhYsVX/r/hQ28zRWhDeaRJDm0pe9k4RAuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBj40t+5opS6cHMAV1GV8MZQ8OV20LgMuZ529vM2XE4PDzApbXLTXeYCjmPobSfTu
	 CWPQrLlZ9csV4HIyIYF8ht9JnJVQFy7Y72sNuHM7oDC/krVDdkrpkSLXXZzpEVrho6
	 XTUTm+nu7SXp7nU41VCLAjiBLN8quzQPXLwJ6CUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@h-partners.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 642/752] sctp: hold asoc or transport before mod_timer() in timer handlers
Date: Wed, 30 Sep 2026 17:28:32 +0200
Message-ID: <20260930152412.157816921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cae23ae3f7887a1cf8a75da38edcebeef695040f ]

Take the association or transport reference before rearming a timer in the
timer handlers.

The existing code calls mod_timer() before taking the reference needed by
the rearmed timer without holding the sock lock. This creates a race with
timer cleanup: if the timer is deleted after mod_timer() returns but before
the reference is taken, the cleanup path can drop the timer's reference and
destroy the transport or association. The timer handler then takes a
reference on the already freed object and eventually drops it, causing a
refcount underflow.

Hold the object before mod_timer() and drop the reference if mod_timer()
reports that the timer was already pending in timer handlers. Apply the
same ordering to the proto-unreachable path, which can rearm a transport
timer outside the timer handlers without holding the sock lock.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Tangxin Xie <xietangxin@h-partners.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/c31b5e3ee2b7274e804f5eba2f21e2412e7eef7a.1790013825.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c         |  7 ++++---
 net/sctp/sm_sideeffect.c | 37 ++++++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 70530cbe57d0a..b208569b4bf0e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -451,9 +451,10 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
 		if (timer_pending(&t->proto_unreach_timer))
 			return;
 		else {
-			if (!mod_timer(&t->proto_unreach_timer,
-						jiffies + (HZ/20)))
-				sctp_transport_hold(t);
+			sctp_transport_hold(t);
+			if (mod_timer(&t->proto_unreach_timer,
+				      jiffies + (HZ / 20)))
+				sctp_transport_put(t);
 		}
 	} else {
 		struct net *net = sock_net(sk);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4391f070dc1e1..cfc35dadaf74a 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -244,8 +244,9 @@ void sctp_generate_t3_rtx_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->T3_rtx_timer, jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->T3_rtx_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -280,8 +281,9 @@ static void sctp_generate_timeout_event(struct sctp_association *asoc,
 			 timeout_type);
 
 		/* Try again later.  */
-		if (!mod_timer(&asoc->timers[timeout_type], jiffies + (HZ/20)))
-			sctp_association_hold(asoc);
+		sctp_association_hold(asoc);
+		if (mod_timer(&asoc->timers[timeout_type], jiffies + (HZ / 20)))
+			sctp_association_put(asoc);
 		goto out_unlock;
 	}
 
@@ -373,8 +375,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->hb_timer, jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->hb_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -383,8 +386,9 @@ void sctp_generate_heartbeat_event(struct timer_list *t)
 	timeout = sctp_transport_timeout(transport);
 	if (elapsed < timeout) {
 		elapsed = timeout - elapsed;
-		if (!mod_timer(&transport->hb_timer, jiffies + elapsed))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->hb_timer, jiffies + elapsed))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -417,9 +421,10 @@ void sctp_generate_proto_unreach_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->proto_unreach_timer,
-				jiffies + (HZ/20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->proto_unreach_timer,
+			      jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -453,8 +458,9 @@ void sctp_generate_reconf_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->reconf_timer, jiffies + (HZ / 20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->reconf_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
@@ -489,8 +495,9 @@ void sctp_generate_probe_event(struct timer_list *t)
 		pr_debug("%s: sock is busy\n", __func__);
 
 		/* Try again later.  */
-		if (!mod_timer(&transport->probe_timer, jiffies + (HZ / 20)))
-			sctp_transport_hold(transport);
+		sctp_transport_hold(transport);
+		if (mod_timer(&transport->probe_timer, jiffies + (HZ / 20)))
+			sctp_transport_put(transport);
 		goto out_unlock;
 	}
 
-- 
2.53.0



