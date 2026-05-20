Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8433EF0D7;
	Wed, 20 May 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301729; cv=none; b=C4BN2rLgHKk2AxcQFxHl8bfii7f6Q4cgvf3zcaqNrklWCuq/3yXDjEjACf+8WiKDz73/WyUQ3ic4WryWln+OYIe+bs7J934ugYBz4hQ/Ryr1GXspwlerwT5xLDe+bgzYNYk3QzFLur1yBUq9L5e9F3bLr37yIXzkdQJkpfttax8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301729; c=relaxed/simple;
	bh=lh23AFZCValWGwBPAlzWZlzxL6/pxPB6NmFgJk6i5dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBW+9MbrrDLXP6aXggSYJ7D0XvmqmGyo/asUZRADRWBxtR4uj1KkJ2xQ3RdMOwMaBH83KBWTiTxpo0l0haOU2GtV0r3MMXTQvgr2KMmBOQfjYhQeVC0cDDQUcnhaleJfVOTzEcKYzeJoKmAJtTepkVUOwQehlqzG30RCFIMgf3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhhdrY1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhhdrY1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360C51F00897;
	Wed, 20 May 2026 18:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301728;
	bh=UwOpTJuaHabs9RXC3OdPshLIZ5cfkJe5Q0XW8qVbJ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KhhdrY1E4FW+KqhrwOzAGW+QScT9DvU6Qp2YIbx3pg1cZg0Z7Fj1nj5X127hfJLS3
	 z3EYgzF2CKJhiqInoG7lK5MLyyiMMA7VpRRY8N71unBk2aFWt9Kd0HiR7yKWZM9NBM
	 gXoeb9+K9jm/61Xbd9iQ1v8EsZoce1jeg/hCGHmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 666/666] mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker
Date: Wed, 20 May 2026 18:24:37 +0200
Message-ID: <20260520162125.726568295@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,7 +315,7 @@ static void mptcp_pm_add_timer(struct ti
 	}
 
 	if (mptcp_pm_should_add_signal_addr(msk)) {
-		sk_reset_timer(sk, timer, jiffies + TCP_RTO_MAX / 8);
+		sk_reset_timer(sk, timer, jiffies + HZ);
 		goto out;
 	}
 


