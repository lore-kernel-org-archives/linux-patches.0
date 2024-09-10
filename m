Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB91B1922FC;
	Tue, 10 Sep 2024 10:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963549; cv=none; b=mBcghlPi6hzgkE+x2Le0gG86tlHkmsyA6OFeKnpPRGlZYbvzYM/OhfvZD7eSH8k8vOdseWPcjAc5B/c6LKI7TIyEESEmxc3WAkPyv9R3SusIlsOJ5j2QP7yGE1z4btrKTbV2NnccivXw7MkmrIiDcgwnxGVUxUnb28KpbcxHUDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963549; c=relaxed/simple;
	bh=+yIkudfKEIkmZaqSuJ0oYNNetEeLG8l0ivhMzjv2h8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaYtSEVywy0cEuGSvxTBWFnZlyHZSHbjpxjPVkbscXGInoaWAQG4i4ejYzGfAanI8KrHF/xe2GIQ7MKZ95sa7RQUS98Bjo/4GrsIM5ytHksRPXAXwJNX6Wkg2adFUtCo1JfOp7hM25m6qaiqyt/q2WkaiTQwRbncsobBgp8wf9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCAH2MXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCAH2MXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E76C4CEC3;
	Tue, 10 Sep 2024 10:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963549;
	bh=+yIkudfKEIkmZaqSuJ0oYNNetEeLG8l0ivhMzjv2h8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCAH2MXogdYcYC48pUygUnptqEm7rZstcOM8SJXc+LwbKgus+UcloR6q4lRUKhTZm
	 IbZLeDHAnP+9PPrzxSgQgUeTa+tcyvbHncV+y7YDIsfnNlqUpCbTlCB3CXL+S77YDn
	 sLx4SA6o80MJEV2CMiJaK+/VMNL251GtK+QP/ik0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 096/214] mptcp: avoid duplicated SUB_CLOSED events
Date: Tue, 10 Sep 2024 11:31:58 +0200
Message-ID: <20240910092602.711737064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
[ Conflict in protocol.h due to commit f1f26512a9bf ("mptcp: use plain
  bool instead of custom binary enum"), commit dfc8d0603033 ("mptcp:
  implement delayed seq generation for passive fastopen") and more that
  are not in this version, because they modify the context and the size
  of __unused. The conflict is easy to resolve, by not only adding the
  new field (close_event_done), and __unused. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++++
 net/mptcp/protocol.h |    4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2337,6 +2337,12 @@ static void __mptcp_close_ssk(struct soc
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
 	__mptcp_close_ssk(sk, ssk, subflow);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -441,7 +441,9 @@ struct mptcp_subflow_context {
 		can_ack : 1,        /* only after processing the remote a key */
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
-		valid_csum_seen : 1;        /* at least one csum validated */
+		valid_csum_seen : 1,        /* at least one csum validated */
+		close_event_done : 1,       /* has done the post-closed part */
+		__unused : 11;
 	enum mptcp_data_avail data_avail;
 	u32	remote_nonce;
 	u64	thmac;


