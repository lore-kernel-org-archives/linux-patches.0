Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF1279798;
	Tue, 21 Oct 2025 20:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077085; cv=none; b=pTaIkQNcBL/HKkGSh6V7sF3YGT9w7uO0j0iaa0VyFuihCNXiqR7/u09DYHW8JmEA/p6MPDtCVNjT1oU9qkIaNf2p104rURokoBonSKfs5woBUk2QRJz3VlNvM+Ih7cVHwy0mI6nW8s+3FgxWxnPI31XI//TAZ3aAmdaQo5pHqY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077085; c=relaxed/simple;
	bh=CnWiFk1hWaUMVb39rN87bwGECgIn1iUwBwNH7/7tL3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPSwSW/JRPKrhwh8ZrbDhlaMBZVh90NV48i3TcgX54u6PEU+M81ToUJ9B0t3wKFVEkh1h1ILHS0HttOlAmOEiY7qnK7jojMWXYF9ahAiDWV0/d4ulREnLLKY26EaTrbVNYZ0JgG5FBDPc+vM6WwFqgvuk4FP3hPK4LWZQrKvebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZBNlYZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZBNlYZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48180C4CEF1;
	Tue, 21 Oct 2025 20:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077084;
	bh=CnWiFk1hWaUMVb39rN87bwGECgIn1iUwBwNH7/7tL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZBNlYZBc2EeW1/1MSgeNMZbLcqX2fn3ETLDa2qeGvC9P3azuSqsNxw3kJal2W7eR
	 0w4nNRk4ebyM2/Ra1vhHgv1CahK6xFRz3iuwJxcET95uqEy1zta7QiXz0EusdApH2V
	 TkU2qqhkejWwqhdq+uheoIef8jtfHRkaFK7yJMAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/136] mptcp: reset blackhole on success with non-loopback ifaces
Date: Tue, 21 Oct 2025 21:51:58 +0200
Message-ID: <20251021195039.113858824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

[ Upstream commit 833d4313bc1e9e194814917d23e8874d6b651649 ]

When a first MPTCP connection gets successfully established after a
blackhole period, 'active_disable_times' was supposed to be reset when
this connection was done via any non-loopback interfaces.

Unfortunately, the opposite condition was checked: only reset when the
connection was established via a loopback interface. Fixing this by
simply looking at the opposite.

This is similar to what is done with TCP FastOpen, see
tcp_fastopen_active_disable_ofo_check().

This patch is a follow-up of a previous discussion linked to commit
893c49a78d9f ("mptcp: Use __sk_dst_get() and dst_dev_rcu() in
mptcp_active_enable()."), see [1].

Fixes: 27069e7cb3d1 ("mptcp: disable active MPTCP in case of blackhole")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/4209a283-8822-47bd-95b7-87e96d9b7ea3@kernel.org [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250918-net-next-mptcp-blackhole-reset-loopback-v1-1-bf5818326639@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -387,7 +387,7 @@ void mptcp_active_enable(struct sock *sk
 		rcu_read_lock();
 		dst = __sk_dst_get(sk);
 		dev = dst ? dst_dev_rcu(dst) : NULL;
-		if (dev && (dev->flags & IFF_LOOPBACK))
+		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&pernet->active_disable_times, 0);
 		rcu_read_unlock();
 	}


