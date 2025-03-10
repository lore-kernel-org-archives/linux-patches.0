Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112A522ACDC;
	Mon, 10 Mar 2025 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629548; cv=none; b=ISYEuMyW/Hx6zMkS14/ziMZB1nIa1ygMJNYGnEgJIlKEqqDRCjdDMjJDZKBWt3fac16UvG5YAZNnRtzt8Q6Q3+kEvkISnq+8cHaLz7IKplQQPuLZ+StTWa8aDSchW2MHRqOlYrTUtCUs/1rmSkHFyZnyUMEkTMfmzLPvqfiuyr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629548; c=relaxed/simple;
	bh=c3YWLBaqSK4gr5Jr8PPR3ARtXe2Jin8ybETAKqp+ycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoqQ4CGhg50CoQ//EVAyW9Rvnw30sFkfIXruy/bBPK9MCd4ToMvDMiF7XlPQZoPaOZtJYbIxkbyJoNnsqnX3iD0BfPlwEr9Xt87SgAyKAeWvuQeIbCRqtJ4vt9LDZKxpG+rjxGLx5XO0BvOFrXeSzWnOyL4Y5EPmjkCxqieVOC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0E9hp1VU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0E9hp1VU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B854C4CEE5;
	Mon, 10 Mar 2025 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629547;
	bh=c3YWLBaqSK4gr5Jr8PPR3ARtXe2Jin8ybETAKqp+ycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0E9hp1VUuo6/WNOvJEU9uTau6nRwci/wCE74j9b3YD704W26dGpkDIc1mKEIvpmRs
	 /fSMoPVR9yX5tGmkcqB1VEZP8Bgdnnbax0Y4Ew3MEwEumfX45J5IZ5AY/2YU9taGPK
	 4WEu4nCyaJMFEX09e1UMigRlH1oRIt6hczIh7MeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 333/620] mptcp: prevent excessive coalescing on receive
Date: Mon, 10 Mar 2025 18:02:59 +0100
Message-ID: <20250310170558.753323591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 56b824eb49d6258aa0bad09a406ceac3f643cdae upstream.

Currently the skb size after coalescing is only limited by the skb
layout (the skb must not carry frag_list). A single coalesced skb
covering several MSS can potentially fill completely the receive
buffer. In such a case, the snd win will zero until the receive buffer
will be empty again, affecting tput badly.

Fixes: 8268ed4c9d19 ("mptcp: introduce and use mptcp_try_coalesce()")
Cc: stable@vger.kernel.org # please delay 2 weeks after 6.13-final release
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241230-net-mptcp-rbuf-fixes-v1-3-8608af434ceb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -133,6 +133,7 @@ static bool mptcp_try_coalesce(struct so
 	int delta;
 
 	if (MPTCP_SKB_CB(from)->offset ||
+	    ((to->len + from->len) > (sk->sk_rcvbuf >> 3)) ||
 	    !skb_try_coalesce(to, from, &fragstolen, &delta))
 		return false;
 


