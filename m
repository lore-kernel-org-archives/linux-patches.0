Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2148381A2;
	Fri, 24 Nov 2023 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvm6T59s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0A8C433C9;
	Fri, 24 Nov 2023 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851426;
	bh=/1gOTYTKjXOy3q6FBn62j96oN0QuwSfkMjqsBzBqhxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvm6T59sPvqE+A7tbv478D9bJcl+WSqbzSKjcrcmZYO77G+Z1N2StvbWSSkuaq9TF
	 Ct9o0stO9jhYlte30bmUqzKb6FXb+1JoNIgHNCKX/sgtjEga2sc8Gmp1XwVlyv03BN
	 Ap/4SgmsMkBeoYLS1uQ9jl3VE13ShSn+eM6NwNVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 444/491] mptcp: fix setsockopt(IP_TOS) subflow locking
Date: Fri, 24 Nov 2023 17:51:20 +0000
Message-ID: <20231124172037.950297455@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
 


