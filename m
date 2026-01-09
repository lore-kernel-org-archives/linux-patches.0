Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BAA35A947;
	Fri,  9 Jan 2026 12:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960601; cv=none; b=BGYeufdPVPCvHUe5kE7+u8vjCKyc1eMuJgHwbXzy13wPGEUAfYnQfVc7bvHd8F64npmvyuffnxwxMmOE7G+8ucT4zDFRrRXTcSimuZDs8VSWwpZNEozTBLzwaX/ANq8gqkM1BaYzjm4uZw5O4VC8ILAMBGawQVopsn4XwLlkSuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960601; c=relaxed/simple;
	bh=wffMHlbkjJRorYBsuozl+bs3uNwyl69hxEck6jCk4To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugWWAwv7jV5fvZcQjky7lq9z5hgZnps46/cOeRFBrPs0ukmDjkXoWRyO4UJxBNpBV5lNp8yGjfy5JCvFjf6yrMA/e+n7D+4Ad9K/gGDOOBLXVZsb4NvehhagHSkIMG8RgQG0SwknKB1LkvQy4CZGUl+NszeAQ3nhf9BJLydaoDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJ61Qzyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJ61Qzyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1356CC4CEF1;
	Fri,  9 Jan 2026 12:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960601;
	bh=wffMHlbkjJRorYBsuozl+bs3uNwyl69hxEck6jCk4To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJ61Qzyh701Ky7Y3IZ8Ez/nvg5TGljvKo0+on3+bY5nRUswago8nqRzqF2m85NXCB
	 qlV1X4+pS9KtXkaKQMGxXP2CCBLB6qJCSS+IdBZWi52+lAOPXoZsgqevDl6dZ3i/Vf
	 i4ejIDsPnE1b2TchcWde3dEIbvXmD0C6O5AyRoZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 429/737] mptcp: schedule rtx timer only after pushing data
Date: Fri,  9 Jan 2026 12:39:28 +0100
Message-ID: <20260109112150.135001931@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 2ea6190f42d0416a4310e60a7fcb0b49fcbbd4fb upstream.

The MPTCP protocol usually schedule the retransmission timer only
when there is some chances for such retransmissions to happen.

With a notable exception: __mptcp_push_pending() currently schedule
such timer unconditionally, potentially leading to unnecessary rtx
timer expiration.

The issue is present since the blamed commit below but become easily
reproducible after commit 27b0e701d387 ("mptcp: drop bogus optimization
in __mptcp_check_push()")

Fixes: 33d41c9cd74c ("mptcp: more accurate timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251205-net-mptcp-misc-fixes-6-19-rc1-v1-3-9e4781a6c1b8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1630,7 +1630,7 @@ void __mptcp_push_pending(struct sock *s
 	struct mptcp_sendmsg_info info = {
 				.flags = flags,
 	};
-	bool do_check_data_fin = false;
+	bool copied = false;
 	int push_count = 1;
 
 	while (mptcp_send_head(sk) && (push_count > 0)) {
@@ -1672,7 +1672,7 @@ void __mptcp_push_pending(struct sock *s
 						push_count--;
 					continue;
 				}
-				do_check_data_fin = true;
+				copied = true;
 			}
 		}
 	}
@@ -1681,11 +1681,14 @@ void __mptcp_push_pending(struct sock *s
 	if (ssk)
 		mptcp_push_release(ssk, &info);
 
-	/* ensure the rtx timer is running */
-	if (!mptcp_rtx_timer_pending(sk))
-		mptcp_reset_rtx_timer(sk);
-	if (do_check_data_fin)
+	/* Avoid scheduling the rtx timer if no data has been pushed; the timer
+	 * will be updated on positive acks by __mptcp_cleanup_una().
+	 */
+	if (copied) {
+		if (!mptcp_rtx_timer_pending(sk))
+			mptcp_reset_rtx_timer(sk);
 		mptcp_check_send_data_fin(sk);
+	}
 }
 
 static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk, bool first)


