Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4776D4E2F13;
	Wed, 30 Sep 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786388; cv=none; b=IivbU0SYxj8HZcBk11gyFz//5s4POUyHtCGS9zThfWWspvhTTFLehJegXLNP+/NQzklhd1/AJZKT/ZaweWBP2VkWfSSn6Xg50T3/gi/f3BawDhQekFHHDm2qF9EfquiXgd//VRWQZM0gVh2ycignMxPj4m9b8PbFLkbyyBpmflw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786388; c=relaxed/simple;
	bh=HbTWXAmchqxjOCpbI/X1pZdoEPw8YhVNNJ4XIzAra4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAPaSR0I6QGUz/LFMwMCkfqYonbx/wsxxgtUwSBdLapwWOu0k2TQQTukpVrmUKjSpRU+kASOOSi5gcKEvOdbmZYA3Rda+wNig57H9IlvJkwzLVgdKa2axTIBn7DNZdWNFd7ik4+A3t4AjcLXrOD0Og60X7/iXMOQ1k/3VdetjhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFKIA3+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFKIA3+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1301F000FF;
	Wed, 30 Sep 2026 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786387;
	bh=gZdHa80f5VhilBXvPn2kjx7ZqDpmWWrD2XWsxUkIKgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFKIA3+OrAuALen2ve4yQ18cVSOP5X9Apu4RHm0lGSqvj4E73A+SSfAJy0GtTcnGW
	 JhkY1I+9bIWr/bo1rHxWjeJzHFy86p3VOpNbluGWHHd/3UvczirH8cj8xAD94AAPdT
	 XzNiS4rxuwUyilq3TwK/+3fCpqC23b63RziB+hUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 845/982] sctp: avoid livelock while updating retransmit path
Date: Wed, 30 Sep 2026 17:26:21 +0200
Message-ID: <20260930152434.900511837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index c141f8a1262df..a957142672cb2 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1305,18 +1305,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
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



