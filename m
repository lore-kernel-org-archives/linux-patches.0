Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D081AB1;
	Wed,  7 Aug 2024 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043519; cv=none; b=Nzd4mEUbqDTwsCblpyVlIRM5B+bVrWhQNUJvt6BOdRXVHO3g91aRG9rfMdjb0P8OCYdOQ6wI6ZFkNY15YrpXRcKpiFz3fam+oRWaxpr9QzqSDo9pCZG1rv98HhAD1EwBA6QZESUn8VQlqdfvdPzAO92IUzL8aXXERyL7u9lwhEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043519; c=relaxed/simple;
	bh=ds4MJd1k03xhlCLAaRDQTIIk+166bIdly2xcdor2QsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrvQ5iVeolo2Az6Daml3NlS5URTJubmUkTiZXEkBJbVkVzAreSTww9Z8O6E0K/jPBf2b1Um5DMxm1k0gUaFgJDAwjbtbQUkftZAhvMzKhuLYsiDCJ7sl+Rcndiq9qWu2LY+xKNbDWYMkb6CcLnHL2EWq3aEc0KpsT+DY//ksNto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXKrXMYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXKrXMYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE314C32781;
	Wed,  7 Aug 2024 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043519;
	bh=ds4MJd1k03xhlCLAaRDQTIIk+166bIdly2xcdor2QsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXKrXMYgDL1/xdEW6ZM9rI5zZeVibIsTcLMrLQLYiv9EdneD2A66cMbtDuR171Llw
	 FjdPrWTbQDtNV1qfQZFUQbLEy8pV74+iy0KBSuiObxg0gdX8cayt+VMbz8gLPVDiBs
	 Lp5etA+sOorew+LXVkkcuJdpW2bkZADQ6O1EWB0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 112/121] mptcp: distinguish rcv vs sent backup flag in requests
Date: Wed,  7 Aug 2024 17:00:44 +0200
Message-ID: <20240807150023.068922624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |    2 +-
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -909,7 +909,7 @@ bool mptcp_synack_options(const struct r
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
@@ -419,6 +419,7 @@ struct mptcp_subflow_request_sock {
 	u16	mp_capable : 1,
 		mp_join : 1,
 		backup : 1,
+		request_bkup : 1,
 		csum_reqd : 1,
 		allow_join_id0 : 1;
 	u8	local_id;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1976,6 +1976,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->fully_established = 1;
 		new_ctx->remote_key_valid = 1;
 		new_ctx->backup = subflow_req->backup;
+		new_ctx->request_bkup = subflow_req->request_bkup;
 		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;


