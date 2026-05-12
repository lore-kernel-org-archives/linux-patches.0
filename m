Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87DF370D71;
	Tue, 12 May 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609594; cv=none; b=U0YVorGp1QXUU+eoy/YpuQl7bQvJLYuqCUt9sAMRJDm/J5I8Zk4TLVdSDtczxWR2w/2kmtB66B56CiIjVmBAiRZAFOV1VHZja7B4bKUao9CJAes4uVQn8WaMrSpk1rzms9cA5UiybksRgw/qaFRZWWHsfJKIjK8zJD8oULr0JE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609594; c=relaxed/simple;
	bh=vt9NNC5qczxp4b5zU/p0EYOMqEfIq4+gaqlqE6v+miU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A61JwHqL8UR4KvItr+PNcswNJM1rXu0OWn2PhXLYPY6sWZfuGA0KF+EDg9wgWBIf6OtKb/aQMz1rr+BShs5yjIgR31UZJ5v2T1OIKwoohjp2XBK2wHvTT+e7Vd4q2E6vw+WD9z/fewH7sqfPDWwXdhErOWidYOuMl5toU6H3Cn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8sPE5yC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8sPE5yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C7C2BCB0;
	Tue, 12 May 2026 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609594;
	bh=vt9NNC5qczxp4b5zU/p0EYOMqEfIq4+gaqlqE6v+miU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8sPE5yCt/WlbJtONdtVIgnPuAJM19Y+gZLNmXVDUUlih820QDDYAj4X974W3wpAe
	 MQwNQeYiqKGSeQtjbPUvMP5mKvVtK1CAvkD0bm5HUHJVR0Ot/W6FFmioe8sNt6fz1V
	 jsdOOmplyf9iK0k5KK9GRALnFFDGBoe0StmKbzEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 257/307] mptcp: fix scheduling with atomic in timestamp sockopt
Date: Tue, 12 May 2026 19:40:52 +0200
Message-ID: <20260512173945.550886885@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,10 +159,10 @@ static int mptcp_setsockopt_sol_socket_t
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
@@ -235,10 +235,10 @@ static int mptcp_setsockopt_sol_socket_t
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow = lock_sock_fast(ssk);
 
+		lock_sock(ssk);
 		sock_set_timestamping(ssk, optname, timestamping);
-		unlock_sock_fast(ssk, slow);
+		release_sock(ssk);
 	}
 
 	release_sock(sk);


