Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86923BC;
	Tue, 23 Jan 2024 02:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975775; cv=none; b=p03njUs/d52i7LnrLdr0Vx9XGHwy7m2FgwLkHyy1X1skT625ahbQim+gx+6c/ZirEU6DOb8FaZ9cVZ0qy7u/iqBiqR9/ThOB7kvyp1392SGKebT885dsxnxrPqDv+bAKKnjHc2N0qg/Kmt2Tf7bcwL8x9rgqOUtLeW9wfqTPKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975775; c=relaxed/simple;
	bh=0ueccccooU7cmZ6dxCv0Fz/D9H0GlCwcZ0He0GfRqjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOBe0oqhfrzBDnLEPaI9V7b+8GD0S199cQgTLnHDxq5n8xWYByY+Ij3OeHHkfuFIHIei4b4xf2d93smAmBwtsoqy/apX0zy4AHW5qzdxyZoF/jLGug7xsYD8I8/g6TWv5WiPHqgu7OYGjkfCWWabuNiDhlWgnwm1qMMm6fxMyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9RD8A/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9RD8A/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B48C433C7;
	Tue, 23 Jan 2024 02:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975775;
	bh=0ueccccooU7cmZ6dxCv0Fz/D9H0GlCwcZ0He0GfRqjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9RD8A/B9qherNqbSSCis3U0VZjxIzV7YLl9dnpm4g/Yg4AHAqga+LDMzYf9wpoU6
	 PxkMvl0zj4AjhYAuSAo8zt8owkWJDf8pdtjxbNtEn76gEyjwTkdhZicTSc/u1bzfvd
	 Rfwq+/Xla0YWy/+h4V5nr6UlEiz4Jw3a3phj0NR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 558/583] mptcp: relax check on MPC passive fallback
Date: Mon, 22 Jan 2024 16:00:09 -0800
Message-ID: <20240122235829.234875650@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 70b7a47a53c7..d3c5ecf8ddf5 100644
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



