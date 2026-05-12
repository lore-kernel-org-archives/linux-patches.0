Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807173EDE52;
	Tue, 12 May 2026 17:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608471; cv=none; b=Jc2U4wEtQqz1KSKMSW4cXzOPULsg/XvHCTp4FbK9rgHmyY3nZqMF9Oo+c15coZobF6rTaaXh7a9CwkfNdKG1iQxkRdSOz9uFyaoLx88eJlhU6sOdfR+hfwRGctb5xl+/JgYU5xsP0oVtuENjpvwkx5bpWisYOxLZJJB7LNaUI4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608471; c=relaxed/simple;
	bh=mCzI50zNgR7gSqyF6Csn8HF/wLtuWv9Pp2yvauYwFR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkLxSRHtFgGIUieJdvRXxbH/pPI8FdIadPEQzRGtypqgpbcPhQsGT27ce9yrmPKN9STt82VnvNPTUE445mELQ2b6nlskSZeDiKMMuJ/SnyNJS6xPgwiEPNs/MC2VgOJk77IZaijbK7SD56uxsZ04IgCUINOBC6UhImNX+ZGCLEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9ZZq+s9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9ZZq+s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146D7C2BCB0;
	Tue, 12 May 2026 17:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608471;
	bh=mCzI50zNgR7gSqyF6Csn8HF/wLtuWv9Pp2yvauYwFR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9ZZq+s9Vj3c6Iqbnj1dGySpmsT3e+DKkgN0TlpkQ58uU49ekww0k0cLKgbJEHisk
	 +Lr5ZqF+cUcqphvf3RASJ6RVIOVIZtoonHV3uWXANsyjK+pkOJr6C9/zTySS4RQS6D
	 ZLzYsskhHRRsKYB12AB83qga1Miskd0w2265oyYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 093/270] mptcp: pm: ADD_ADDR rtx: skip inactive subflows
Date: Tue, 12 May 2026 19:38:14 +0200
Message-ID: <20260512173940.417964488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


