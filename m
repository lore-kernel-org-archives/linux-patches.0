Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A7D39FD9;
	Fri, 24 Nov 2023 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5l+T4am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C190C433C8;
	Fri, 24 Nov 2023 18:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850189;
	bh=MxVcz+Ycf3gbCS0p1w1cj54+312GG1Iwd0xV9TB0TIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5l+T4amMQSPlZVRZkwP0X0mPD/0Es+y2J6PykZhVk34D4aQRxPBbHgHHOXg3ofuR
	 TgmpsRFGMNyuh+2/wtb2ROSBfX+PyESdGuxIHR5cno+omwAblrcGzYuTxgKJk8g31N
	 OD8jaPBT1coXvtjHySFSFAbfWgyAS56j3TrR3NPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 480/530] mptcp: fix setsockopt(IP_TOS) subflow locking
Date: Fri, 24 Nov 2023 17:50:46 +0000
Message-ID: <20231124172042.688327828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 7679d34f97b7a09fd565f5729f79fd61b7c55329 upstream.

The MPTCP implementation of the IP_TOS socket option uses the lockless
variant of the TOS manipulation helper and does not hold such lock at
the helper invocation time.

Add the required locking.

Fixes: ffcacff87cd6 ("mptcp: Support for IP_TOS for MPTCP setsockopt()")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/457
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20231114-upstream-net-20231113-mptcp-misc-fixes-6-7-rc2-v1-4-7b9cd6a7b7f4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -737,8 +737,11 @@ static int mptcp_setsockopt_v4_set_tos(s
 	val = inet_sk(sk)->tos;
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow;
 
+		slow = lock_sock_fast(ssk);
 		__ip_sock_set_tos(ssk, val);
+		unlock_sock_fast(ssk, slow);
 	}
 	release_sock(sk);
 


