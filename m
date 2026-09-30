Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE19C403E8C;
	Wed, 30 Sep 2026 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796711; cv=none; b=LrOND8kYScOQkRjgV/szLvKo6If77kn9QFDzwCoDVnLbjYhjJFy0PYAbAqCqEzATgjZwf5YZGlPK23LPLkNuxFNaiPf9VB37Qt8n/22tmudfaBncqYM2PnAW1RsFjsMmlsDAH1tye0PkjRq3sGUPhGWuM8BmRhNI6SWE+Pjc404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796711; c=relaxed/simple;
	bh=pfU1nEbl82vdJtZj+WArh+4S8hsYKDFyD1aao3OUaqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1Pl3eAc8UhU5tiImW1zZAxJVVavZ1gKrkKGErd+nqatsoQwp8xuqiqagJL98FnzBsPmzlWfXGWGYRs6dTjRWYxrndTFucAIK2q5PZ07/PMujHAWzlK88WiDfu66+adykT0aGqDGT05+GBaXQAAxjw/6edbrL+RPRQaLiC6hCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmXWWVUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmXWWVUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6FA1F000FF;
	Wed, 30 Sep 2026 19:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796709;
	bh=x4edZlo35Gs5YtbBLovkbn2wVZDcSJZY6bM/uJdWTCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmXWWVUBZCTaRUGg4a7kWD4ZSaE+tEx/CmFoDHVLXBzFybAmj0C6eMjd3gvCghAFM
	 okt8Um0T9JT0dmx63avn28pYUWLl5zGuxO7NvY/UDNfXFRHVNuIBuRIqLnN6dGGgA2
	 CMuLFoqcJbcQcErYqGnxHO0i4RT9SiIEdmVo95KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1010/1193] sctp: avoid livelock while updating retransmit path
Date: Wed, 30 Sep 2026 17:28:14 +0200
Message-ID: <20260930152456.682738848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit d2c31b837406395e576afeb25958c98e9938f3f6 ]

sctp_assoc_update_retran_path() can loop forever when every remaining
transport, including retran_path, is SCTP_UNCONFIRMED: the state check
runs before the wraparound test, so the loop cannot observe that it has
completed a full pass.

Fix this by considering a transport only when it is not UNCONFIRMED,
then checking whether the walk has returned to retran_path. This makes
the full-pass termination independent of the transport state while
preserving the existing fallback selection semantics.

Also restore the NULL guard around the retran_path assignment. In the
all-UNCONFIRMED case there is no eligible replacement transport, and
installing NULL would leave later retransmit-path users and the debug
print with a NULL path.

Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path selection to rfc4960")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260915095017.942213-1-sunyiqixm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index f409b9f6b228f..0a19aea3b5246 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1303,18 +1303,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
 		/* Manually skip the head element. */
 		if (&trans->transports == &asoc->peer.transport_addr_list)
 			continue;
-		if (trans->state == SCTP_UNCONFIRMED)
-			continue;
-		trans_next = sctp_trans_elect_best(trans, trans_next);
-		/* Active is good enough for immediate return. */
-		if (trans_next->state == SCTP_ACTIVE)
-			break;
+		if (trans->state != SCTP_UNCONFIRMED) {
+			trans_next = sctp_trans_elect_best(trans, trans_next);
+			/* Active is good enough for immediate return. */
+			if (trans_next->state == SCTP_ACTIVE)
+				break;
+		}
 		/* We've reached the end, time to update path. */
 		if (trans == asoc->peer.retran_path)
 			break;
 	}
 
-	asoc->peer.retran_path = trans_next;
+	if (trans_next)
+		asoc->peer.retran_path = trans_next;
 
 	pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
 		 __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
-- 
2.53.0



