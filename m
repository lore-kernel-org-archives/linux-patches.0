Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501A32522B4;
	Tue, 29 Apr 2025 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947027; cv=none; b=WBD15LykvmxdDbEToqkFbCwiO+7YzZvGcLsyQGgeImFnsSWqZ8aRhHykGeNCwAh6pVc9Q4vTn+Ae85KcsBUYmV1cEjKzfsL9x4rJfWYCmAJTwdiTR/rCdBilrUujlkpPKhrRX66JfJJLqzGbJoWCSvD6MEk2q8urPB9XJc35Y5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947027; c=relaxed/simple;
	bh=sTGQvWMc92xT7qbpYi+wt6myz0KW/6alSVPP8VaNJi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4yaLCUsMMSJWIeK5BxlqHIBAojDVM/ij1PtsqUtkT/5j6JVbj/iB5UOG0cN8OLvWsvjDJNUJtjXI7wsEUOnLvMHF3R59QPzkj41sDLmW/yiIlJUZtzPpwpbpE8ARPsEG2yZq53roCbVbN2JZOzNkC10H/cXpJ4ryvzKTZAuVAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T+DUUqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T+DUUqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9A0C4CEE9;
	Tue, 29 Apr 2025 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947027;
	bh=sTGQvWMc92xT7qbpYi+wt6myz0KW/6alSVPP8VaNJi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T+DUUqiWuHpMk5x5OUXL2wlrvql+F+9RwTI9yydimnV/ZYElEE5tekoTHKv6fpJQ
	 nZiVqcNb8PADfio61PZ5zR29qrsj2EwJgpnq6KrdO/CORnU0aIcFpr63klf20dHDtT
	 siU893PvBTyWWtv1SaaM30EIaIQ0mvxQPyeSHx9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 148/286] mptcp: only inc MPJoinAckHMacFailure for HMAC failures
Date: Tue, 29 Apr 2025 18:40:52 +0200
Message-ID: <20250429161113.973531283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 21c02e8272bc95ba0dd44943665c669029b42760 upstream.

Recently, during a debugging session using local MPTCP connections, I
noticed MPJoinAckHMacFailure was not zero on the server side. The
counter was in fact incremented when the PM rejected new subflows,
because the 'subflow' limit was reached.

The fix is easy, simply dissociating the two cases: only the HMAC
validation check should increase MPTCP_MIB_JOINACKMAC counter.

Fixes: 4cf8b7e48a09 ("subflow: introduce and use mptcp_can_accept_new_subflow()")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250407-net-mptcp-hmac-failure-mib-v1-1-3c9ecd0a3a50@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ No conflicts, but subflow_add_reset_reason() is not needed is this
 version: the related feature is not supported in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -631,12 +631,14 @@ create_child:
 			if (!owner)
 				goto dispose_child;
 
-			if (!subflow_hmac_valid(req, &mp_opt) ||
-			    !mptcp_can_accept_new_subflow(subflow_req->msk)) {
+			if (!subflow_hmac_valid(req, &mp_opt)) {
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 				goto dispose_child;
 			}
 
+			if (!mptcp_can_accept_new_subflow(owner))
+				goto dispose_child;
+
 			/* move the msk reference ownership to the subflow */
 			subflow_req->msk = NULL;
 			ctx->conn = (struct sock *)owner;


