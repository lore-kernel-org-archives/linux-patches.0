Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F41257827;
	Tue, 16 Jun 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632515; cv=none; b=bmgK4H91FIQVP/vyl0Ka64nhgaUO3wQ3i0p9gWb81lQsAc2C7n85m26bqcSV7IPBf4VnDOowvflpaC6TEnLsjvcHWi4Y3EG8BHNVBNrGdiuQZjLzb9+8EjM/hWCpJgy9uSqdId6WvMRQwz+ZV52xCfau+AHjqWjfoIPktEqNHC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632515; c=relaxed/simple;
	bh=djSPV24qU94eD23D6Hbfxmcg3YWaLgMOaASSkTLh8LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJiaoAVBEMkgUfxKTw/IFjQe4gHigo/Nvg5zd2n7Jgxr0hHkzWhxBVBFnecQHqttK2lPXKI4CTnUASRfi+M3lprp6mPKueKz2TMi2ChoKixjf3BkuEm89UFKEkW99GjnVZ1Y2wYi+fLZoj/rFqehLhko5hJTAjPK9UCDp2Qq87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9S6C6LX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9S6C6LX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF4B1F000E9;
	Tue, 16 Jun 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632514;
	bh=PrcNM+3vRPBWDdaEGZ9jZ3rqq/t1RGZNXMYYTxzYmQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9S6C6LX57KIN6eC5uIdOsZUho2i1rXbYnR4ZcXskZMqpC37CTai1sNg7g3K6+HCS
	 HVualmjS7rXZb4xi5eu3EqKiuAG0v8INA2MS2HNSqy9DbMzk9a6RJ8MBKtmxVVi0w3
	 2cxg4Xc00HFKUWfS7xbmzCHWuasTkZzatT/CJ0Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 425/522] mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker
Date: Tue, 16 Jun 2026 20:29:32 +0530
Message-ID: <20260616145145.868507083@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 3cf12492891c4b5ff54dda404a2de4ec54c9e1b5 ]

When an ADD_ADDR needs to be retransmitted and another one has already
been prepared -- e.g. multiple ADD_ADDRs have been sent in a row and
need to be retransmitted later -- this additional retransmission will
need to wait.

In this case, the timer was reset to TCP_RTO_MAX / 8, which is ~15
seconds. This delay is unnecessary long: it should just be rescheduled
at the next opportunity, e.g. after the retransmission timeout.

Without this modification, some issues can be seen from time to time in
the selftests when multiple ADD_ADDRs are sent, and the host takes time
to process them, e.g. the "signal addresses, ADD_ADDR timeout" MPTCP
Join selftest, especially with a debug kernel config.

Note that on older kernels, 'timeout' is not available. It should be
enough to replace it by one second (HZ).

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-6-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ replaced `TCP_RTO_MAX / 8` with `HZ` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -323,7 +323,7 @@ static void mptcp_pm_add_timer(struct ti
 	}
 
 	if (mptcp_pm_should_add_signal_addr(msk)) {
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		sk_reset_timer(sk, timer, jiffies + HZ);
 		goto out;
 	}
 


