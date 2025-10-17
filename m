Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB3E330B31;
	Fri, 17 Oct 2025 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715689; cv=none; b=Rc28VPXc+vnZ52DaPoa3+upyjWR9/S9ma4M9+yM+p2gVdEQyR1R4AD+OhEqt2TBLrmCoKKI41Bm6dSl/3ebFW/SSmZwJSCMzsi9jpkBdZOJxMVdhIkPqYrdiqjoaaj+4lkkUPvaDNHHUe84c6JGZiZ7fK3QKH6XTMebfnbyWYyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715689; c=relaxed/simple;
	bh=vcZFqicQuewmRFP1MSS77/7+JoZLg/jacnGw/AD8uZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUAnY0JCHqXXvdRVvXsg9V7OTW9fLcx/Ol1i08vm2XG5qrdX0o5OIPdVvbNiJStT6ppS5pVZnxf1RZ4EIgYA0uU+sSHaLoNVVGklLFWFw3VUKCaFd0nLAmH2lEs9EWx81txc4ZAhCVXWMOPK9oYZbX2L+ZWOqyaL5BtluSIFEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IFsv55h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IFsv55h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E40C116B1;
	Fri, 17 Oct 2025 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715689;
	bh=vcZFqicQuewmRFP1MSS77/7+JoZLg/jacnGw/AD8uZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IFsv55h6W19e3INWDgd0WC5hovWshKG4Az1G7gQVtOFzXiKC9gg4J50LvyaPHjFb
	 timXKyqajjJMQbvn5aW/rE76n30a9sY/LgQMtFPJyyPgHDpNIjPcVlatElJcAw4Sdl
	 wtf7KrWcRLtnKZekz2gXlyw4NWQ9xXc3Jdnr3Lt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 302/371] mptcp: reset blackhole on success with non-loopback ifaces
Date: Fri, 17 Oct 2025 16:54:37 +0200
Message-ID: <20251017145213.001454570@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 833d4313bc1e9e194814917d23e8874d6b651649 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -507,7 +507,7 @@ void mptcp_active_enable(struct sock *sk
 		rcu_read_lock();
 		dst = __sk_dst_get(sk);
 		dev = dst ? dst_dev_rcu(dst) : NULL;
-		if (dev && (dev->flags & IFF_LOOPBACK))
+		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&pernet->active_disable_times, 0);
 		rcu_read_unlock();
 	}


