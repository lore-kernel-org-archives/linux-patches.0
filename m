Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67771FBEB9;
	Fri,  6 Dec 2024 14:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496698; cv=none; b=MBl75K04lSyBtjHTAC76/UqwOkvRbsv5rZ8m8GMfc6nzonEhqF3vY2A8LGKFritTvQj3CUe3szf0munojlM/IYiUDxEA2UtvcLj9gbIiFCtW+SvQ1f4YizfUe7+DPFq6bxt/AMXKsaPTIMPPAi7yBzVDrqBnSn5Ljz5/kvPc1y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496698; c=relaxed/simple;
	bh=LiAqcIR9bCL6nMo5McySyRgUqBZrpL059ceUC1QAsvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDh+viw+CAdZ8wPLolJ68PDKK7j91OCrYK1SRM3BP7BMxJhPGadnlDJ0O2HQG+7/1kBTNWixyik3FwbwCVFoD/IHidhdtt2JU6IbOm7ySdnsSUcq6g4dAeuqfCRo/mbNn7VB63DJs8L5ZLpUi3GX1QO5F+SlvFlXnaZ5yIxKR8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy36sAci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy36sAci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50368C4CED1;
	Fri,  6 Dec 2024 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496698;
	bh=LiAqcIR9bCL6nMo5McySyRgUqBZrpL059ceUC1QAsvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sy36sAciSEpEm3SbanVDrhPi6Vg1mA8drbfPHeCP9S2M5b3hosoyPdz4rgjDnt7GS
	 dSFeF3yhhP0Y8OErmJsClD5/7HFKU9R3o9g8/ek3Nuj8J3HW4uXjpSfXcfqQQOsdo0
	 8jd83sros1/Ic5S+tsIlV5944Yg2eIVORVNREu3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/676] mptcp: fix possible integer overflow in mptcp_reset_tout_timer
Date: Fri,  6 Dec 2024 15:27:46 +0100
Message-ID: <20241206143655.191874270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index b8357d7c6b3a1..01f6ce970918c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2691,8 +2691,8 @@ void mptcp_reset_tout_timer(struct mptcp_sock *msk, unsigned long fail_tout)
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



