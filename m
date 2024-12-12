Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00441487CD;
	Thu, 12 Dec 2024 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016930; cv=none; b=tEjJoV7SB+mXZ6FGCkVgY9S+Lyiazkh9fytJXjglIpulmiGG2H9yBglr4oIo110iaV162/k8Zsr4tar1HD/SmqBY+uZo+b6l725ZMovRg5MpMoBtHGv7LRXiePRL7VxLNKWITYwNuc0P3QaWW5UCphj5/YkFFNJwf+LA3x6yeog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016930; c=relaxed/simple;
	bh=4Wk7MNDw/UVotvqrlPyvVji7jVQuvQyphsAyoEkoDvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpK39KaGby8IyrhK9NbrNuVTn+5keImd6Pl+mqX5YpA0M2/N+o96XYPdMH6YlT6Amb/hrcC1g6Qh2jd2IHWMeoMDyO4tj4FAGwh8U89OuZXRNOMO/IqyOlEVgOhBEww8V9sEikSZmsjVB9EPlQj8gWVFqomw67PU4pHrJqbbC4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoMeWEWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoMeWEWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56549C4CEDD;
	Thu, 12 Dec 2024 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016929;
	bh=4Wk7MNDw/UVotvqrlPyvVji7jVQuvQyphsAyoEkoDvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoMeWEWqOmRZvP0whNQ8o6dJS1oVd+jy8iUZM8DioiHripflxN8cilvqKOdGTa/MF
	 GD+U0Tg2dL4JNkeuQ+YpWJfg4QpE0OQvF7qlMsKrvJvuCcf24YbbyDGyHdGvpA+5xT
	 6H4TeF4YaGsczZN1BPqOLf6aQYMYimY2whs+mMNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/466] mptcp: fix possible integer overflow in mptcp_reset_tout_timer
Date: Thu, 12 Dec 2024 15:58:25 +0100
Message-ID: <20241212144320.061468285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit b169e76ebad22cbd055101ee5aa1a7bed0e66606 ]

In 'mptcp_reset_tout_timer', promote 'probe_timestamp' to unsigned long
to avoid possible integer overflow. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Link: https://patch.msgid.link/20241107103657.1560536-1-d.kandybka@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 47ee616f69c2d..8a8e8fee337f5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2728,8 +2728,8 @@ void mptcp_reset_tout_timer(struct mptcp_sock *msk, unsigned long fail_tout)
 	if (!fail_tout && !inet_csk(sk)->icsk_mtup.probe_timestamp)
 		return;
 
-	close_timeout = inet_csk(sk)->icsk_mtup.probe_timestamp - tcp_jiffies32 + jiffies +
-			mptcp_close_timeout(sk);
+	close_timeout = (unsigned long)inet_csk(sk)->icsk_mtup.probe_timestamp -
+			tcp_jiffies32 + jiffies + mptcp_close_timeout(sk);
 
 	/* the close timeout takes precedence on the fail one, and here at least one of
 	 * them is active
-- 
2.43.0



