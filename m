Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7CE34F259;
	Wed,  3 Dec 2025 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778805; cv=none; b=MsKbLOOgL4IqOHS5iNwnGgHLPgkk/dDWJoOj50lMlncRTnbCAJY46He2sisfMMtRShLnkwSgVpnODGWFmXJUh7IL3tWw3tjU19IJfy5P5ZYVmOc8CXzXisuLOFeDIdvGXQOjzvNWE81QGaen5N5zraJ1AUwyxeMqbz2zT4BSvlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778805; c=relaxed/simple;
	bh=oPlZVZtdwksU4mf9cI0tA5eolu80f5Wllp8w6vFgDZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMlLzRz31jKB1M/8B3BMkS6lVMoKizWCL6QsK6zgxxuNLPH9vzGFkcDV8PhOcf4eHXDfJRbNnusKXKv9Br3IX3SRe+O0I6slKQDN+UsQ3222QsUcMn0KBqL3bFB0UQe0c2xEt25KCrCXf5yWc64E/4/nJGACRWTlyb8GwKObH14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gv2FBlca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gv2FBlca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D0C4CEF5;
	Wed,  3 Dec 2025 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778804;
	bh=oPlZVZtdwksU4mf9cI0tA5eolu80f5Wllp8w6vFgDZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv2FBlcaP/98d5GbbG0GAReZf4b6DQPUvYVrFKgDybJeoLUVxUOXoaOXXK6DRe6oU
	 4SzfibEtB/j10OaHFtXWovC2jgiUQPOVfT/X2qe8jlbiJrPpdpU4OyLJzMaKBdmxNZ
	 IymIBXUIzJCLi7AuLGrYNpD6hO6Elz+Gx60dLYWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/568] mptcp: drop bogus optimization in __mptcp_check_push()
Date: Wed,  3 Dec 2025 16:21:05 +0100
Message-ID: <20251203152443.010161765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 27b0e701d3872ba59c5b579a9e8a02ea49ad3d3b ]

Accessing the transmit queue without owning the msk socket lock is
inherently racy, hence __mptcp_check_push() could actually quit early
even when there is pending data.

That in turn could cause unexpected tx lock and timeout.

Dropping the early check avoids the race, implicitly relaying on later
tests under the relevant lock. With such change, all the other
mptcp_send_head() call sites are now under the msk socket lock and we
can additionally drop the now unneeded annotation on the transmit head
pointer accesses.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-1-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ split upstream __subflow_push_pending change across __mptcp_push_pending and __mptcp_subflow_push_pending ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   13 +++++--------
 net/mptcp/protocol.h |    2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1101,7 +1101,7 @@ static void __mptcp_clean_una(struct soc
 			if (WARN_ON_ONCE(!msk->recovery))
 				break;
 
-			WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+			msk->first_pending = mptcp_send_next(sk);
 		}
 
 		dfrag_clear(sk, dfrag);
@@ -1691,7 +1691,7 @@ void __mptcp_push_pending(struct sock *s
 
 			mptcp_update_post_push(msk, dfrag, ret);
 		}
-		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+		msk->first_pending = mptcp_send_next(sk);
 	}
 
 	/* at this point we held the socket lock for the last subflow we used */
@@ -1747,7 +1747,7 @@ static void __mptcp_subflow_push_pending
 
 			mptcp_update_post_push(msk, dfrag, ret);
 		}
-		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+		msk->first_pending = mptcp_send_next(sk);
 	}
 
 out:
@@ -1917,7 +1917,7 @@ static int mptcp_sendmsg(struct sock *sk
 			get_page(dfrag->page);
 			list_add_tail(&dfrag->list, &msk->rtx_queue);
 			if (!msk->first_pending)
-				WRITE_ONCE(msk->first_pending, dfrag);
+				msk->first_pending = dfrag;
 		}
 		pr_debug("msk=%p dfrag at seq=%llu len=%u sent=%u new=%d\n", msk,
 			 dfrag->data_seq, dfrag->data_len, dfrag->already_sent,
@@ -2915,7 +2915,7 @@ static void __mptcp_clear_xmit(struct so
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
 
-	WRITE_ONCE(msk->first_pending, NULL);
+	msk->first_pending = NULL;
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
 }
@@ -3496,9 +3496,6 @@ void __mptcp_data_acked(struct sock *sk)
 
 void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 {
-	if (!mptcp_send_head(sk))
-		return;
-
 	if (!sock_owned_by_user(sk))
 		__mptcp_subflow_push_pending(sk, ssk, false);
 	else
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -360,7 +360,7 @@ static inline struct mptcp_data_frag *mp
 {
 	const struct mptcp_sock *msk = mptcp_sk(sk);
 
-	return READ_ONCE(msk->first_pending);
+	return msk->first_pending;
 }
 
 static inline struct mptcp_data_frag *mptcp_send_next(struct sock *sk)


