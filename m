Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8B53749FA;
	Wed, 30 Sep 2026 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787079; cv=none; b=fwKH2NnqDig7YWQNZqVrvMljqtk7at0qvIgLnTXw/RYDw2Ulrk3gAYxpjdD175IlKBhP/zBZv9kkJP9SUS6azeegSyyKO3iq862KWW7iX2i4M7UhAodvV4Ydo6G2xCEyfkAOc+evdETfE6gUMD59ArYHDAnZuqoQNy3/bletOEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787079; c=relaxed/simple;
	bh=HvUxnCmJIKqfGkXMVBWfuvKmwKg4spXf5yKCJt9rtcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxJSW3S4nWzrD0kGHJM7fWaW7xy/66JkZT5sF+VFr7e0kEr/9iM/uWkPXnJPBsP+EqKg+37CGnRi3JtxEocbBzSWwa/8XXlsRRKFVu0SX/ihL6rPpn8XlwNC/zr627AaPlgeKPCVC+Tr5t6dnVnZgSfvzCWa8zTqnaRx8FF2NaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHSUX+rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHSUX+rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1631F000FF;
	Wed, 30 Sep 2026 16:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787078;
	bh=p5IJhZ5uXMnXKhrDzLR4iYexGvHV1C11PPix8ID8ONE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHSUX+rzyW5orLkHtKz8tUKh+94G8+FvVJwZ0jtPsPlKkxVrfKGmB9GSskiCLhFH+
	 XgiZ9bOqOXiNeVDxfTEj7KUATCLuH86phuwikQm0azDNvXPJYblPdDPO0zq/YJrEKE
	 lCkm1ZzzVUXBsDEg2HNu4G8Fq2h3nuj5rpmFtKPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 102/457] sctp: avoid livelock while updating retransmit path
Date: Wed, 30 Sep 2026 17:23:27 +0200
Message-ID: <20260930152348.252445616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 5be0bed2685ee..1220ff909fbe3 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1285,18 +1285,19 @@ void sctp_assoc_update_retran_path(struct sctp_association *asoc)
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



