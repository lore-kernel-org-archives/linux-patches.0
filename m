Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F681C68C;
	Sun,  1 Sep 2024 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208362; cv=none; b=OhKeVnC1Z2XS2D41tj3i7W9Bk1T8g0+ysbv0fR39ZIbjAOM6OZrkI5DDFZe2LlAwo/6so9w2Gl7myaqA6ARS2WCiGxpfRvPyxlJxjtrwALZgfSbRVT1lWfCm4rdoltz63cyoh8D40E55sAkDxsoGSAmZ6HXI5iCUNShJtftugYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208362; c=relaxed/simple;
	bh=CIFp0RRf+hJURZa8QHugK5VTkejpj14L5NIpgTZ3P9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFoR2zx1Lztlly78Fe+Gl2ryKqIvzktNQKMF8BZ0+HUNdVrzvmVtztzXoqHdbOp8K8G0X9fj52OdW1xbYNKumDnTGoFAzJLCwj9aKhlV59g9ValrWI6okPv017qtkfOGDr6DZGMsYFDQgYByguneS9fwzZH/6HQnDSOLxOmKkKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCYAMn1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCYAMn1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285D7C4CEC3;
	Sun,  1 Sep 2024 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208362;
	bh=CIFp0RRf+hJURZa8QHugK5VTkejpj14L5NIpgTZ3P9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCYAMn1V3myVhFP2cl8Z42TlOwus5mRgyNoNKzRSWX8dHAcQmO1xkBfFGgU2swpKv
	 YWt+uVTqGcrtol3a1swvi8CJnlKQ0JSKs8gkcQ4cBpecce/WqdqxpIROmHC13e3AGU
	 3aarKGWqQ0OnB1ugf2xjnkAtAj7qeL7o32Ler9tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 028/149] mptcp: avoid duplicated SUB_CLOSED events
Date: Sun,  1 Sep 2024 18:15:39 +0200
Message-ID: <20240901160818.522418506@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d82809b6c5f2676b382f77a5cbeb1a5d91ed2235 upstream.

The initial subflow might have already been closed, but still in the
connection list. When the worker is instructed to close the subflows
that have been marked as closed, it might then try to close the initial
subflow again.

 A consequence of that is that the SUB_CLOSED event can be seen twice:

  # ip mptcp endpoint
  1.1.1.1 id 1 subflow dev eth0
  2.2.2.2 id 2 subflow dev eth1

  # ip mptcp monitor &
  [         CREATED] remid=0 locid=0 saddr4=1.1.1.1 daddr4=9.9.9.9
  [     ESTABLISHED] remid=0 locid=0 saddr4=1.1.1.1 daddr4=9.9.9.9
  [  SF_ESTABLISHED] remid=0 locid=2 saddr4=2.2.2.2 daddr4=9.9.9.9

  # ip mptcp endpoint delete id 1
  [       SF_CLOSED] remid=0 locid=0 saddr4=1.1.1.1 daddr4=9.9.9.9
  [       SF_CLOSED] remid=0 locid=0 saddr4=1.1.1.1 daddr4=9.9.9.9

The first one is coming from mptcp_pm_nl_rm_subflow_received(), and the
second one from __mptcp_close_subflow().

To avoid doing the post-closed processing twice, the subflow is now
marked as closed the first time.

Note that it is not enough to check if we are dealing with the first
subflow and check its sk_state: the subflow might have been reset or
closed before calling mptcp_close_ssk().

Fixes: b911c97c7dc7 ("mptcp: add netlink event support")
Cc: stable@vger.kernel.org
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++++
 net/mptcp/protocol.h |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2508,6 +2508,12 @@ out:
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow)
 {
+	/* The first subflow can already be closed and still in the list */
+	if (subflow->close_event_done)
+		return;
+
+	subflow->close_event_done = true;
+
 	if (sk->sk_state == TCP_ESTABLISHED)
 		mptcp_event(MPTCP_EVENT_SUB_CLOSED, mptcp_sk(sk), ssk, GFP_KERNEL);
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -519,7 +519,8 @@ struct mptcp_subflow_context {
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		__unused : 10;
+		close_event_done : 1,       /* has done the post-closed part */
+		__unused : 9;
 	bool	data_avail;
 	bool	scheduled;
 	u32	remote_nonce;


