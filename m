Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD541A01B5;
	Thu, 15 Aug 2024 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730579; cv=none; b=ha8OQ3ARngUKYtHpntBip585fIFL7IwH6VPSdQMo2x/T0kZKM6F1lBj6WbJSfaTVpORmNimVLKZMtGXkkxb5ihnbOUnjX87idFR5tBEOS84/2hjnN/yny/r/RuTxDnhIsKo/radtEOpemokV2M8IlIi+w6m5dtzoIkPjJQ3h1jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730579; c=relaxed/simple;
	bh=9MxRyBJHtS9XPl5RrvWyhKDzUU/IyAK91wdIybdWDdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUFUWtZ5AsdYFBFay+pBN/zAEI9QXEJzYtAMQJMvmdQ1YNN4eajZnA/SJ4RQ4SVVsYOu6PyHgc0tnk2+kw+3jGirjwWRSNQP+SNglwKwtX6cinBabQCRfSA+OksqBskn8c8hSpD8+wo9+DahAp7nkqcGFKI167hWR3S7I09vnhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTftuAfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTftuAfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B012EC32786;
	Thu, 15 Aug 2024 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730579;
	bh=9MxRyBJHtS9XPl5RrvWyhKDzUU/IyAK91wdIybdWDdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTftuAflSP7onjutwV+oB985P0sTiuYRJl3oQn+SrgSJSDH33bS2XsRzNFSpBF3K0
	 A3Hi5R4xXpVgBu5LA3xL6xn99LOXzD+ZKAVR8PYRG+76OzaKy7Ml19lI6mGjSP2CIT
	 jiIGuXbvaV8LvyfHUaEz6Fj50FJ8KfcAWU4jxK+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 452/484] mptcp: distinguish rcv vs sent backup flag in requests
Date: Thu, 15 Aug 2024 15:25:10 +0200
Message-ID: <20240815131958.922738940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit efd340bf3d7779a3a8ec954d8ec0fb8a10f24982 upstream.

When sending an MP_JOIN + SYN + ACK, it is possible to mark the subflow
as 'backup' by setting the flag with the same name. Before this patch,
the backup was set if the other peer set it in its MP_JOIN + SYN
request.

It is not correct: the backup flag should be set in the MPJ+SYN+ACK only
if the host asks for it, and not mirroring what was done by the other
peer. It is then required to have a dedicated bit for each direction,
similar to what is done in the subflow context.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in subflow.c, because the context has changed in commit
  4cf86ae84c71 ("mptcp: strict local address ID selection"), and in
  commit 967d3c27127e ("mptcp: fix data races on remote_id"), which are
  not in this version. These commits are unrelated to this
  modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |    2 +-
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -877,7 +877,7 @@ bool mptcp_synack_options(const struct r
 		return true;
 	} else if (subflow_req->mp_join) {
 		opts->suboptions = OPTION_MPTCP_MPJ_SYNACK;
-		opts->backup = subflow_req->backup;
+		opts->backup = subflow_req->request_bkup;
 		opts->join_id = subflow_req->local_id;
 		opts->thmac = subflow_req->thmac;
 		opts->nonce = subflow_req->local_nonce;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -370,6 +370,7 @@ struct mptcp_subflow_request_sock {
 	u16	mp_capable : 1,
 		mp_join : 1,
 		backup : 1,
+		request_bkup : 1,
 		csum_reqd : 1,
 		allow_join_id0 : 1;
 	u8	local_id;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1766,6 +1766,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
+		new_ctx->request_bkup = subflow_req->request_bkup;
 		new_ctx->local_id = subflow_req->local_id;
 		new_ctx->remote_id = subflow_req->remote_id;
 		new_ctx->token = subflow_req->token;


