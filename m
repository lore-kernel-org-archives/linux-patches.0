Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0B7221D88;
	Thu, 12 Dec 2024 15:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018813; cv=none; b=Sg+F91Tq+yvBIuzIrfxaoBvdLfVcMvOdS3vVRJzZWOUQaHmN++PYcfElHiluvGIAMLdrHCQHZ62JAYPjBjL56avq6GbTj9Q4l1nkYMpS0+M9SeHaszubEEv5b4I6WMRg9swH0MEHi6jcYlE18gcZf/f7tcyI7DEH6nJlarqCQEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018813; c=relaxed/simple;
	bh=P6I4FmMQ7S3f2BdVQOZnjpSCkxIjkUyK6YPhNtU4W7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6H4NARESUPY98ZVgY6YD5xcMFeK4vOAr/CCtiNGzxDv47EwDh5YPLrqe5zH5fUCE3h2j6WHN86Uw/Tg3SSbRZPhxDGH2Nb9PpAK3JDoTCWjMgyKtUHTxW0KNO0x7IOws/E7n4zfzH23PphLiFGCYBKtYJ2Ml6dkiOgynxnP9nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss3Z3OW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss3Z3OW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B79C4CECE;
	Thu, 12 Dec 2024 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018812;
	bh=P6I4FmMQ7S3f2BdVQOZnjpSCkxIjkUyK6YPhNtU4W7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss3Z3OW6DazFAhibu6BJaQ/MXwt/GJIRwIZhSRyyt2Ya5ZZNdZpsvy0+mMzAvOyoS
	 Bqi22IBOQFs5ztGoCawIMcFWfMoAVLOHYZ9e5WAFpCWn+wBvsKtTBn31n8Z4Rxv8dj
	 XaZlb7G4n+B7q2Kcs6hxXFRcpnrxfAYzusIBSdsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/772] mptcp: fix possible integer overflow in mptcp_reset_tout_timer
Date: Thu, 12 Dec 2024 15:49:46 +0100
Message-ID: <20241212144351.632957316@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Dmitry Kandybka <d.kandybka@gmail.com>

commit b169e76ebad22cbd055101ee5aa1a7bed0e66606 upstream.

In 'mptcp_reset_tout_timer', promote 'probe_timestamp' to unsigned long
to avoid possible integer overflow. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Link: https://patch.msgid.link/20241107103657.1560536-1-d.kandybka@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in this version because commit d866ae9aaa43 ("mptcp: add a
  new sysctl for make after break timeout") is not in this version, and
  replaced TCP_TIMEWAIT_LEN in the expression. The fix can still be
  applied the same way: by forcing a cast to unsigned long for the first
  item. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1acd4e37a0ea6..370afcac26234 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2708,8 +2708,8 @@ void mptcp_reset_tout_timer(struct mptcp_sock *msk, unsigned long fail_tout)
 	if (!fail_tout && !inet_csk(sk)->icsk_mtup.probe_timestamp)
 		return;
 
-	close_timeout = inet_csk(sk)->icsk_mtup.probe_timestamp - tcp_jiffies32 + jiffies +
-			TCP_TIMEWAIT_LEN;
+	close_timeout = (unsigned long)inet_csk(sk)->icsk_mtup.probe_timestamp -
+			tcp_jiffies32 + jiffies + TCP_TIMEWAIT_LEN;
 
 	/* the close timeout takes precedence on the fail one, and here at least one of
 	 * them is active
-- 
2.43.0



