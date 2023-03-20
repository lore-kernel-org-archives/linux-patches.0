Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87B1C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C69C433D2;
	Mon, 20 Mar 2023 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326145;
	bh=+uiV5kfF9esV5EuJ4u3NmFuikr8zHD6XWepcUrvqLRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP219Ehr8gZ5oWUIXyZOfzGh3UpT2bL+7+XY3t8EhDJRupxUX0ZVNaUYY3BJAIUKc
	 5PdhctzmNrMtAXJWkIlACI6u2EpVHtSKRg1g02Omd30imAkDGva6tllEqXwWSQp7Bk
	 XcweBEmQLbw/Y4TjzVlIYYa3SVdiMlsZRifOSqS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 178/211] mptcp: avoid setting TCP_CLOSE state twice
Date: Mon, 20 Mar 2023 15:55:13 +0100
Message-Id: <20230320145520.930128589@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 3ba14528684f528566fb7d956bfbfb958b591d86 upstream.

tcp_set_state() is called from tcp_done() already.

There is then no need to first set the state to TCP_CLOSE, then call
tcp_done().

Fixes: d582484726c4 ("mptcp: fix fallback for MP_JOIN subflows")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/362
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -405,7 +405,6 @@ void mptcp_subflow_reset(struct sock *ss
 	/* must hold: tcp_done() could drop last reference on parent */
 	sock_hold(sk);
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&


