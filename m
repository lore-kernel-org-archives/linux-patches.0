Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEBC33ADB0;
	Thu,  2 Jul 2026 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009777; cv=none; b=WxldxilGyHZ3puHYkduXHkTXpB3+DmzfapRPofQWdfloLTB362YRjfk4egpM87R3OdzrUN9nbXtXpE2ysv3jUQ9lucURiXRWan+r0pTW+Lai4gf2OnBfmjs/WyGu69qRHAw/pQQFMDZbTt5yhHLnbsa29XbLx0PQ5xaz9qxMRBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009777; c=relaxed/simple;
	bh=1rI9efT8mxislU6frqePWiJkL09I3oq0Nu6jBJUNdGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irCyZHGCeXH2Xqajql148dEH1aJOJfZ9q296f94ZmXgPqk5UNC3yqhDzujzr/a5zXclzLw+YOPQV3G4bfNPyVDOrfPPsPdBRxhdh07St9IPo1e/aBng/ZCoQA/0vCmwlXlVmpGeQuj9IHBIIdZZ7D5uX5q1JCYqE+xo0/6WvD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNYKpWMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNYKpWMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47521F00A3A;
	Thu,  2 Jul 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009775;
	bh=edEaZFU/2jAwFRNz7hdNq3pr5LEM183D19XWqLJ9Hzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNYKpWMv+lKZSdl+f7Mae3slU62HcjBUUC7hvlTAWhIc9Uyw0mqHVxhYceIxCbSbW
	 fdlgaOL/M6NG/v34k1C2yeREPgT9M7bkjb/dS1uuu3XXbVplH61BDzdIJsyZRzmx9z
	 aK2SSvlf1k/GUlH3D3PmLYmb6wSRB3ig5LOKnSCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 81/95] mptcp: fix missing wakeups in edge scenarios
Date: Thu,  2 Jul 2026 18:20:24 +0200
Message-ID: <20260702155110.912177437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9d8d28738f24b75616d6ca7a27cb4aed88520343 ]

The mptcp_recvmsg() can fill MPTCP socket receive queue via
mptcp_move_skbs(), but currently does not try to wakeup any listener,
because the same process is going to check the receive queue soon.

When multiple threads are reading from the same fd, the above can
cause stall. Add the missing wakeup.

Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-1-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2119,8 +2119,10 @@ static bool __mptcp_move_skbs(struct mpt
 		__mptcp_splice_receive_queue(sk);
 		mptcp_data_unlock(sk);
 	}
-	if (ret)
+	if (ret) {
 		mptcp_check_data_fin((struct sock *)msk);
+		sk->sk_data_ready(sk);
+	}
 	return !skb_queue_empty(&msk->receive_queue);
 }
 


