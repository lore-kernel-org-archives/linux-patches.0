Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1662E2690D5;
	Sat, 30 May 2026 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160681; cv=none; b=gAGvJ6b2sAd/uUgJB94mYnTlhGWYbTYQonHqJgl7UFVNmGnwGlJF8gJBbqwmoGmlbbScIj+CHLimxDnQQJSPJyOhR0z2bU3+Avdp6iXPZLQGIQRRxG6YPOXq75zQvrcsOEDaqxnpsjkqLckkO2rSRRj+8FZ8WhpTBO2zRTdB4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160681; c=relaxed/simple;
	bh=Dflnvh7IKZOh2wdeDJcgfmZwWBdUw5gO6df08lg0wKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtFTFHIaKbrwdnrsbhWLmDw+X3TItHp3jVXoYJIePk9yoK0ve+aZPsHCF934K5jn1BqtBnl5y+rGsslGOpxPBOYC2M0wxiqjfrOPkeFsnfwM2QaiBGeCxCIzlIBKeQJXUDXcg265digO936Wqf87WodFW2fHpxJzAMAaleav+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RoQnNma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RoQnNma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FE1F00893;
	Sat, 30 May 2026 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160680;
	bh=E107YxtzCEbfDAZIj/bRvi1NrpZhpO4/BTkbP/b2TUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RoQnNmaB18w6sCZiPKaYdIDlfkq7w/POZEOVeUwvXrLlc5Gith56aax/eOsNzjow
	 NhOvq8RPKqSdN6OZLW9OMk7ZHw50rtAVeVLw55BWKvMvCs6LGH2V9nIEhe/Pe72Kpe
	 l94z3/WEOPnu82JYZnVZ34+2IbNDqxXsQMojBdCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 374/969] mptcp: fix scheduling with atomic in timestamp sockopt
Date: Sat, 30 May 2026 17:58:18 +0200
Message-ID: <20260530160310.637592843@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Gang Yan <yangang@kylinos.cn>

commit b5c52908d52c6c8eb8933264aa6087a0600fd892 upstream.

Using lock_sock_fast() (atomic context) around sock_set_timestamp()
and sock_set_timestamping() is unsafe, as both helpers can sleep.

Replace lock_sock_fast() with sleepable lock_sock()/release_sock()
to avoid scheduling while atomic panic.

Fixes: 9061f24bf82e ("mptcp: sockopt: propagate timestamp request to subflows")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260420093343.16443-1-gang.yan@linux.dev
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260427-net-mptcp-misc-fixes-7-1-rc2-v1-2-7432b7f279fa@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -157,10 +157,10 @@ static int mptcp_setsockopt_sol_socket_t
 	lock_sock(sk);
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow = lock_sock_fast(ssk);
 
+		lock_sock(ssk);
 		sock_set_timestamp(ssk, optname, !!val);
-		unlock_sock_fast(ssk, slow);
+		release_sock(ssk);
 	}
 
 	release_sock(sk);
@@ -233,10 +233,10 @@ static int mptcp_setsockopt_sol_socket_t
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow = lock_sock_fast(ssk);
 
+		lock_sock(ssk);
 		sock_set_timestamping(ssk, optname, timestamping);
-		unlock_sock_fast(ssk, slow);
+		release_sock(ssk);
 	}
 
 	release_sock(sk);


