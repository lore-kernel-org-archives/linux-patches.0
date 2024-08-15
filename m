Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB61A01B5;
	Thu, 15 Aug 2024 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730576; cv=none; b=MHr4kmU5cpuckGELuBkuwf3W+z2HEe57E496HotFPmMjjm/JzhqX+yUGGIA3HnBkHIUcfbECu5HVUzxLruiDVI5VlObsHSwIZqVuhhQ8lraRGhSAokYSR631V2AVnfytkXa5vMZL3LOnMZSnHYwo22Get+0Td83xJ63axcOsHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730576; c=relaxed/simple;
	bh=/iv4cy2wfcUXKcWnFXj5juwCMUo/8yBFSvDyBCt7fg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEd0LMljRWfPMfO4WYGJaBBFpSs2IH81cyYd6mWI29ATk2gW5EPrAex9ldyXYb89zRXyjCOhqyGLbmjt49/bENIxhWeUe34D5/tYRwlSnQJxwCof5EL9YOQYkFN0tGROO4X45Itf9TrIuinfiWtF0v6DyRywBJAxfcPbD+LnHYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvoZMs37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvoZMs37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F1C4AF12;
	Thu, 15 Aug 2024 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730576;
	bh=/iv4cy2wfcUXKcWnFXj5juwCMUo/8yBFSvDyBCt7fg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvoZMs37i0iqKqkhXk2VPLMHX+ye6TyY2kEjoc6CC5UiGL35hO1lsERz1WB/T7Y4M
	 FlI55tppvKI4lUPectST1ZHTH9p1A9/g8VmXgV5IuW53gBMx0rJbUmnpGLlX+xFW6H
	 uiHzf0SLTogr2YQfWddaVYZRdM0myMBumjj4rQmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 451/484] mptcp: sched: check both directions for backup
Date: Thu, 15 Aug 2024 15:25:09 +0200
Message-ID: <20240815131958.883670694@linuxfoundation.org>
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

commit b6a66e521a2032f7fcba2af5a9bcbaeaa19b7ca3 upstream.

The 'mptcp_subflow_context' structure has two items related to the
backup flags:

 - 'backup': the subflow has been marked as backup by the other peer

 - 'request_bkup': the backup flag has been set by the host

Before this patch, the scheduler was only looking at the 'backup' flag.
That can make sense in some cases, but it looks like that's not what we
wanted for the general use, because either the path-manager was setting
both of them when sending an MP_PRIO, or the receiver was duplicating
the 'backup' flag in the subflow request.

Note that the use of these two flags in the path-manager are going to be
fixed in the next commits, but this change here is needed not to modify
the behaviour.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in protocol.c, because the context has changed in commit
  3ce0852c86b9 ("mptcp: enforce HoL-blocking estimation"), which is not
  in this version. This commit is unrelated to this modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/mptcp.h |    2 +-
 net/mptcp/protocol.c         |   10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -34,7 +34,7 @@ TRACE_EVENT(mptcp_subflow_get_send,
 		struct sock *ssk;
 
 		__entry->active = mptcp_subflow_active(subflow);
-		__entry->backup = subflow->backup;
+		__entry->backup = subflow->backup || subflow->request_bkup;
 
 		if (subflow->tcp_sock && sk_fullsock(subflow->tcp_sock))
 			__entry->free = sk_stream_memory_free(subflow->tcp_sock);
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1514,13 +1514,15 @@ static struct sock *mptcp_subflow_get_se
 		send_info[i].ratio = -1;
 	}
 	mptcp_for_each_subflow(msk, subflow) {
+		bool backup = subflow->backup || subflow->request_bkup;
+
 		trace_mptcp_subflow_get_send(subflow);
 		ssk =  mptcp_subflow_tcp_sock(subflow);
 		if (!mptcp_subflow_active(subflow))
 			continue;
 
 		tout = max(tout, mptcp_timeout_from_subflow(subflow));
-		nr_active += !subflow->backup;
+		nr_active += !backup;
 		if (!sk_stream_memory_free(subflow->tcp_sock) || !tcp_sk(ssk)->snd_wnd)
 			continue;
 
@@ -1530,9 +1532,9 @@ static struct sock *mptcp_subflow_get_se
 
 		ratio = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32,
 				pace);
-		if (ratio < send_info[subflow->backup].ratio) {
-			send_info[subflow->backup].ssk = ssk;
-			send_info[subflow->backup].ratio = ratio;
+		if (ratio < send_info[backup].ratio) {
+			send_info[backup].ssk = ssk;
+			send_info[backup].ratio = ratio;
 		}
 	}
 	__mptcp_set_timeout(sk, tout);


