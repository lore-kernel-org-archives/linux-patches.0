Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA4A524BD;
	Tue, 23 Jan 2024 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970220; cv=none; b=uJbrkKH8m1CbeXoTUiHtr0YvZq3vLtD6/40jyjCw2/csH+TZ0ezLg1BZUeJNxNoFuzmbPCkk4peGRB58EH9InUt2/5PEsyVq/xuqpZGGFPfFHM0iN8WXqy2zVkIN/XnCniz7T6g4G0aNweoP0Zk6zz9OPXGYnefv9Ke8vP5yDno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970220; c=relaxed/simple;
	bh=BvHLy71ZVHfVnRqjWtwfsMJt1wJ6wL/v46LPlqUzWeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrSY1RpkDDt3HRwX15Unuiodh3zfiVRujO6wqYN+BJlgOmZ7ACogPhHuBAcYaasgHJOdKg+Yc32XoU45nbCveu6Nv2bFI404aEt2hCN6ZZwyRcftz1oWwAOXj4zj/NkSTU0w1wNyIqDSwwKwHPpjaXQYFbm6cCozMRqMJFL9qJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCeRJtX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCeRJtX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8191EC433F1;
	Tue, 23 Jan 2024 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970220;
	bh=BvHLy71ZVHfVnRqjWtwfsMJt1wJ6wL/v46LPlqUzWeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCeRJtX7gOLTutwnHtMugYXMwlYHbYdnmv5GfXhw7Il0+wYjlocaPiET7muqby4CG
	 7ZEoJ0K4KDSIgohHcXg2PJJUNeppGmerLaFS/mLnpNgm2w0mRni6dfaBKl0eqto5J1
	 /5M2lx77Vu1uaPaWgpRIkOu0zqIHy9lNa3Bm89Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 617/641] mptcp: relax check on MPC passive fallback
Date: Mon, 22 Jan 2024 15:58:41 -0800
Message-ID: <20240122235837.554294848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit c0f5aec28edf98906d28f08daace6522adf9ee7a ]

While testing the blamed commit below, I was able to miss (!)
packetdrill failures in the fastopen test-cases.

On passive fastopen the child socket is created by incoming TCP MPC syn,
allow for both MPC_SYN and MPC_ACK header.

Fixes: 724b00c12957 ("mptcp: refine opt_mp_capable determination")
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 91c1cda4228f..7785cda48e6b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -783,7 +783,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 * options.
 		 */
 		mptcp_get_options(skb, &mp_opt);
-		if (!(mp_opt.suboptions & OPTION_MPTCP_MPC_ACK))
+		if (!(mp_opt.suboptions &
+		      (OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_ACK)))
 			fallback = true;
 
 	} else if (subflow_req->mp_join) {
-- 
2.43.0



