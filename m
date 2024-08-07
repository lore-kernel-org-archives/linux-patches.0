Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DD233CD2;
	Wed,  7 Aug 2024 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043708; cv=none; b=OxdQjuoijwCjImcC0hcZ4AkgHPi5glnnNvJHWjy04o326oDwirHqm9Lrr09+7uc8YcHW/1ZvPYG5B/bB4GI32zBXNu6kJLES1CJ7E5QVrFAbpHNNrtLwaCKYLC5ODdN6GZKWryCuNQzHJptIdGgqEJmS2kGGCyGQF8+y6sGP1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043708; c=relaxed/simple;
	bh=Q6799UIm14zGq/hzWryhyiReP1MEUdULRh5O2mPsdxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFz/xDMNDKbocWdlNQyHVftf6hZ/UzN2lfML2Z7C30+pKm7ZA1xzGvwDIo3R9na1nCFOyEq9g/jqFogUwyGHF3iqzURtg5ndSloWLFc6/Tmt7nY3hADu43s25Lu4NHhwMRkofmZjpwUBOwk6sC82/y892hRtUwdFV7zL2IH5Bgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIIxS5Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIIxS5Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240B8C32781;
	Wed,  7 Aug 2024 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043708;
	bh=Q6799UIm14zGq/hzWryhyiReP1MEUdULRh5O2mPsdxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIIxS5YekHLcTqvVrHZqc9C8nzGFP2/i0kUlW/bylBwj3PeXxqLFgn33NB7fjRLrN
	 RsZd8H9MTg5Y9fuoLJ1XK3QBHYw+VEkqQ4qyqKHF4qUJQPLv3svIqImOUhhTzXa73h
	 JyQlVmxTbIZtQLkHcluImCQ+WYOlQRLrc8Vws1Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 71/86] mptcp: sched: check both directions for backup
Date: Wed,  7 Aug 2024 17:00:50 +0200
Message-ID: <20240807150041.609257479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
@@ -1491,13 +1491,15 @@ static struct sock *mptcp_subflow_get_se
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
 		pace = subflow->avg_pacing_rate;
 		if (unlikely(!pace)) {
 			/* init pacing rate from socket */
@@ -1508,9 +1510,9 @@ static struct sock *mptcp_subflow_get_se
 		}
 
 		linger_time = div_u64((u64)READ_ONCE(ssk->sk_wmem_queued) << 32, pace);
-		if (linger_time < send_info[subflow->backup].linger_time) {
-			send_info[subflow->backup].ssk = ssk;
-			send_info[subflow->backup].linger_time = linger_time;
+		if (linger_time < send_info[backup].linger_time) {
+			send_info[backup].ssk = ssk;
+			send_info[backup].linger_time = linger_time;
 		}
 	}
 	__mptcp_set_timeout(sk, tout);


