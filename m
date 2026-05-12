Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD43EDE61;
	Tue, 12 May 2026 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609195; cv=none; b=JvNm1qWlD/v7HvyMCY9Mf2t9KjkWS3yl2cJf2NpkqTZng3IShJl+eba7O84oSA/qY5e7bwKYsw3n0u8qkVVbJ6akbLGs50x1HHlkmVZH45rBTPfP+R71khSj4dWfYPR3Xo9jc1lU6olfPPuKU/OpaqC/78KYMWuj1Y2G/qFGdt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609195; c=relaxed/simple;
	bh=4XWpFM4C8r6TQaoiygo7jATFJ9nFjlAhmAcUsPxeZzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuYInKp789iGjrhZYEwBpl5RDFSDJaGwLvDIXvw9OEiRYfpJzPcVu/UIcxXDOsRmwtGjxK2z4s5r0f5fnvoyidzcL8DuwrzvYQn3b9P1zSc6RLiOWcPrE/yib+ELkOotqEbDA95z63vRNZf8EvSfxGkMwo9CVatclKL1b+k0mJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSYxRzuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSYxRzuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1C3C2BCB0;
	Tue, 12 May 2026 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609195;
	bh=4XWpFM4C8r6TQaoiygo7jATFJ9nFjlAhmAcUsPxeZzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSYxRzuylbaLnTnSZoS3Cx+rHgwXLpp5VS3L6kxhYq15keHwiQQlKHidPRKhs6Jde
	 kufjM6wOfL0Kjge/flP6Mgc70QbpsdcDEDIJdQqDRS+XNG/BJ5PPY+VNVfM8kuN0VL
	 99boFT/NwT/TP3EuwsDgebVWui4K/i+UJLkPFE84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 100/307] mptcp: pm: ADD_ADDR rtx: skip inactive subflows
Date: Tue, 12 May 2026 19:38:15 +0200
Message-ID: <20260512173942.236449411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit c6d395e2de1306b5fef0344a3c3835fbbfaa18be upstream.

When looking at the maximum RTO amongst the subflows, inactive subflows
were taken into account: that includes stale ones, and the initial one
if it has been already been closed.

Unusable subflows are now simply skipped. Stale ones are used as an
alternative: if there are only stale ones, to take their maximum RTO and
avoid to eventually fallback to net.mptcp.add_addr_timeout, which is set
to 2 minutes by default.

Fixes: 30549eebc4d8 ("mptcp: make ADD_ADDR retransmission timeout adaptive")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-7-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -305,18 +305,28 @@ static unsigned int mptcp_adjust_add_add
 	const struct net *net = sock_net((struct sock *)msk);
 	unsigned int rto = mptcp_get_add_addr_timeout(net);
 	struct mptcp_subflow_context *subflow;
-	unsigned int max = 0;
+	unsigned int max = 0, max_stale = 0;
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct inet_connection_sock *icsk = inet_csk(ssk);
 
-		if (icsk->icsk_rto > max)
+		if (!__mptcp_subflow_active(subflow))
+			continue;
+
+		if (unlikely(subflow->stale)) {
+			if (icsk->icsk_rto > max_stale)
+				max_stale = icsk->icsk_rto;
+		} else if (icsk->icsk_rto > max) {
 			max = icsk->icsk_rto;
+		}
 	}
 
-	if (max && max < rto)
-		rto = max;
+	if (max)
+		return min(max, rto);
+
+	if (max_stale)
+		return min(max_stale, rto);
 
 	return rto;
 }


