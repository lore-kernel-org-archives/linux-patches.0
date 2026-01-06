Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F78C355045;
	Tue,  6 Jan 2026 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720348; cv=none; b=ALSuU9exMY7QvcVrojLgDn+oIekhcHs00tFEX//yphIDC1JGiHpCSvNvmOFQC1zX7ey5JzUhMd6DnDk4cC7BHokdGxRC6cOQSA+Oab7ktn0R/L3NdbGyseDAwR+5HGHDeifVYV4zxm3x0fPwXXwP6ZmS0L1deDvSuEMRgrRUT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720348; c=relaxed/simple;
	bh=wG3QmjJu7Fe2crQ/xertlmo5L+n9IWs/OEsH1sGez80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLnFpSj8iHVMFA7xMlVen/v2gbWkmLaiHckMtZTLwEUbV3bFOgeL85v9VgClb6ExRqW0KCuGF709LWYcK+c6p5ERYXbZ9chhUeIzcnOu3GjnuNUtnzQW/2la/4M6gZ9147hb2Js0J9IBM6c8Z6U3CsPBAaR3eoRRrhTU2BXBa2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/FtVNCb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/FtVNCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95891C116C6;
	Tue,  6 Jan 2026 17:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720348;
	bh=wG3QmjJu7Fe2crQ/xertlmo5L+n9IWs/OEsH1sGez80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/FtVNCbJ4Vt55hrs7sNJHME5un4+b0uJxg/i7VBsSv/kpoJLhwshk1RMmuEch1AR
	 3+ZtaBLGzSS6gVIhmQ+f1+fe45+9uu47973mK8losXe5FzPv6sE5LO35hW47O5sobc
	 4cwIl/Deraj6sPfb69Pp9ciJEq6PcKjNr0kXs3bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 176/567] mptcp: schedule rtx timer only after pushing data
Date: Tue,  6 Jan 2026 17:59:18 +0100
Message-ID: <20260106170457.838012560@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1637,7 +1637,7 @@ void __mptcp_push_pending(struct sock *s
 	struct mptcp_sendmsg_info info = {
 				.flags = flags,
 	};
-	bool do_check_data_fin = false;
+	bool copied = false;
 	int push_count = 1;
 
 	while (mptcp_send_head(sk) && (push_count > 0)) {
@@ -1679,7 +1679,7 @@ void __mptcp_push_pending(struct sock *s
 						push_count--;
 					continue;
 				}
-				do_check_data_fin = true;
+				copied = true;
 			}
 		}
 	}
@@ -1688,11 +1688,14 @@ void __mptcp_push_pending(struct sock *s
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


