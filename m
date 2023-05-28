Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC6A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6AC433D2;
	Sun, 28 May 2023 19:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303391;
	bh=PkeISsPAp7dyEgU+SNxRhF2FIA9gHYrFGfD/nuvP6vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymbR1x8aqWIVnMi48ZtrJd7tHgzMzj/JlldFKimTKEWLDbDjERQi1TGWJJwpRX14d
	 PRwaUDfM+BhBeAlkiALWanYoMPKCELgzRYEBWzwPQ+ePpSatMqQkmYgaFKEe5Yp3Jw
	 +ndJ2NNRsdydRBCowdZqDOjBvV2ROcslc8FTtEyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 57/69] sctp: fix an issue that plpmtu can never go to complete state
Date: Sun, 28 May 2023 20:12:17 +0100
Message-Id: <20230528190830.510408372@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

commit 6ca328e985cd995dfd1d5de44046e6074f853fbb upstream.

When doing plpmtu probe, the probe size is growing every time when it
receives the ACK during the Search state until the probe fails. When
the failure occurs, pl.probe_high is set and it goes to the Complete
state.

However, if the link pmtu is huge, like 65535 in loopback_dev, the probe
eventually keeps using SCTP_MAX_PLPMTU as the probe size and never fails.
Because of that, pl.probe_high can not be set, and the plpmtu probe can
never go to the Complete state.

Fix it by setting pl.probe_high to SCTP_MAX_PLPMTU when the probe size
grows to SCTP_MAX_PLPMTU in sctp_transport_pl_recv(). Also, not allow
the probe size greater than SCTP_MAX_PLPMTU in the Complete state.

Fixes: b87641aff9e7 ("sctp: do state transition when a probe succeeds on HB ACK recv path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/transport.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -331,9 +331,12 @@ bool sctp_transport_pl_recv(struct sctp_
 		t->pl.probe_size += SCTP_PL_BIG_STEP;
 	} else if (t->pl.state == SCTP_PL_SEARCH) {
 		if (!t->pl.probe_high) {
-			t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
-					       SCTP_MAX_PLPMTU);
-			return false;
+			if (t->pl.probe_size < SCTP_MAX_PLPMTU) {
+				t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_BIG_STEP,
+						       SCTP_MAX_PLPMTU);
+				return false;
+			}
+			t->pl.probe_high = SCTP_MAX_PLPMTU;
 		}
 		t->pl.probe_size += SCTP_PL_MIN_STEP;
 		if (t->pl.probe_size >= t->pl.probe_high) {
@@ -348,7 +351,7 @@ bool sctp_transport_pl_recv(struct sctp_
 	} else if (t->pl.state == SCTP_PL_COMPLETE && t->pl.raise_count == 30) {
 		/* Raise probe_size again after 30 * interval in Search Complete */
 		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
-		t->pl.probe_size += SCTP_PL_MIN_STEP;
+		t->pl.probe_size = min(t->pl.probe_size + SCTP_PL_MIN_STEP, SCTP_MAX_PLPMTU);
 	}
 
 	return t->pl.state == SCTP_PL_COMPLETE;


