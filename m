Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E705D261B9E;
	Sat, 30 May 2026 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163745; cv=none; b=LB4W1O2edOFc8HRh7zZnqHc/D8QswT3mUTajrJR3z/JfJE8ad00daLdBZ61l/FfTC+PUzFpQlcUxAH1+44C2r5ILkHqMJPWmBE5VcAFYmKk9Z0ZPbprkmJtCqOnScQy9J2qHoC/tWKoJit/7Y/KD9Qx64APoTm7AezpkiaJvKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163745; c=relaxed/simple;
	bh=lw7OgSjGkLn5cJpQxItNvF6h5i4QFLIaMCuPRH3f1MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmCsEVGJmFNwGIVNk4ku1oG+6azxEkPzQDUTMvr+Ni6cYQugHFQmCbNhMR/h4scSmTBRk2FX1pQ6HdFtCnJFyLSqsXAm+ms9IZPxxnbiqAxfQgUqqtyvSABGEVkI5LNJmTI9cyaouxQBDFhki9K7JX/avSqohOZ63Tv6Ef+InWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcLD85+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcLD85+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373CD1F00893;
	Sat, 30 May 2026 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163744;
	bh=iCp96bl8dOupVYplwfol+goBLiUTcAIGOxFJ/ZgcL/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcLD85+tDVA+mC41/OZ9QGn+L5EEHDANOPWD/ueE31lOV05qcXSikC/RDqLVGBzoj
	 MvOdecE4tcG4VoLsu7SHi6JBRBuAes/4mUkdR0lYepKsAwVLd0o0x/1FtqbwevFbXI
	 JRUzR5HeYTSBHxdbJap/F/+x82Ou4TMu5QcTyE+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 349/776] mptcp: fix scheduling with atomic in timestamp sockopt
Date: Sat, 30 May 2026 18:01:03 +0200
Message-ID: <20260530160249.597848819@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -155,10 +155,10 @@ static int mptcp_setsockopt_sol_socket_t
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
@@ -231,10 +231,10 @@ static int mptcp_setsockopt_sol_socket_t
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow = lock_sock_fast(ssk);
 
+		lock_sock(ssk);
 		sock_set_timestamping(ssk, optname, timestamping);
-		unlock_sock_fast(ssk, slow);
+		release_sock(ssk);
 	}
 
 	release_sock(sk);


