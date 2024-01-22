Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13781419B4;
	Tue, 23 Jan 2024 01:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972056; cv=none; b=Lzb0YAptZMd4JiKCAfQCZzIqnyzBEs0lthKKiACPdI38py2fIHoFV7JHXIkYhhFfpuJe77r30BLWOILL5et9RjTc9nwZ9kMJdIxTLikRdLw5+Uysi0ocWJ7OiNvoxAGhs5jru8ehNMnnx/57r9sjlvg6qeUMJTJgQu4qo4xTlJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972056; c=relaxed/simple;
	bh=e75AmnpnwUH66IQcvlY2EXA0cJeQYxTLvNMldM5p5DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZZrwTa8CW1Tm60Z4uEnLYrc7IJ3iNC4SYhbqmHAgV6YabXmpv5zx0nSb4bLQpaaBOprDWE+knZ8KjCJwYmBRywIJ4jt/+8gfVuupg3C750ubQwI5gwYKD+jQOugczAZD4z6uTZmjUMS8uW4rdQpsCi4Or100UJDw85LHfHguxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGXCGecD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGXCGecD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C2C433F1;
	Tue, 23 Jan 2024 01:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972055;
	bh=e75AmnpnwUH66IQcvlY2EXA0cJeQYxTLvNMldM5p5DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGXCGecDwImHJfXl3Rap/Jf3i2XdmKZQZhg8jh9VIlFhI8hjqkUdBFqYimQcOev2a
	 4to9t0OQccEqaRjG2dvqxK4pY3DQiz0Tos1KHbvopb2xVQYoKZsi9R6tQJZSFMdwHV
	 37r4d8YGuN2j2UeHGUyQodqSy3Rf5zDGi4Py+c2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/417] mptcp: relax check on MPC passive fallback
Date: Mon, 22 Jan 2024 15:59:25 -0800
Message-ID: <20240122235805.493070659@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f0ebf39db6cc..45d20e20cfc0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -713,7 +713,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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



