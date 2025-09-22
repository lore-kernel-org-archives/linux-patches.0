Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8C25F780;
	Mon, 22 Sep 2025 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569862; cv=none; b=IZ3tr6+fI3DNBwCjcGhm4EgrqnqaI3x6clsn2pIWH/hU9GXiDSSZN/+b8B+h2BMlQhbStLhIz4Rx/kIuc4kG5gFBjQSsxkAyYZyDQysk4WQ9DOot5YcwBm6WECAHXLVHYmI1eSTHM+hMR094X0LhUHe8fnGKuXPQrv1tpYT9U6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569862; c=relaxed/simple;
	bh=0d16DfxHNVv9CqH1SHLM5zkuCpS9758pKV5Go8pMbt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR4059Hf90rO50cUTwhKlV0UNEjyjfKoxpl4wVxd8IVzWMFIw8xJEfpRYXgrbdkc6P13ombK/c6A5zg0sRw+2p2Iyd3mBpCI9qDSGyAKKhLoiSb1qo4AVPo8isTrZKBrsfdNqxQpCZngSMDTh+KAv5eI0mTRUzp3RPumeTERFzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liGXv4iF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liGXv4iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11ECC113D0;
	Mon, 22 Sep 2025 19:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569862;
	bh=0d16DfxHNVv9CqH1SHLM5zkuCpS9758pKV5Go8pMbt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liGXv4iFeSkejJt2cGguuLnK5glchp2Yx+pPfRbHRPHJ4r+ClH4z2LueZKFuWs4Qp
	 nZloaeaf+PUl4QjkTtt58NFqc1aOTOHxCtkKmAkaFBAsnr9OHAkI7nbLB5AVXM/BRj
	 AqEOJ9kaBtNSr6hKhe3E7SkYMZxusKGsRW18Qw7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/105] mptcp: tfo: record deny join id0 info
Date: Mon, 22 Sep 2025 21:29:00 +0200
Message-ID: <20250922192409.361545037@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 92da495cb65719583aa06bc946aeb18a10e1e6e2 ]

When TFO is used, the check to see if the 'C' flag (deny join id0) was
set was bypassed.

This flag can be set when TFO is used, so the check should also be done
when TFO is used.

Note that the set_fully_established label is also used when a 4th ACK is
received. In this case, deny_join_id0 will not be set.

Fixes: dfc8d0603033 ("mptcp: implement delayed seq generation for passive fastopen")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-4-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 7d4718a57bdcc..479a3bfa87aa2 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -985,13 +985,13 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 		return false;
 	}
 
-	if (mp_opt->deny_join_id0)
-		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
-
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 
 set_fully_established:
+	if (mp_opt->deny_join_id0)
+		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
+
 	mptcp_data_lock((struct sock *)msk);
 	__mptcp_subflow_fully_established(msk, subflow, mp_opt);
 	mptcp_data_unlock((struct sock *)msk);
-- 
2.51.0



