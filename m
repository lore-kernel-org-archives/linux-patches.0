Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09B91AC451;
	Thu, 15 Aug 2024 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732924; cv=none; b=Qet/vB/sq+vz6TWMMKPasJQ9E4M93AqKbnVIuK3fottftVX+vXvBRpGYhRhLC8gdcoPXW10hySUo91OAeSmKyin/wUzB1sSBXPvzIJtBJIRgQeFOXBthufqKg8PlE0pw+qtC0XNy4ab0OnU3Xop5ECtmxsS9Us9GaykxHTPoS9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732924; c=relaxed/simple;
	bh=fGbj16/OHpTdMBMmlFrrXFd6M+hERiC5CMJHk0y9LTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItKmap5OXmtkkfHnIK88VFMLODeSSt33l9tbiSFs0o15rWNs2mA/k33MHG3LGQBzBSUwHxNaSNN3+O92iwSEELocFqcv5Qcj1FuUCAMpqeYxzPSHYQdR/VziVMa29b/5hD3Yx7v53WsrvAuycPcF9nR0Y4zKqO3cVcnL8qV2Dvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzjqZ9aL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzjqZ9aL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2117AC4AF0D;
	Thu, 15 Aug 2024 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732924;
	bh=fGbj16/OHpTdMBMmlFrrXFd6M+hERiC5CMJHk0y9LTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzjqZ9aLEssCj7VVSYX3ZeYrN9J4eTaIVl8Zjs+QyAJNFcT9x042kdWB+lpEwH5C5
	 whFeSaf6EZWkyE3L8x0EJ5cKZK8ZrzLMR6xhZrS9ImGu5bUdGGot9Ne3ZVVxdlHhuI
	 KWIiYn7H8RnFSN6Ihu0w5i/ZMZpx+Xrni3k1sS/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 329/352] mptcp: distinguish rcv vs sent backup flag in requests
Date: Thu, 15 Aug 2024 15:26:35 +0200
Message-ID: <20240815131932.170696829@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
  modification.
  Same in protocol.h, with commit bab6b88e0560 ("mptcp: add
  allow_join_id0 in mptcp_out_options"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |    2 +-
 net/mptcp/protocol.h |    3 ++-
 net/mptcp/subflow.c  |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -708,7 +708,7 @@ bool mptcp_synack_options(const struct r
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
@@ -261,7 +261,8 @@ struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u16	mp_capable : 1,
 		mp_join : 1,
-		backup : 1;
+		backup : 1,
+		request_bkup : 1;
 	u8	local_id;
 	u8	remote_id;
 	u64	local_key;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1395,6 +1395,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
+		new_ctx->request_bkup = subflow_req->request_bkup;
 		new_ctx->local_id = subflow_req->local_id;
 		new_ctx->remote_id = subflow_req->remote_id;
 		new_ctx->token = subflow_req->token;


